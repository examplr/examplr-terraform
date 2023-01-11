
# terraform-aws-ecr-cross-account

Creates an ECR repository that multiple accounts can read and write to.  Used to have a common repository that
supports multiple deployment environments such as dev/stage/prod.

Copied from "doingcloudright/ecr-lifecycle-policy-rule/aws" which was outdated and incompatible.

### Example

```terraform

module "ecr-cross-account" {
  source                      = "./modules/terraform-aws-ecr-cross-account"

  repository_name             = "helloworld"
  allowed_read_principals     = ["arn:aws:iam::${var.dev_account_id}:root", "arn:aws:iam::${var.prod_account_id}:root"]
  allowed_write_principals    = ["arn:aws:iam::${var.dev_account_id}:root"]
}

```
### To Do
 - 'root' is probably not the right principal scope for the example above.

### Inputs

| Name                     | Description                    | Type         |
|:-------------------------|:-------------------------------|:-------------|
| repository_name          | The name of the repo to create | string       |
| allowed_read_principals  | who can read from this repo    | list(string) |
| allowed_write_principals | who can write to this repo     | list(string) |


### Outputs

| Name             | Description                                        | Type   |
|:-----------------|:---------------------------------------------------|:-------|
| repository_name  | Same as the passed in repository_name              | string |
| repository_arn   | The ARN of the created registry                    | string |
| repository_url   | The url for the created repository                 | string |
| registry_id      | The id of the registry the repo was created in     | string |

