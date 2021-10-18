terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.63.0"
    }
    archive = {
      source = "hashicorp/archive"
      version = "2.2.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}