import os
import json
import datetime
import urllib.parse
import urllib.request
import boto3

s3 = boto3.client("s3")

API_URL = "https://dadosabertos.compras.gov.br/modulo-fornecedor/1_consultarFornecedor"

BUCKET_NAME = os.environ["BUCKET_NAME"]

HTTP_TIMEOUT = 60


def lambda_handler(event, context):

    # Apenas página 1 com tamanho grande
    params = {
        "pagina": 1,
        "tamanhoPagina": 20,  # tente o maior possível
        "ativo": "true"
    }

    url = API_URL + "?" + urllib.parse.urlencode(params)

    req = urllib.request.Request(
        url,
        headers={
            "accept": "*/*",
            "user-agent": "aws-lambda/fornecedor-pipeline"
        }
    )

    with urllib.request.urlopen(req, timeout=HTTP_TIMEOUT) as resp:
        body_bytes = resp.read()

    data = json.loads(body_bytes.decode("utf-8"))

    dt = datetime.datetime.utcnow().strftime("%Y-%m-%d")

    key = f"data-ingestion/fornecedores/dt_extracao={dt}/fornecedores_full.json"

    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=key,
        Body=json.dumps(data, ensure_ascii=False).encode("utf-8"),
        ContentType="application/json"
    )

    return {
        "status": "ok",
        "dt_extracao": dt,
        "totalRegistros": data.get("totalRegistros"),
        "totalPaginas": data.get("totalPaginas")
    }
