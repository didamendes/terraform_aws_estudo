terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }

  backend "s3" {
    bucket = "diogo-terraform-state"
    key    = "terraform-aula.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "aula_vpc" {

  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "aula-vpc"
  }

}