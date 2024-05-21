

module "kube" {
  source     = "github.com/terraform-yc-modules/terraform-yc-kubernetes"
  network_id = var.k8s_network_id

  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = var.k8s_subnet_id
    }
  ]

  master_maintenance_windows = [
    {
      day        = "monday"
      start_time = "23:00"
      duration   = "3h"
    }
  ]

  node_groups = {
    "yc-k8s-ng-01" = {
      description = "Kubernetes system node"

      platform_id = var.vms_platform_id

      auto_scale = {
        min     = 1
        max     = 3
        initial = 1
      }

      node_labels = {
        role        = "worker-01"
        environment = "system"
      }

      preemptible = true
    }
    # "yc-k8s-ng-02"  = {
    #   description   = "Kubernetes nodes group 02"
    #   auto_scale    = {
    #     min         = 1
    #     max         = 3
    #     initial     = 1
    #   }

    #   node_labels   = {
    #     role        = "worker-02"
    #     environment = "dev"
    #   }
    #   max_expansion   = 1
    #   max_unavailable = 1
    # }
  }
}