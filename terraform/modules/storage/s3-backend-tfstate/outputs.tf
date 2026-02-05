# terraform/modules/storage/s3-backend-tfstate/outputs.tf

#----------------------------------------
# OUTPUTS - MÓDULO: s3-backernd-tfstate
#----------------------------------------

output "state_bucket_name" {
    description = "Nombre del bucket S3 para estado"
    value = aws_s3_bucket.bucket_tf_state.id
}

output "state_bucket_arn" {
  description = "ARN del bucket S3"
  value = aws_s3_bucket.bucket_tf_state.arn
}

output "aws_region" {
  description = "Región de AWS en donde reside el bucket"
  value       = aws_s3_bucket.bucket_tf_state.bucket_region
}

# ---