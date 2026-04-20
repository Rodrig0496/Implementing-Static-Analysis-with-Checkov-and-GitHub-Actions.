# Proveedor
provider "aws" {
  region = "us-east-1"
}

# 1. Bucket de S3 Inseguro (Sin cifrado y público)
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "my-sast-demo-bucket-2026"
}

resource "aws_s3_bucket_public_access_block" "bad_practice" {
  bucket = aws_s3_bucket.demo_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 2. Grupo de Seguridad con puerto 22 abierto al mundo (SSH)
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # <-- ERROR: Abierto a todo internet
  }
}