provider "aws" {
  alias  = "ap-northeast-2"
  region = "ap-northeast-2"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

################################################################################
# Customer Gateway Module
################################################################################
module "customer_gateway_ko" {
  providers = {
    aws = aws.ap-northeast-2
  }

  source = "./modules/customer_gateway/"
  
  name = "fortigate-ko-site"
  
  customer_gateways = {
    IP1 = {
      bgp_asn    = 65001
      ip_address = "49.50.63.182"
    },
  }

  tags = {
    Owner       = "04258"
    Environment = "sase-poc"
    Name = "fortigate-ko-site"
  }
}

module "customer_gateway_us" {
  providers = {
    aws = aws.us-east-1
  }

  source = "./modules/customer_gateway/"

  name = "vpn-gateway-us-site"
  
  customer_gateways = {
    IP1 = {
      bgp_asn    = 65002
      ip_address = "61.97.9.202"
    },
  }

  tags = {
    Owner       = "04258"
    Environment = "sase-poc"
    Name = "vpn-gateway-us-site"
  }
}

################################################################################
# Transit Gateway Module
################################################################################
module "tgw_ko" {
  providers = {
    aws = aws.ap-northeast-2
  }

  source = "./modules/transit_gateway/"

  name            = "ko-site-tgw"
  description     = "FortiGate Multi VDOM Test"
  amazon_side_asn = 64531

  transit_gateway_cidr_blocks = ["10.30.1.0/24"]

  # When "true" there is no need for RAM resources if using multiple AWS accounts
  enable_auto_accept_shared_attachments = true

  # When "true", allows service discovery through IGMP
  enable_mutlicast_support = false

# ram_allow_external_principals = true
# ram_principals                = [307990089504]

  tags = {
    Owner       = "04258"
    Environment = "sase-poc"
    Name        = "ko-site-tgw"
  }
  
  tgw_default_route_table_tags = {
    Name        = "ko-site-tgw-rtb"
  }
}

module "tgw_us" {
  providers = {
    aws = aws.us-east-1
  }

  source = "./modules/transit_gateway/"

  name            = "us-site-tgw"
  description     = "FortiGate Multi VDOM Test"
  amazon_side_asn = 64532

  transit_gateway_cidr_blocks = ["10.40.1.0/24"]

  # When "true" there is no need for RAM resources if using multiple AWS accounts
  enable_auto_accept_shared_attachments = true

  # When "true", allows service discovery through IGMP
  enable_mutlicast_support = false

# ram_allow_external_principals = true
# ram_principals                = [307990089504]

  tags = {
    Owner       = "04258"
    Environment = "sase-poc"
    Name        = "us-site-tgw"
  }
    
  tgw_default_route_table_tags = {
    Name        = "us-site-tgw-rtb"
  }
}

################################################################################
# VPN Gateway Module
################################################################################
module "vpn_gateway_ko" {
  providers = {
    aws = aws.ap-northeast-2
  }

# source  = "terraform-aws-modules/vpn-gateway/aws"
  source  = "./modules/vpn_gateway/"

  create_vpn_gateway_attachment = false
  connect_to_transit_gateway    = true
  vpn_connection_static_routes_only            = false

  transit_gateway_id         = module.tgw_ko.ec2_transit_gateway_id
  customer_gateway_id        = module.customer_gateway_ko.ids[0]

  # tunnel inside cidr & preshared keys (optional)
  tunnel1_inside_cidr   = "169.254.30.0/30"
  tunnel2_inside_cidr   = "169.254.31.0/30"
  tunnel1_preshared_key = "sknetvpn"
  tunnel2_preshared_key = "sknetvpn"
  
  tags = {
    Owner       = "04258"
    Environment = "sase-poc"
    Name        = "fortigate-ko-site-connection"
  }
}

module "vpn_gateway_us" {
  providers = {
    aws = aws.us-east-1
  }

# source  = "terraform-aws-modules/vpn-gateway/aws"
  source  = "./modules/vpn_gateway/"

  create_vpn_gateway_attachment = false
  connect_to_transit_gateway    = true
  vpn_connection_static_routes_only            = false

  transit_gateway_id         = module.tgw_us.ec2_transit_gateway_id
  customer_gateway_id        = module.customer_gateway_us.ids[0]

  # tunnel inside cidr & preshared keys (optional)
  tunnel1_inside_cidr   = "169.254.40.0/30"
  tunnel2_inside_cidr   = "169.254.41.0/30"
  tunnel1_preshared_key = "sknetvpn"
  tunnel2_preshared_key = "sknetvpn"
  
  tags = {
    Owner       = "04258"
    Environment = "sase-poc"
    Name        = "fortigate-us-site-connection"
  }
}
