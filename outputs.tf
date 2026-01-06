output "rds_endpoint" {
  description = "Endpoint para conexão com o banco de dados"
  value       = aws_db_instance.oficina_db.endpoint
}

output "rds_address" {
  description = "Apenas o endereço (host)"
  value       = aws_db_instance.oficina_db.address
}