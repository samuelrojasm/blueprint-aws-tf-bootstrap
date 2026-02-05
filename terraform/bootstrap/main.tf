# terraform/environments/dev/bootstrap/main.tf

# -----------------------------------------------------
# CAPA 0: BOOTSTRAP - Dev Environment
# -----------------------------------------------------
# Crea:
#   - S3 bucket  para almacenar el estado de Terraform
#   - IAM OIDC IdP de GitHub
# Nota: Este código se ejecuta UNA SOLA VEZ por ambiente
# -----------------------------------------------------

# -----------------------------------------------------
# MÓDULO: S3 Backend para terraform.tfstate (Inmutable)
# -----------------------------------------------------
module "s3_backend" {
  source      = "../modules/storage/s3-backend-tfstate"
  bucket_name = "${var.bucket_name}"
}

# ---------------------------------------------------------------------
# IAM OIDC IdP de GitHub (solo se configura uno por cuenta)
#   - Nota: Es requisito para crear los Roles de AWS para GitHub Actions
# ----------------------------------------------------------------------
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
   client_id_list = ["sts.amazonaws.com"]
 
  tags = {
   # Name    = "${var.}"
   # Service = "${var.service}"
  }
}

# ---


