# This configuration uses OpenTofu's null_resource to manage the execution of your Kind cluster script:

resource "null_resource" "kind_cluster" {
  provisioner "local-exec" {
    command = "./kind-cluster.sh create"
  }

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./kind-cluster.sh delete"
  }
}

output "kubeconfig_path" {
  value = "${path.module}kube/"
}
