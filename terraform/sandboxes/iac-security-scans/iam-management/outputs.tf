# terraform/sandboxes/iac-security-scans/iam-management/outputs.tf

output "final_role_arns" {
  description = "ARN de los roles de IAM para GitHub Actions"
  value = module.identity_factory.github_role_arns
}

# ---