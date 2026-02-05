# terraform/makefiles/terraform.mk

# ----------------------------
# Terraform - Tareas (Targets)
# ----------------------------

init_tf:
    $(DOCKER_TF) -chdir=$(BOOTSTRAP_PATH) init

# ---
