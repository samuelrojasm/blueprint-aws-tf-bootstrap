# terraform/environments/dev/bootstrap/version.tf

# --------------------------------
# VERSIONES - CAPA 0: BOOTSTRAP
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
