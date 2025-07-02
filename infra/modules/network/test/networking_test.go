package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestVPCSingleAZ(t *testing.T) {
	t.Parallel()

	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, ROOT_FOLDER, MODULE_FOLDER)
	terraformOptions := &terraform.Options{
		TerraformBinary: TERRAFORM_BINARY,
		TerraformDir:    tempTestFolder,
		Vars: map[string]any{
			"cidr_block":       "10.0.0.0/16",
			"name":             "test-vpc-single-az",
			"internet_gateway": true,
			"azs_count":        1,
			"environment":      "test",
			"region":           "ap-northeast-1",
		},
	}

	defer test_structure.RunTestStage(t, "cleanup", func() {
		terraform.Destroy(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "plan", func() {
		terraform.InitAndPlan(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "apply", func() {
		terraform.Apply(t, terraformOptions)

		vpc_id := terraform.Output(t, terraformOptions, "vpc_id")
		if vpc_id == "" {
			t.Fatal("Expected VPC ID to be non-empty")
		}

		subnet_cidrs := terraform.OutputList(t, terraformOptions, "subnet_cidr_blocks")
		if len(subnet_cidrs) != 1 {
			t.Fatalf("Expected 1 subnet CIDR, got %d\n%+v", len(subnet_cidrs), subnet_cidrs)
		}

		subnet_cidr := subnet_cidrs[0]
		expectedCidr := "10.0.0.0/16"
		if subnet_cidr != expectedCidr {
			t.Fatalf("Expected subnet CIDR to be %s, got %s", expectedCidr, subnet_cidr)
		}
	})
}

func TestVPCThreeAZs(t *testing.T) {
	t.Parallel()

	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, ROOT_FOLDER, MODULE_FOLDER)
	terraformOptions := &terraform.Options{
		TerraformBinary: TERRAFORM_BINARY,
		TerraformDir:    tempTestFolder,
		Vars: map[string]any{
			"cidr_block":       "20.0.0.0/16",
			"name":             "test-vpc-three-azs",
			"internet_gateway": true,
			"azs_count":        3,
			"environment":      "test",
			"region":           "ap-northeast-1",
		},
	}

	defer test_structure.RunTestStage(t, "cleanup", func() {
		terraform.Destroy(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "plan", func() {
		terraform.InitAndPlan(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "apply", func() {
		terraform.Apply(t, terraformOptions)

		vpc_id := terraform.Output(t, terraformOptions, "vpc_id")
		if vpc_id == "" {
			t.Fatal("Expected VPC ID to be non-empty")
		}

		subnet_cidrs := terraform.OutputList(t, terraformOptions, "subnet_cidr_blocks")
		if len(subnet_cidrs) != 3 {
			t.Fatalf("Expected 1 subnet CIDR, got %d", len(subnet_cidrs))
		}
		firstSubnetCidr := subnet_cidrs[0]
		secondSubnetCidr := subnet_cidrs[1]
		thirdSubnetCidr := subnet_cidrs[2]

		exepectedFirstCidr := "20.0.0.0/18"
		if firstSubnetCidr != exepectedFirstCidr {
			t.Fatalf("Expected first subnet CIDR to be %s, got %s", exepectedFirstCidr, firstSubnetCidr)
		}

		expectedSecondCidr := "20.0.64.0/18"
		if secondSubnetCidr != expectedSecondCidr {
			t.Fatalf("Expected second subnet CIDR to be %s, got %s", expectedSecondCidr, secondSubnetCidr)
		}

		expectedThirdCidr := "20.0.128.0/18"
		if thirdSubnetCidr != expectedThirdCidr {
			t.Fatalf("Expected third subnet CIDR to be %s, got %s", expectedThirdCidr, thirdSubnetCidr)
		}
	})
}
