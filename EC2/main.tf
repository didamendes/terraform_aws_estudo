terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
  region = var.project_region
}

/**

  sudo docker container run -p 80:5000 -e MONGODB_HOST=[IP_HOST_MONGODB] -e MONGODB_USERNAME=mongouser -e MONGODB_PASSWORD=mongopwd -d fabricioveronez/rotten-potatoes:v1

  sudo docker container run -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=mongouser -e MONGO_INITDB_ROOT_PASSWORD=mongopwd mongo

 */