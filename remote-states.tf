data "terraform_remote_state" "global_vars" {
  backend = "s3"

  config {
    bucket = "s3-terraform-states-eu-west-1-612688033368"
    key    = "cloudpublic/cloudpublic/global/vars/terraform.state"
    region = "eu-west-1"
  }
}
