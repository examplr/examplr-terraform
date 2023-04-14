module "helloworld" {  
  source = "../../../../modules/terraform-aws-helloworld"

  image_tag   = "1.0.0"
  environment = "prod"
  hosts       = ["api.examplr.co"]
  deploy      = true
}
