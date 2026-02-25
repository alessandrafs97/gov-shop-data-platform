# Gov Shop Data Platform

Pipeline de dados serverless na AWS construída com Terraform, utilizando arquitetura modular e foco em escalabilidade, observabilidade e boas práticas de engenharia.

---

## Arquitetura

EventBridge  
→ Step Functions  
→ Lambda (Ingestão)  
→ S3 (Bronze / raw)  
→ Glue (Transformação)  
→ S3 (Gold / parquet)  
→ Athena (Consulta)

---

## Serviços AWS Utilizados

- AWS Lambda  
- AWS Step Functions  
- AWS Glue  
- Amazon S3  
- Amazon Athena  
- Amazon EventBridge  
- Amazon CloudWatch  
- Terraform  

---

## Estrutura do Projeto

```
gov-shop-data-platform/
│
├── infra/ # Terraform root
├── modules/ # Infra modularizada
│ ├── s3/
│ ├── lambda/
│ ├── glue/
│ ├── step_function/
│ └── eventbridge/
│
├── src/
│ ├── lambda/
│ └── glue_job/
│
├── layers/
└── README.md
```


Infra totalmente modularizada para permitir expansão futura e multi-environment.

---

## Provisionamento

```bash
cd infra
terraform init
terraform plan
terraform apply
```

---

## Camadas do Data Lake

### Bronze (raw)

JSON original ingerido pela Lambda.  
Particionado por `dt_extracao`.

Exemplo:

s3://bucket/data-ingestion/fornecedores/dt_extracao=YYYY-MM-DD/

### Gold

Dados transformados pelo Glue.
Formato parquet otimizado para Athena.

Exemplo:

s3://bucket/gold/fornecedores/

---

## Orquestração

- EventBridge executa a pipeline diariamente
- Step Functions coordena execução da Lambda e do Glue
- Execução síncrona do Glue
- Logs centralizados no CloudWatch

---

## Observabilidade

- Logs de execução da Lambda
- Logs completos da Step Function
- Alarmes configurados via CloudWatch

---

## Roadmap

- Implementação de CI/CD com GitHub Actions
- Estruturação de múltiplos ambientes (dev, hml, prod)
- Versionamento da camada gold
- Testes automatizados para Lambda
- Métricas customizadas e monitoramento avançado


