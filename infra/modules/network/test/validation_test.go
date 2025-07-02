package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestValidationSuccess(t *testing.T) {
	t.Parallel()

	filesFolder := "test/inputValidations/success"
	varsFileList := []string{
		"all_vars.tfvars",
		"require_vars_only.tfvars",
	}

	for _, varsFile := range varsFileList {
		t.Run(varsFile, func(t *testing.T) {
			t.Parallel()

			tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, ROOT_FOLDER, MODULE_FOLDER)
			terraformOptions := &terraform.Options{
				TerraformBinary: TERRAFORM_BINARY,
				TerraformDir:    tempTestFolder,
				VarFiles: []string{
					filesFolder + "/" + varsFile,
				},
			}
			terraform.InitAndPlanE(t, terraformOptions)
		})

	}
}

func TestValidationFail(t *testing.T) {
	t.Parallel()

	filesFolder := "test/inputValidations/fail"
	varsFileList := []string{
		"no_name.tfvars",
		"invalid_cidr_1.tfvars",
		"invalid_cidr_2.tfvars",
		"invalid_cidr_3.tfvars",
		"invalid_azs_count.tfvars",
	}

	for _, varsFile := range varsFileList {
		t.Run(varsFile, func(t *testing.T) {
			t.Parallel()

			tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, ROOT_FOLDER, MODULE_FOLDER)
			terraformOptions := &terraform.Options{
				TerraformBinary: TERRAFORM_BINARY,
				TerraformDir:    tempTestFolder,
				VarFiles: []string{
					filesFolder + "/" + varsFile,
				},
			}
			_, err := terraform.InitAndPlanE(t, terraformOptions)
			if err == nil {
				t.Fatalf("Expected error for vars file %s, but got none", varsFile)
			}
		})

	}
}
