terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  
  # Boas práticas: Tags padrão para identificar custos
  default_tags {
    tags = {
      Project     = "Oficina Mecanica"
      Environment = "Production"
      ManagedBy   = "Terraform"
    }
  }
}