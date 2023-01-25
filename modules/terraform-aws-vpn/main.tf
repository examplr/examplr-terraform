


resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = 65000
  ip_address = var.vpn_host
  type       = "ipsec.1"
}

resource "aws_vpn_connection_route" "office" {
  destination_cidr_block = var.destination_cidr_block
  vpn_connection_id      = aws_vpn_connection.main.id
}

resource "aws_route" "private_vpn_route" {
  count = var.route_table_count
  route_table_id         = var.route_table_ids[count.index]
  destination_cidr_block = var.destination_cidr_block
  gateway_id         = aws_vpn_gateway.vpn_gateway.id
}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = var.vpc_id
}

resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.customer_gateway.id
  type                = "ipsec.1"
  static_routes_only  = true

  tunnel1_log_options {
    cloudwatch_log_options {
      log_enabled       = "true"
      log_group_arn     = aws_cloudwatch_log_group.tunnel1_logs.arn
      log_output_format = "json"
    }
  }

  tunnel2_log_options {
    cloudwatch_log_options {
      log_enabled       = "true"
      log_group_arn     = aws_cloudwatch_log_group.tunnel2_logs.arn
      log_output_format = "json"
    }
  }
}

resource "aws_cloudwatch_log_group" "tunnel1_logs" {
  name              = "complete-vpn-tunnel1-logs"
  retention_in_days = 7
}
resource "aws_cloudwatch_log_group" "tunnel2_logs" {
  name              = "complete-vpn-tunnel2-logs"
  retention_in_days = 7
}

