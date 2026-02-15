# terraform/modules/iam-factory/outputs.tf

output "github_role_arns" {
  description = "Mapa de ARNs de los roles IAM para GitHub OIDC"
  value = {
    for k, role in aws_iam_role.this : k => role.arn
  }
}

# ---