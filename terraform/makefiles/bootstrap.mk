# terraform/makefiles/bootstrap.mk

# -----------------------------------------------------------------------------
# MAKEFILE - CAPA 0: BOOTSTRAP
# -----------------------------------------------------------------------------
# Makefile inicializa la infraestructura:
#	-  Backend remoto para resguardar el archivo terraform.tfstate (Inmutable)
#	-  IAM OIDC IdP de Git Hub (solo se configura uno por cuenta)
# Uso: 
#	make sandbox-init NAME=experimento-s3
# -----------------------------------------------------------------------------

# Comandos de Bootstrap
.PHONY: bootstrap-init bootstrap-plan bootstrap-apply bootstrap-output bootstrap-destroy

# Inicialización con caché (Garantiza que el volumen existe)
bootstrap-init: sanitize setup-cache check-auth ## Inicializa Terraform y descarga proveedores en caché
	@echo "🚀 Inicializando Bootstrap en $(BOOTSTRAP_PATH)..."
	@$(DOCKER_TF) -chdir=$(BOOTSTRAP_PATH) init

bootstrap-plan: sanitize check-auth ## Muestra el plan de ejecución de Terraform
	@$(DOCKER_TF) -chdir=$(BOOTSTRAP_PATH) plan

bootstrap-apply: sanitize confirm check-auth
	@echo "🏗️ Creando infraestructura de estado (S3) y OIDC IdP Git Hub (IAM)..."
	@$(DOCKER_TF) -chdir=$(BOOTSTRAP_PATH) apply -auto-approve

bootstrap-output: 
	@$(DOCKER_TERRAFORM) -chdir=$(BOOTSTRAP_PATH) output

bootstrap-destroy: sanitize check-auth ## Destruye los recursos generados
	@$(DOCKER_TF) -chdir=$(BOOTSTRAP_PATH) destroy -auto-approve

bootstrap-state-list: sanitize check-auth ## Muestra los nombres e IDs de los recursos
	@$(DOCKER_TF) -chdir=$(BOOTSTRAP_PATH) state list

 # ---
