
# terraform/environments/dev/bootstrap/variables.tf

# --------------------------------
# VARIABLES - CAPA 0: BOOTSTRAP
# --------------------------------

variable "aws_region" {
  description = "Región que usa el provider AWS"
  type        = string
  # Sin valor por defecto
}

variable "bucket_name" {
  description = "Nombre del Bucket"
  type        = string
  # Sin valor por defecto
}

# ---