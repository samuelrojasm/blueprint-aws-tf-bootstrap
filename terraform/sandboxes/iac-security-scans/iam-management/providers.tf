# terraform/sandboxes/iac-security-scans/iam-management/providers.tf


# ---------------------------------------------------------------
# Configuración del proveedor AWS
# ---------------------------------------------------------------
provider "aws" {
  region = var.aws_region # Región de AWS donde se crean los recursos

  default_tags {
    tags = {
      Component = "bootstrap-iam-roles-oidc"
      Owner     = "Plataforma"
      ManagedBy = "Terraform"
    }
  }

}

# ---