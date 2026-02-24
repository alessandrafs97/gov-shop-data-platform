resource "aws_s3_bucket" "scripts" {
  bucket        = "${var.project_name}-${var.environment}-glue-scripts"
  force_destroy = true
}

resource "aws_s3_object" "script" {
  bucket = aws_s3_bucket.scripts.bucket
  key    = "process_fornecedores.py"
  source = "${path.root}/../src/glue_job/process_fornecedores.py"

  etag = filemd5("${path.root}/../src/glue_job/process_fornecedores.py")
}

resource "aws_iam_role" "glue_role" {
  name = "${var.project_name}-${var.environment}-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "glue.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "glue_s3" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_glue_job" "job" {
  name     = "${var.project_name}-${var.environment}-glue-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.scripts.bucket}/process_fornecedores.py"
    python_version  = "3"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"
}