# terraform/makefiles/sandbox.mk

# -----------------------------------------------------------------------------
# MAKEFILE - CAPA 0: BOOTSTRAP
# -----------------------------------------------------------------------------
# Makefile inicializa la infraestructura:
#	-  Backend remoto para resguardar el archivo terraform.tfstate (Inmutable)
#	-  IAM OIDC IdP de Git Hub (solo se configura uno por cuenta)
# Uso: 
#	make sandbox-init NAME=experimento-s3
# -----------------------------------------------------------------------------

# Ruta base para los sandboxes
SANDBOX_BASE_PATH = terraform/sandboxes/$(NAME)
MY_USER = $(shell whoami)

.PHONY: sandbox-init sandbox-apply

sandbox-init:
	@# Validar que se pasó el nombre del experimento
	@if [ -z "$(NAME)" ]; then echo "❌ Error: Debes pasar NAME=tu-experimento"; exit 1; fi
	
	@# Obtener dinámicamente el bucket del bootstrap
	$(eval BUCKET=$(shell $(TERRAFORM) -chdir=terraform/bootstrap output -raw bucket_name))
	
	@echo "🛠️ Inicializando Sandbox [$(NAME)] para $(MY_USER)..."
	$(TERRAFORM) -chdir=$(SANDBOX_BASE_PATH) init \
		-backend-config="bucket=$(BUCKET)" \
		-backend-config="key=sandboxes/$(MY_USER)/$(NAME)/terraform.tfstate" \
		-backend-config="region=$(REGION)" \
		-backend-config="encrypt=true"
# falta -reconfigure o hay otro validar

sandbox-apply:
	@if [ -z "$(NAME)" ]; then echo "❌ Error: Debes pasar NAME=tu-experimento"; exit 1; fi
	$(TERRAFORM) -chdir=$(SANDBOX_BASE_PATH) apply -auto-approve

# ---