# terraform/sandboxes/iac-security-scans/iam-management/providers.tf

# ---------------------------------------------------------------
# Variables
# ---------------------------------------------------------------

# Sin valor por defecto: Si el pipeline no envía la variable, Terraform se detiene.
variable "aws_region" {
  description = "Región que usa el provider AWS"
  type        = string
}

# ---