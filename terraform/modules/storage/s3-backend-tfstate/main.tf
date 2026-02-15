# terraform/modules/storage/s3-backend-tfstate/main.t

# -------------------------------------------------------------------------
# MÓDULO: s3-backend-tfstate
# -------------------------------------------------------------------------
# Crea: 
#   - S3 bucket con las recomendaciones de seguridad para terraform.tfstate
# -------------------------------------------------------------------------

#----------------------------------
# Crea Bucket S3
#----------------------------------
resource "aws_s3_bucket" "bucket_tf_state" {
  bucket = "${var.bucket_name}"

  # Protección contra eliminación accidental desde Terraform
  lifecycle {
    # prevent_destroy = true  # Entornos Dev o Prod
    prevent_destroy = false   # Entornos de test o Sandbox que son emíferos
  }
  
  # forzar la destrucción del bucket para eliminar los objetos y versiones antiguos
  # esto es útil para entornos de test o Sandbox que son efímeros
  force_destroy = true

  tags = {
    Name        = "Terraform State Bucket"
  #  Environment = "${var.purpose}"
  }
}

#-------------------------------------------
# Configuración de Cifrado (SSE-S3 / AES256)
#-------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.bucket_tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#-------------------------------------------
# Configuración de Versionado en S3 bucket
#-------------------------------------------
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.bucket_tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

#--------------------------------------------------
# Bloqueo de Acceso Público (Seguridad Perimetral)
#--------------------------------------------------
resource "aws_s3_bucket_public_access_block" "tf_state_public_block" {
  bucket = aws_s3_bucket.bucket_tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#-----------------------
# Bloquea el uso de ACLs
#-----------------------
resource "aws_s3_bucket_ownership_controls" "tf_state_ownership" {
  bucket = aws_s3_bucket.bucket_tf_state.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

#--------------------------------------------------------------------------------
# Política de Bucket (Seguridad de Transporte-Tránsito)
# Forzar el uso de HTTPS (TLS)
# Garantiza que los datos viajen siempre dentro de un túnel encriptado (TLS/SSL)
#--------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "terraform_state_policy" {
  bucket = aws_s3_bucket.bucket_tf_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [ // <--- 1. Inicio de lista
      {           // <--- 2. Inicio de objeto
        Sid       = "EnforceHTTPS"
        Effect    = "Deny" // Necesario para que la condición tenga sentido
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.bucket_tf_state.arn,
          "${aws_s3_bucket.bucket_tf_state.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      } // Cierra el objeto
    ]   // Cierra la lista
  })
}

#-------------------------------------------------------
# Regla de Ciclo de Vida para limpiar bloqueos antiguos
#-------------------------------------------------------
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state_lifecycle" {
  bucket = aws_s3_bucket.bucket_tf_state.id

  rule {
    id     = "CleanUpLockFiles"
    status = "Enabled"

    filter {
      prefix = "" # Aplica a todo
    }

    # Limpiar versiones antiguas de archivos (útil para los delete markers de los locks)
    noncurrent_version_expiration {
      noncurrent_days = 7
    }

    # Abortar cargas multiparte incompletas para ahorrar costos
    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
}

# ---






