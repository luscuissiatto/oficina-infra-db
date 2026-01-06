variable "region" {
  description = "Região da AWS"
  default     = "us-east-1"
}

variable "db_name" {
  description = "Nome do Banco de Dados"
  default     = "oficina"
}

variable "db_username" {
  description = "Usuário Mestre do Banco"
  default     = "postgres"
}

variable "db_password" {
  description = "Senha Mestre do Banco (Passe via linha de comando ou variáveis de ambiente em CI/CD)"
  type        = string
  sensitive   = true 
}