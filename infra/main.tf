module "s3" {
  source       = "../modules/s3"
  project_name = var.project_name
  environment  = var.environment
}

module "lambda" {
  source       = "../modules/lambda"
  project_name = var.project_name
  environment  = var.environment
  bucket_name  = module.s3.bucket_name
}

module "glue" {
  source       = "../modules/glue"
  project_name = var.project_name
  environment  = var.environment
  bucket_name  = module.s3.bucket_name
}

module "step_function" {
  source        = "../modules/step_function"
  project_name  = var.project_name
  environment   = var.environment
  lambda_arn    = module.lambda.lambda_arn
  glue_job_name = module.glue.glue_job_name
  bucket_name   = module.s3.bucket_name
}

module "eventbridge" {
  source            = "../modules/eventbridge"
  project_name      = var.project_name
  environment       = var.environment
  state_machine_arn = module.step_function.state_machine_arn
}