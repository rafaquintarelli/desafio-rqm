resource "null_resource" "connect_cluster" {
  provisioner "local-exec" {
    command = "aws eks --region us-east-1 update-kubeconfig --name k8s-rafael"
  }
}

resource "null_resource" "apply_sales_db" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/sales-db/"
  }

   depends_on = [null_resource.connect_cluster]
}

resource "null_resource" "apply_auth_db" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/auth-db/"
  }

   depends_on = [null_resource.apply_sales_db]
}

resource "null_resource" "apply_product_db" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/product-db/"
  }
   depends_on = [null_resource.apply_auth_db]
}

resource "null_resource" "apply_sales_rabbit" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/sales_rabbit/"
  }
   depends_on = [null_resource.apply_auth_db]
}

resource "null_resource" "apply_product_api" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/product-api/"
  }
   depends_on = [null_resource.apply_sales_rabbit]
}

resource "null_resource" "apply_sales_api" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/sales-api/"
  }
   depends_on = [null_resource.apply_product_api]
}

resource "null_resource" "apply_auth_api" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/auth-api/"
  }
   depends_on = [null_resource.apply_sales_api]
}
