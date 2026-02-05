
# terraform/environments/dev/bootstrap/outputs.tf

# ----------------------------
# OUTPUTS - CAPA 0: BOOTSTRAP
# ----------------------------

#-----------------------------------------------------
# Outputs del Bucket S3
#-----------------------------------------------------
output "state_bucket_name" {
    description = "Nombre del bucket S3 para estado"
    value = module.s3_backend.state_bucket_name
}

output "state_bucket_arn" {
  description = "ARN del bucket S3"
  value = module.s3_backend.state_bucket_arn
}

output "aws_region" {
  description = "Región de AWS en donde reside el bucket"
  value       = module.s3_backend.aws_region
}

#-----------------------------------------------------
# Outputs del OIDP de Git Hub
#-----------------------------------------------------
output "github_oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.github.arn
  description = "ARN del proveedor OIDC de GitHub"
}

# ---