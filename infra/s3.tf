resource "aws_s3_bucket" "ingestion" {
  bucket = "${var.project_name}-${var.environment}-data-ingestion"

  force_destroy = true

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Layer       = "raw"
  }
}
