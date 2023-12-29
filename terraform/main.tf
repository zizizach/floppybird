locals {
  project      = "zachgpt"
  region       = "asia-southeast1"
  zone         = "asia-southeast1-a"
  service_name = "flappy-bird"
  domain_name  = "zachho.net"
  docker_image = "docker.io/zizizach/flappybird:main"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("zachgpt-f8a69433fb95.json")

  project = local.project
  region  = local.region
  zone    = local.zone
}

resource "google_cloud_run_v2_service" "flappy-bird" {
  name     = local.service_name
  location = local.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  template {
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
    max_instance_request_concurrency = 1
    containers {
        name = "flappybird-1"
      image = local.docker_image
      resources {
        limits = {
          cpu               = "80m"
          memory            = "128Mi"
        }
        cpu_idle = true
        # startup_cpu_boost = true
      }
      ports {
          name           = "http1"
          container_port = 80
        }
    }
  }
}

# data "google_project" "project" {}

# resource "google_cloud_run_domain_mapping" "flappy-bird" {
#   name     = "${local.service_name}.${local.domain_name}"
#   location = google_cloud_run_v2_service.flappy-bird.location
#   metadata {
#     namespace = data.google_project.project.project_id
#   }
#   spec {
#     route_name = google_cloud_run_v2_service.flappy-bird.name
#   }
#   depends_on = [google_cloud_run_v2_service.flappy-bird]
# }
