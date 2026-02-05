
# terraform/modules/iam-factory/variables.tf

 # Carga de la configuración de repositorios
variable "repositories" {
  description = "Mapa o lista de repositorios decodificados desde el archivo YAML"
  type        = any 
  validation {
    condition     = length(var.repositories) > 0
    error_message = "El archivo de repositorios no puede estar vacío."
  }
  # Se usa 'any' porque yamldecode genera una estructura dinámica (mapas/listas anidadas)
}

# Ruta base para las políticas
variable "policy_template" {
  description = "Ruta al archivo de plantilla JSON para la política de confianza"
  type        = string
}

# ---
