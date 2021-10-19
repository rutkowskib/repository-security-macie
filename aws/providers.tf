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
    github = {
      source = "integrations/github"
      version = "4.17.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "github" {
  token = var.github_token
}