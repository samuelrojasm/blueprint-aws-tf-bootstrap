# terraform/modules/iam-factory/main.tf

locals {
  # Crea una lista de objetos {role, policy} para poder iterar
  # Para adjuntar una lista de políticas a cada rol, crea una lista plana de combinaciones "Rol-Política
  role_policy_pairs = flatten([
    for repo_key, repo_data in var.repositories.repositories : [
      for policy_arn in repo_data.managed_policy_arns : {
        role_name  = repo_key
        policy_arn = policy_arn
      }
    ]
  ])
}

data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}


# Creación de Roles
resource "aws_iam_role" "this" {
  # Accedemos a var.repositories.repositories porque el YAML tiene esa llave raíz  
  for_each = var.repositories.repositories

  name        = "github-role-${each.key}"
  description = each.value.description

  # Inyectamos los datos del YAML y del Provider en el JSON externo
  assume_role_policy = templatefile(var.policy_template, {
    provider_arn = data.aws_iam_openid_connect_provider.github.arn
    github_repo  = each.value.github_full_name
  })

  tags = {
    Repository = each.value.github_full_name
    ManagedBy  = "Terraform"
  }
}

# Adjuntar las Políticas (Multi-Policy)
resource "aws_iam_role_policy_attachment" "attachments" {
  # Convertimos la lista plana en un mapa con llaves únicas
  for_each = {
    for pair in local.role_policy_pairs : "${pair.role_name}-${pair.policy_arn}" => pair
  }

  role       = aws_iam_role.this[each.value.role_name].name
  policy_arn = each.value.policy_arn
}

# ---