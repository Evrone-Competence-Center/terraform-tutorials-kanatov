

module "kube" {
  source     = "github.com/terraform-yc-modules/terraform-yc-kubernetes"
  network_id = "enp67snt19k19j1971ls"

  cluster_version = var.cluster_version

  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = "e9bmbem7id9rfbvqddrs"
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
      version     = var.cluster_version
      description = "Kubernetes nodes for system"
      fixed_scale = {
        size = 2
      }
      preemptible = true

      nat         = true
      node_cores  = var.vms_cores
      node_memory = var.node_mem
      node_labels = {
        role        = "worker-01"
        environment = "system"
      }
    },
    "yc-k8s-ng-02" = {
      version     = var.cluster_version
      description = "Kubernetes nodes for service"
      auto_scale = {
        min     = 1
        max     = 3
        initial = 1
      }
      preemptible = true

      nat         = true
      node_cores  = var.vms_cores
      node_memory = var.node_mem
      node_labels = {
        role        = "worker-02"
        environment = "service"
      }
      node_taints = [
        "service=:NoSchedule"
      ]
    },
    "yc-k8s-ng-03" = {
      version     = var.cluster_version
      description = "Kubernetes nodes for applications"
      fixed_scale = {
        size = 1
      }
      preemptible = true

      nat         = true
      node_cores  = var.vms_cores
      node_memory = var.node_mem
      node_labels = {
        role        = "worker-02"
        environment = "app"
      }
      node_taints = [
        "app=:NoSchedule"
      ]
    }
  }
}

# ==========================================
# Construct KinD cluster
# ==========================================

# resource "kind_cluster" "this" {
#   name = "flux-e2e"
# }

resource "flux_bootstrap_git" "this" {
  embedded_manifests = true
  path               = "gitops"
}