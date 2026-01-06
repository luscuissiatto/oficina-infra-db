# 1. Security Group para permitir acesso ao banco
resource "aws_security_group" "rds_sg" {
  name        = "oficina-rds-sg"
  description = "Permite acesso ao PostgreSQL"

  ingress {
    description = "PostgreSQL Ingress"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # CUIDADO: Em prod real, restringir IPs. Aqui liberado para facilitar testes.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. A Instância RDS PostgreSQL
resource "aws_db_instance" "oficina_db" {
  identifier        = "oficina-db-instance"
  engine            = "postgres"
  engine_version    = "15" # Compatível com Spring Boot 3
  instance_class    = "db.t3.micro" # Elegível para Free Tier
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Configurações de Rede e Segurança
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true # Importante para destruir o ambiente rápido sem travar

  # Backup (Opcional para reduzir custos em teste, desabilitar se quiser)
  backup_retention_period = 0 
}