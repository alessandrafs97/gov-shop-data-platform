# Gov Shop Data Platform

## Arquitetura

EventBridge → Step Function → Lambda → S3 (raw) → Glue → S3 (gold) → Athena

## Serviços AWS utilizados

- AWS Lambda
- AWS Step Functions
- AWS Glue
- Amazon S3
- Amazon Athena
- Amazon EventBridge
- Terraform

## Estrutura

infra/ → Infraestrutura Terraform  
src/ → Código Lambda e Glue  

## Como provisionar

cd infra
terraform init
terraform plan
terraform apply

## Camadas do Data Lake

- raw → JSON original da API
- gold → parquet particionado por dt_extracao

## Orquestração

- EventBridge executa diariamente
- Step Function coordena Lambda e Glue
