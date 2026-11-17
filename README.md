# 🗄️ Oficina Mecânica - Infraestrutura de Banco de Dados

> **📦 Versão anterior do projeto.** Este repositório é da fase monolítica do sistema de oficina mecânica (Pós-Graduação em Arquitetura de Software, FIAP). A versão final, com microsserviços, saga e integração com o Mercado Pago, está na organização **[oficina-mecanica-app](https://github.com/oficina-mecanica-app)**.

## 📋 Sobre o Projeto
Este repositório armazena o código **Terraform (IaC - Infrastructure as Code)** responsável exclusivamente pelo provisionamento da camada de persistência de dados do sistema "Oficina Mecânica".

O projeto gerencia o ciclo de vida do banco de dados relacional **Amazon RDS (PostgreSQL)** e suas regras de firewall (Security Groups). Optamos por manter este código separado da infraestrutura do Cluster Kubernetes para garantir que o ciclo de vida dos dados seja independente, evitando que destruições acidentais do cluster afetem a persistência das informações.

## 🚀 Tecnologias & Recursos
* **Terraform:** Ferramenta de IaC para provisionamento.
* **AWS RDS (Relational Database Service):** Instância gerenciada do PostgreSQL.
* **AWS Security Groups:** Regras de firewall para controle de acesso granular.
* **AWS VPC Subnets:** Configuração de subnets privadas para isolamento do banco.

## 🏗️ Arquitetura de Dados e Segurança
A arquitetura foi desenhada priorizando a segurança (Security by Design). O banco de dados não possui endereço IP público e só aceita conexões originadas de fontes confiáveis dentro da VPC.

**Fluxo de Acesso:**
1.  **Cluster EKS:** A aplicação Backend acessa o banco via porta 5432.
2.  **AWS Lambda:** A função de autenticação acessa o banco para validar usuários.
3.  **Internet:** O acesso direto é **bloqueado**.

## ⚙️ Como Executar (Passo a Passo)

### Pré-requisitos
* **Terraform** (v1.0+) instalado.
* **AWS CLI** configurado com credenciais que tenham permissão para criar RDS e VPC Security Groups.

### 1. Inicializar o Terraform
Baixa os plugins necessários (Provider AWS) e configura o backend de estado.

```bash
terraform init
```

### 2. Planejar a Infraestrutura (Plan)
Gera um plano de execução mostrando quais recursos serão criados na AWS. É uma etapa de segurança para revisar as mudanças.

```bash
terraform plan -out=tfplan
```

### 3. Aplicar a Infraestrutura (Apply)
Executa a criação efetiva dos recursos na nuvem.

```bash
terraform apply "tfplan"
```
Nota: A criação de uma instância RDS pode levar entre 5 a 15 minutos para ser concluída pela AWS.

### 4. Obter o Endpoint (Output)
Ao final da execução, o Terraform exibirá o endpoint (URL) do banco de dados. Você precisará dessa URL para configurar o Backend e a Lambda.

```bash
# Exemplo de saída:
db_endpoint = "oficina-db.cwx8ygkc4hs8.us-east-1.rds.amazonaws.com:5432"
```

### 🔒 Detalhes de Segurança
- Isolamento de Rede: A instância RDS é provisionada em Subnets Privadas, sem rota direta para a internet (Internet Gateway).
- Criptografia: O armazenamento em repouso (Storage Encrypted) está ativado por padrão.
- Grupos de Segurança:
  - Ingress (Entrada): Permitido apenas TCP/5432 vindo dos Security Groups do EKS e da Lambda.
  - Egress (Saída): Bloqueado (banco não inicia conexões para fora).

### ☁️ CI/CD
Este repositório possui integração contínua configurada via GitHub Actions, que valida a sintaxe do Terraform (terraform validate) a cada Pull Request, garantindo a qualidade do código antes do merge.
