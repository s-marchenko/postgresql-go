package test

import (
	"database/sql"
	"github.com/gruntwork-io/terratest/modules/terraform"
	_ "github.com/lib/pq"
	"log"
	"testing"
)

func TestDatabaseExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// You should update this relative path to point at your mysql
		// example directory!
		TerraformDir: "../database_test",
		Vars: map[string]interface{}{
			"environment": "test",
			"region":      "europe-north1",
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Test connection to Database

	// Get output data as db user, IP
	dataBaseIP := terraform.OutputRequired(t, terraformOptions, "database_ip")
	adminpass := terraform.OutputRequired(t, terraformOptions, "sqladminpassword")

	connStr := "postgres://sqladmin:" + adminpass + "@" + dataBaseIP + "/peopleDatabase?sslmode=disable"
	db, err := sql.Open("postgres", connStr)

	if err != nil {
		log.Fatal(err)
	}

	err = db.Ping()

	if err != nil {
		log.Fatal(err)
	}
	print("Ping DB has just finished")
	defer db.Close()
}
