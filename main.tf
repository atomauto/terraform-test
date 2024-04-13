terraform {
  backend "pg" {}
  required_providers {
    sbercloud = {
      source  = "tf.repo.sbc.space/sbercloud-terraform/sbercloud" # Initialize Cloud.ru provider
      }
  }
}

provider "sbercloud" {
  auth_url = "https://iam.ru-moscow-1.hc.sbercloud.ru/v3" 
  region   = "ru-moscow-1"

  access_key = var.access_key
  secret_key = var.secret_key
}
