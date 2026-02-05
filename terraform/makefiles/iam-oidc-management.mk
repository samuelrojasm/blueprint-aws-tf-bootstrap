# terraform/makefiles/iam-oidc-management.mk

#---------------------------------------------------
# Crea los roles y políticas de GitHub IdP OIDC
#---------------------------------------------------


# Comandos de IAM Roles de IdP de Git Hub
.PHONY: iam-oidc-init iam-oidc-plan iam-oidc-apply iam-oidc-output iam-oidc-destroy iam-oidc-state-list


iam-oidc-init: sanitize check-config setup-cache check-auth ## Inicializa Terraform y descarga proveedores en caché
	@echo "🚀 Inicializando Bootstrap en $(BOOTSTRAP_PATH)..."
	@$(DOCKER_TF) -chdir=$(IAM_ROL_GITHUB) init \
		-reconfigure \
		-input=false \
		-backend-config="bucket=$(NAME_STATE_BUCKET)" \
		-backend-config="key=iam-roles-github/terraform.tfstate" \
		-backend-config="region=$(REGION)"

iam-oidc-plan: sanitize check-auth ## Muestra el plan de ejecución de Terraform
	@$(DOCKER_TF) -chdir=$(IAM_ROL_GITHUB) plan
 
iam-oidc-apply: sanitize confirm check-auth
	@echo "🏗️ Creando Roles IAM para IdP de Git Hub ..."
	@$(DOCKER_TF) -chdir=$(IAM_ROL_GITHUB) apply -auto-approve

iam-oidc-output:
	@$(DOCKER_TF) -chdir=$(IAM_ROL_GITHUB) output

iam-oidc-destroy: sanitize confirm check-auth ## Destruye los recursos generados
	@$(DOCKER_TF) -chdir=$(IAM_ROL_GITHUB) destroy -auto-approve

iam-oidc-state-list: sanitize check-auth ## Muestra los nombres e IDs de los recursos
	@$(DOCKER_TF) -chdir=$(IAM_ROL_GITHUB) state list

# ---