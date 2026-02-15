# 🛠️ Bootstrap (Configuración Inicial) AWS | Terraform + OIDC

[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?logo=amazon-web-services&logoColor=white)](#)
[![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?logo=terraform&logoColor=white)](#)
[![HCL](https://img.shields.io/badge/Language-HCL-blueviolet)](#)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)

> 🚀 Este repositorio contiene la base de infraestructura necesaria para gestionar estados de Terraform en la nube y establecer una confianza segura entre **`GitHub Actions`** y **`AWS`** mediante **`OIDC (OpenID Connect)`**, eliminando la necesidad de usar llaves de acceso (**`AWS_ACCESS_KEY_ID`**) de larga duración.

## 🎯 Objetivo
El propósito de este repositorio es realizar el **Bootstrap de la infraestructura core** en AWS para habilitar operaciones automatizadas y seguras:
- **Gestión de Estado Remoto:** Configurar un S3 Backend que centralice los archivos de estado (.tfstate), garantizando la consistencia en entornos colaborativos.
- **Identidad y Acceso (OIDC):** Establecer una relación de confianza segura entre **GitHub y AWS** para eliminar el uso de credenciales estáticas.
- **Estandarización:** Proveer un flujo de comandos unificado mediante **Makefile** para reducir errores manuales en la fase de inicialización.

---

## Flujo de la Infraestructura
El proyecto está dividido en dos fases lógicas para garantizar que el "huevo y la gallina" (el backend de Terraform) se gestione correctamente:
1.  **Fase 1: Bootstrap** 🏗️  
    Crea el bucket S3 para los estados remotos y el Identity Provider (IdP) de GitHub en AWS.
2.  **Fase 2: IAM & OIDC** 🔐  
    Configura los roles de IAM que permiten a nuestros repositorios de GitHub realizar despliegues automáticos mediante `AssumeRole`.

---

## 🛠 Requisitos Previos

* **Terraform** >= 1.14.0
* **AWS CLI** configurado con SSO.
* **Make** instalado en tu sistema.
* Permisos de `AdministratorAccess` para la ejecución inicial.

---

## 🚀 Guía de Inicio Rápido

### 1. Autenticación
Primero, asegúrate de tener una sesión activa en AWS:
```bash
make login-aws REGION=us-east-1
make check-auth
```

### 2. Despliegue del Bootstrap
En esta fase, el estado se guarda localmente inicialmente para poder crear el bucket donde vivirán los futuros estados.
```bash
make bootstrap-init
make bootstrap-plan
make bootstrap-apply
```

### 3. Configuración de Roles OIDC
Una vez creado el bucket, inicializamos este módulo apuntando al nuevo backend remoto:
```bash
make iam-oidc-init
make iam-oidc-plan
make iam-oidc-apply
```

---

## 🛡 Seguridad y Mejores Prácticas
- **Zero Credentials:** No se almacenan secretos de AWS en GitHub. Se utiliza el estándar OIDC para intercambiar tokens de corta duración.
- **Least Privilege:** Los roles de IAM están restringidos para ser asumidos únicamente por la organización y el repositorio de GitHub definidos en tus variables.
- **S3 Hardening:** El bucket de estados cuenta con:
    - Bloqueo de acceso público (Public Access Block).
    - Cifrado de servidor (SSE-S3).
    - Versionado de objetos (para recuperación ante desastres).

## 📖 Uso en GitHub Actions
Una vez completado el proceso, se puede usar el ARN del rol generado en pipelines de la siguiente manera:
```yaml
jobs:
  terraform-deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write # Requerido para OIDC
      contents: read
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::1234567890:role/TuRolOIDC
          aws-region: us-east-1

      - name: Terraform Plan
        run: terraform plan
```

---

## 📂 Estructura del Proyecto

```plaintext
/ (root del repo)
├── terraform/                   # El núcleo de IaC
│   ├── bootstrap/               # Recursos base (S3 + OIDC IdP)
│   ├── sandboxes/               # Creación de recursos efímeros (test,labs,demos)
│   │   ├── iac-security-scans/  # Nombre del test
│   │   │   └── iam-managemnet/  # Recursos que requiere el test 
│   ├── modules/                 # 📦 MÓDULOS REUTILIZABLES
│   │   ├── storage/ 
│   │   │    └── s3-backend/     # Bucket S3 para Backend de tfstate
│   │   └── iam-factory/         # Roles de IAM específicos por repo (OIDC + Roles via YAML)
│   ├── makefiles/               # Scripts de bootstrap
│   ├── Makefile                 # Orquestador de comandos
│   └── .env                     # Definición de variables para flujo de Make
└── README.md                    # Documentación técnica
```

---

## 🧪 Entorno Sandbox (Playground)
El entorno sandbox está diseñado para fomentar la experimentación segura. Este entorno permite probar nuevos módulos, recursos o configuraciones de red sin poner en riesgo la infraestructura de producción o los estados globales.

### ¿Por qué usar el Sandbox?
- **Aislamiento Total:** Utiliza un espacio de nombres y un estado de Terraform independiente.
- **Pruebas de Concepto (PoC):** Ideal para validar cambios en la arquitectura antes de integrarlos al flujo de CI/CD principal.
- **Cero Riesgo:** Permite ejecutar destroy sin temor a afectar recursos críticos del Bootstrap o de IAM de otros entornos.

### Flujo de Trabajo en el Sandbox
El Sandbox no es solo una carpeta, es un entorno efímero completo que se crea desde cero usando la variable:
1. Inicializar: Prepara el entorno efímero.
```bash
make bootstrap-init ENV=sandbox
```
2. **Experimentar:** Añadir recursos en la carpeta **/sandbox** y ejecutar planes de Terraform.
3. **Limpiar:** Una vez validada la prueba, puedes eliminar los recursos para evitar costos innecesarios en la nube.

> [!TIP]
> **Tip de Automatización:** <br>
> - El Sandbox es el lugar ideal para probar políticas de **Least Privilege** antes de aplicarlas a los roles de OIDC definitivos.<br>
> - También este flujo permite probar cambios en la propia infraestructura de bootstrap (como nuevas políticas de cifrado en S3) antes de aplicarlas a los entornos core.

---

## 🗺️ Roadmap de Evolución
### Calidad y Seguridad
- [ ] Análisis Estático: Integrar **TFLint** y **Checkov**en el pipeline para detectar malas prácticas de seguridad antes del despliegue.
- [ ] Validación de Políticas: Implementar políticas de OPA (Open Policy Agent) para restringir tipos de instancias o regiones permitidas.
### Escalabilidad y Testing
- [ ] Multi-Region Support: Adaptar el Makefile para soportar despliegues en múltiples regiones de AWS de forma simultánea.
- [ ] Terratest: Añadir pruebas unitarias para validar que el bucket de S3 y los roles de IAM se crean con las restricciones correctas.
- [ ] Drift Detection: Configurar una GitHub Action cronometrada para detectar cambios manuales en la consola de AWS que no estén en el código.
### Ecosistema Avanzado
- [ ] Cost Optimization: Integrar **Infracost** en los Pull Requests para visualizar el impacto económico de cada cambio de infraestructura.
- [ ] Observabilidad: Añadir logs de auditoría automáticos para cada ejecución de Terraform usando CloudWatch y SNS.

---