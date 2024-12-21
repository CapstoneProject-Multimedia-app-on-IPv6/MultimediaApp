package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func EC2ExistTest(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	publicEC2Instance := terraform.Output(t, terraformOptions, "public_ec2_instance_ip")
	privateEC2Instance := terraform.Output(t, terraformOptions, "private_ec2_instance_id")

	assert.NotEmpty(t, publicEC2Instance)
	assert.NotEmpty(t, privateEC2Instance)

}
