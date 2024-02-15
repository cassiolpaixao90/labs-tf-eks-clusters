module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  # Name to be used on all the resources as identifier
  name = var.environment_name

  # (Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id
  # default 10.0.0.0/16
  cidr = var.vpc_cidr

  # (Optional) A list of tags to add to all resources
  # default {}
  secondary_cidr_blocks = var.secondary_cidrs

  # (Optional) A list of secondary CIDR blocks to associate with the VPC to extend the IP Address pool
  azs = var.azs

  # (Optional) A list of public subnets inside the VPC
  private_subnets = var.private_subnets

  # (Optional) A list of private subnets inside the VPC
  public_subnets = var.public_subnets

  # We want to use the 100.64.0.0/16 address space for the EKS nodes and since
  # this module doesnt have an EKS subnet, we will use the elasticache instead.
  elasticache_subnets = var.k8s_worker_subnets

  # Should be true if you want to provision NAT Gateways for each of your private networks
  enable_nat_gateway = var.enable_nat_gateway

  # Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable
  # default false
  reuse_nat_ips = var.reuse_nat_ips

  # List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)
  external_nat_ip_ids = var.external_nat_ip_ids

  # Should be true if you want to create a new VPN Gateway resource and attach it to the VPC
  #default false
  enable_vpn_gateway = var.enable_vpn_gateway

  # Should be true to enable DNS hostnames in the VPC
  # default true
  enable_dns_hostnames = var.enable_dns_hostnames

  # Should be true to enable DNS support in the VPC
  #default true
  enable_dns_support = var.enable_dns_support

  # Additional tags for the public subnets
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  # Additional tags for the private subnets
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }

  # Additional tags for the elasticache subnets
  elasticache_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
    "ops_purpose"                               = "Overloaded for k8s worker usage"
  }

  # A map of tags to add to all resources
  tags = var.tags

  #Default Security Group Management (Default: secure)

  # Should be true to adopt and manage default security group
  # default true
  manage_default_security_group = var.manage_default_security_group

  # Name to be used on the default security group
  # default null
  default_security_group_name = var.default_security_group_name

  # List of maps of egress rules to set on the default security group
  # default [{"from_port": 0, "to_port": 0, "protocol": "-1", "cidr_blocks": ["0.0.0.0/0"]}
  default_security_group_egress = var.default_security_group_egress

  # List of maps of ingress rules to set on the default security group
  # default [{"from_port": 0, "to_port": 0, "protocol": "-1", "cidr_blocks": ["0.0.0.0/0"]}
  default_security_group_ingress = var.default_security_group_ingress

  # Tags to be added to security group created
  # default {}
  default_security_group_tags = var.default_security_group_tags

  # Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is `false`
  # default false
  map_public_ip_on_launch = var.map_public_ip_on_launch

  # Should be true to adopt and manage Default Network ACL
  # default true
  manage_default_network_acl = var.manage_default_network_acl

  # Should be true to manage default route table
  # default true
  manage_default_route_table = var.manage_default_route_table
}