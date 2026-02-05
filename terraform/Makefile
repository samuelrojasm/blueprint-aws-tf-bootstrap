# terraform/Makefile

# ----------------------------------------------------------------
# Makefile Principal
# ----------------------------------------------------------------
include makefiles/config.mk
include makefiles/aws.mk
include makefiles/terraform.mk
include makefiles/bootstrap.mk
include makefiles/iam-oidc-management.mk
include makefiles/sandbox.mk

# Cargar el archivo .env si existe
# Exporta todas las variables del .env al entorno de los comandos
ifneq ("$(wildcard .env)","")
    include .env
    export $(shell sed 's/=.*//' .env)
endif

.PHONY: help confirm
.DEFAULT_GOAL := help

# Definición de colores
YELLOW := \033[1;33m
GREEN  := \033[0;32m
CYAN   := \033[1;36m
RED    := \033[0;31m
RESET  := \033[0m

help:
	@echo "Uso: make [comando] REGION=us-east-1"
	@echo ""
	@echo "Bootstrap:"
	@echo "  bootstrap-init        Inicializa el backend localmente"
	@echo "  bootstrap-plan      	Plan de creación de Bucket y Git Hub IdP"
	@echo "  bootstrap-apply     	Crea el bucket S3 para estados y Git Hub IdP"
	@echo "  bootstrap-destroy   	Destruye el bucket S3 y Git Hub IdP"
	@echo "  bootstrap-state-list	Muestra solo los nombres e IDs de los recursos"
	@echo ""
	@echo "IAM-Roles-GitHub:"
	@echo "  iam-oidc-init         Inicializa usa backend remoto"
	@echo "  iam-oidc-plan         Plan"
	@echo "  iam-oidc-apply        Crea Roles"
	@echo "  iam-oidc-destroy      Destruye los roles"
	@echo "  iam-oidc-state-list   Muestra los nombres e IDs de los recursos"
	@echo ""
	@echo "AWS:"
	@echo "  login-aws             Inicia sesión en AWS SSO"
	@echo "  check-auth            Verifica el estado de la sesión de AWS"
	@echo ""
	@echo "Sandbox:"
	@echo "  sandbox-init          Inicializa entorno efímero"



# Tarea de confirmación
confirm: check-config ## Valida y pide confirmación al usuario
	@if [ "$(SKIP_CONFIRM)" = "true" ]; then \
		printf "$(YELLOW)Saltando confirmación manual...$(RESET)\n"; \
	else \
		printf "$(CYAN)¿Son correctos los valores anteriores?$(RESET)\n"; \
		bash -c 'printf "$(YELLOW)Escriba \"yes\" para continuar (espera máx. 30s): $(RESET)"; \
		if read -t 30 ans; then \
			if [ "$$ans" = "yes" ]; then \
				printf "$(GREEN)¡Validado! Procediendo...$(RESET)\n"; \
			else \
				printf "$(RED)Cancelado: No se recibió confirmación positiva.$(RESET)\n"; \
				exit 1; \
			fi \
		else \
			printf "\n$(RED)ERROR: Tiempo agotado (30s). Operación abortada por seguridad.$(RESET)\n"; \
			exit 1; \
		fi'; \
	fi

# ---
