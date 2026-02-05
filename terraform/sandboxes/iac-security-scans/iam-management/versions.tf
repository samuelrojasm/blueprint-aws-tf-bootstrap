# terraform/sandboxes/iac-security-scans/iam-management/versions.tf

# --------------------------------
# VERSIONES - IAM OIDC
# --------------------------------

terraform {
  required_version = ">= 1.14.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# --- 