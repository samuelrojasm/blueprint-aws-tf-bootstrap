# terraform/sandboxes/iac-security-scans/iam-management/main.tf

# ---------------------------------------------------------------
# Crea la identidad (IAM)
#   1. Usa el modulo identity_factory
#   2. Manda el yaml con los repositorios de Git Hub y su política de acceso
#   3. Manda los roles de OIDC en un json
# ---------------------------------------------------------------
module "identity_factory" {
  source          = "../../../modules/iam-factory"
  repositories    = yamldecode(file("config/repositories.yaml"))
  policy_template = "${path.module}/policy/oidc_assume_role.json.tftpl"
}

terraform {
  backend "s3" {} # Los valores se pasan en el init
}

# --