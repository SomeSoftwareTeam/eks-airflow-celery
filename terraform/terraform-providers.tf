terraform {
  backend "remote" {
    organization = "SomeSoftwareTeam"
    workspaces {
      name = "eks-airflow-celery"
    }
  }
}

data "aws_eks_cluster_auth" "default" {
  name = "default"
}

provider "kubernetes" {
  host                   = var.kubernetes_api_server_endpoint
  cluster_ca_certificate = base64decode(var.kubernetes_api_server_cert_auth)
  token                  = data.aws_eks_cluster_auth.default.token
  load_config_file       = false
}

provider "aws" {
  profile    = "default"
  region     = "us-west-2"
  access_key = var.provider_access_key
  secret_key = var.provider_secret_key
}

provider "github" {
  version      = "> 2.4"
  token        = var.github_token
  individual   = false
  organization = var.github_organization
}