package test

import "os"

const (
	ROOT_FOLDER   = "../../../../"
	MODULE_FOLDER = "infra/modules/network/"
)

var TERRAFORM_BINARY = os.Getenv("TF_LOCAL")
