

output "public_subnets" {
  value = [aws_subnet.public_d.id, aws_subnet.public_e.id,]
}

output "private_subnets" {
  value = [aws_subnet.private_d.id, aws_subnet.private_e.id,]
}

output "vpc_id"{
  value = aws_vpc.app_vpc.id
}