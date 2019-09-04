package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
)

func TestAppNetworkExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// You should update this relative path to point at your mysql
		// example directory!
		TerraformDir: "../modules/app_network_test",
		Vars: map[string]interface{}{
			"environment":     "test",
			"region":          "europe-north1",
			"project_name":    "learned-acolyte-221721",
			"path_to_context": "/Users/sergii.marchenko/work/keys/gcp/Iegor-072a850167f3.json",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
