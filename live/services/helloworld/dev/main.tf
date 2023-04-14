module "helloworld" {  
  source = "../../../../modules/terraform-aws-helloworld"

  image_tag   = "1.0.0"
  environment = "dev"
  hosts       = ["helloworld.dev.examplr.co"]
  deploy      = true
}
