# terraform/modules/storage/s3-backend-tfstate/variables.tf

#----------------------------------------
# VARIABLES - MÓDULO: s3-backernd-tfstate
#----------------------------------------

variable "bucket_name" {
  description = "Nombre del Bucket"
  type        = string
}

# ---