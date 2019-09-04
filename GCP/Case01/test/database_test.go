package test

import (
	"database/sql"
	"fmt"
	"github.com/gruntwork-io/terratest/modules/terraform"
	_ "github.com/lib/pq"
	"log"
	"testing"
)

func TestDatabaseExample(t *testing.T) {
	t.Parallel()

	// Set default list of IPs to whitelist
	listOfIPs := []string{"178.151.244.26", "178.151.244.28"}

	terraformOptions := &terraform.Options{
		// You should update this relative path to point at your mysql
		// example directory!
		TerraformDir: "../modules/database_test",
		Vars: map[string]interface{}{
			"environment":     "test",
			"region":          "europe-north1",
			"whitelist":       listOfIPs,
			"project_name":    "learned-acolyte-221721",
			"path_to_context": "/Users/sergii.marchenko/work/keys/gcp/Iegor-072a850167f3.json",
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Test connection to Database

	// Get output data as db user, IP
	dataBaseIP := terraform.OutputRequired(t, terraformOptions, "database_ip")
	adminpass := terraform.OutputRequired(t, terraformOptions, "sqladminpassword")

	fmt.Println("Logging into the database")
	connStr := "postgres://sqladmin:" + adminpass + "@" + dataBaseIP + "/peopleDatabase?sslmode=disable"
	db, err := sql.Open("postgres", connStr)
	defer db.Close()

	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Trying to ping the database")

	err = db.Ping()

	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Ping DB has just finished")
}
