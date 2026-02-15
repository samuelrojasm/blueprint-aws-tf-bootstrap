# terraform/environments/dev/bootstrap/providers.tf

# -----------------------------
# PROVIDERS - CAPA 0: BOOTSTRAP
# -----------------------------

# ------------
# AWS Provider
# ------------
provider "aws" {
  region  = var.aws_region # Región de AWS donde se crean los recursos
  profile = ""             # Nombre del perfil configurado en AWS CLI con IAM Identity Center (valor esperado de Makefile)

  default_tags {
    tags = {
      Component = "bootstrap"
      Owner     = "Plataforma"
      ManagedBy = "Terraform"
    }
  }
}

# ---