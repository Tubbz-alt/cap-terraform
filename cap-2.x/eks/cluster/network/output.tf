output "vpc_id" {
  value = aws_vpc.main.id
}

output "app_subnet_ids" {
  value = aws_subnet.main.*.id
}

output "generated-cluster-name" {
  value = local.cluster_name
}
