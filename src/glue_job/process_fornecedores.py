import sys
from pyspark.context import SparkContext
from pyspark.sql import functions as F
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions

args = getResolvedOptions(sys.argv, ["JOB_NAME", "dt_extracao", "bucket"])

dt_extracao = args["dt_extracao"]
bucket = args["bucket"]

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

input_path = f"s3://{bucket}/data-ingestion/fornecedores/dt_extracao={dt_extracao}/"

df_raw = spark.read.json(input_path)

df = df_raw.select(F.explode("resultado").alias("fornecedor"))
df_flat = df.select("fornecedor.*")

df_final = df_flat.withColumn("dt_extracao", F.lit(dt_extracao))

output_path = f"s3://{bucket}/data-gold/fornecedores/"

df_final.write.mode("append") \
    .partitionBy("dt_extracao") \
    .parquet(output_path)
