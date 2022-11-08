data "aws_availability_zones" "available" {}

locals {
  # This determines the size of the private subnets
  private_subnets = {
    "/16"     = "3"
    "/17"     = "3"
    "/18"     = "3"
    "/19"     = "3"
    "/20"     = "4"
  }
  #private subnet override
  private_network_override = {
    standard = local.private_subnets[var.subnet_cidr]
    override = var.private_networkbits
  }
  public_network_override = {
    standard = local.subnets[var.subnet_cidr]
    override = var.public_networkbits
  }
  intra_network_override = {
    standard = local.subnets[var.subnet_cidr]
    override = var.intra_networkbits
  }
  database_network_override = {
    standard = local.subnets[var.subnet_cidr]
    override = var.database_networkbits
  }
  elasticache_network_override = {
    standard = local.subnets[var.subnet_cidr]
    override = var.elasticache_networkbits
  }
  redshift_network_override = {
    standard = local.subnets[var.subnet_cidr]
    override = var.redshift_networkbits
  }
  #netnum override
  public_netnum_override = {
    standard = local.public_subnets[var.subnet_cidr]
    override = var.public_netnum
  }
  intra_netnum_override = {
    standard = local.intra_subnets[var.subnet_cidr]
    override = var.intra_netnum
  }
  database_netnum_override = {
    standard = local.database_subnets[var.subnet_cidr]
    override = var.database_netnum
  }
  elasticache_netnum_override = {
    standard = local.elasticache_subnets[var.subnet_cidr]
    override = var.elasticache_netnum
  }
  redshift_netnum_override = {
    standard = local.redshift_subnets[var.subnet_cidr]
    override = var.redshift_netnum
  }
  # this determines the size of all other subnets
  subnets= {
    "/16"     = "6"
    "/17"     = "5"
    "/18"     = "5"
    "/19"     = "5"
    "/20"     = "5"
  }
  public_subnets = {
    "/16"     = "49"
    "/17"     = "17"
    "/18"     = "17"
    "/19"     = "17"
    "/20"     = "17"
  }
  intra_subnets = {
    "/16"     = "52"
    "/17"     = "20"
    "/18"     = "20"
    "/19"     = "20"
    "/20"     = "20"
  }
  database_subnets = {
    "/16"     = "55"
    "/17"     = "23"
    "/18"     = "23"
    "/19"     = "23"
    "/20"     = "23"
  }
  elasticache_subnets = {
    "/16"     = "58"
    "/17"     = "26"
    "/18"     = "26"
    "/19"     = "26"
    "/20"     = "26"
  }
  redshift_subnets = {
    "/16"     = "61"
    "/17"     = "29"
    "/18"     = "29"
    "/19"     = "29"
    "/20"     = "29"
  }
  redshiftno = {
    false = var.az_count
    true = 0
  }
  databaseno = {
    false = var.az_count
    true = 0
  }
  publicno = {
    false = var.az_count
    true = 0
  }
  privateno = {
    false = var.az_count
    true = 0
  }
  intrano = {
    false = var.az_count
    true = 0
  }
  elasticacheno = {
    false = var.az_count
    true = 0
  }
  single_nat_gateway = {
    "none" = false
    "single_az" = true
    "multi_az" = false
    "nat_instance" = false
  }
  enable_nat_gateway = {
    "none" = false
    "single_az" = true
    "multi_az" = true
    "nat_instance" = false
  }
  one_nat_gateway_per_az = {
    "none" = false
    "single_az" = false
    "multi_az" = true
    "nat_instance" = false
  }
  nat_instance = {
    "none" = false
    "single_az" = false
    "multi_az" = false
    "nat_instance" = true
  }
  tags = {
    "truemark:responsibility" = "full"
  }
  publictags = merge(var.publictags,{
    "truemark:responsibility" = "full"
  })
  privatetags = merge(var.privatetags,{
    "truemark:responsibility" = "full"
  })
  intratags = merge(var.intratags,{
    "truemark:responsibility" = "full"
  })
  databasetags = merge(var.databasetags,{
    "truemark:responsibility" = "full"
  })
  elasticachetags = merge(var.elasticachetags,{
    "truemark:responsibility" = "full"
  })
  redshifttags = merge(var.redshifttags,{
    "truemark:responsibility" = "full"
  })
  cidr_subnet = "${var.network}${var.subnet_cidr}"
}

resource "aws_eip" "nat_gateway_ips" {
  count = var.nat_type == "single_az" ? 1 : var.nat_type == "multi_az" ? var.az_count : 0
  vpc   = true
}

module "vpc" {
  source                          = "terraform-aws-modules/vpc/aws"
  version                         = "3.18.1"
  name                            = "services"
  cidr                            = local.cidr_subnet
  azs                             = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  private_subnets                 = [for num in range(local.privateno[var.private], length(slice(data.aws_availability_zones.available.names, 0, var.az_count))):cidrsubnet(local.cidr_subnet, local.private_network_override[var.network_override], num)]
  public_subnets                  = [for num in range(local.publicno[var.public], length(slice(data.aws_availability_zones.available.names, 0, var.az_count))):cidrsubnet(local.cidr_subnet, local.public_network_override[var.network_override], num + local.public_netnum_override[var.network_override])]
  intra_subnets                   = [for num in range(local.intrano[var.intra], length(slice(data.aws_availability_zones.available.names, 0, var.az_count))):cidrsubnet(local.cidr_subnet, local.intra_network_override[var.network_override], num + local.intra_netnum_override[var.network_override])]
  database_subnets                = [for num in range(local.databaseno[var.database], length(slice(data.aws_availability_zones.available.names, 0, var.az_count))):cidrsubnet(local.cidr_subnet, local.database_network_override[var.network_override], num + local.database_netnum_override[var.network_override])]
  elasticache_subnets             = [for num in range(local.elasticacheno[var.elasticache], length(slice(data.aws_availability_zones.available.names, 0, var.az_count))):cidrsubnet(local.cidr_subnet, local.elasticache_network_override[var.network_override], num + local.elasticache_netnum_override[var.network_override])]
  redshift_subnets                = [for num in range(local.redshiftno[var.redshift], length(slice(data.aws_availability_zones.available.names, 0, var.az_count))):cidrsubnet(local.cidr_subnet, local.redshift_network_override[var.network_override], num + local.redshift_netnum_override[var.network_override])]
  enable_nat_gateway              = local.enable_nat_gateway[var.nat_type]
  single_nat_gateway              = local.single_nat_gateway[var.nat_type]
  one_nat_gateway_per_az          = local.one_nat_gateway_per_az[var.nat_type]
  reuse_nat_ips                   = true
  external_nat_ip_ids             = aws_eip.nat_gateway_ips.*.id
  enable_ipv6                     = true
  assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes    = [0, 1, 2]
  public_subnet_ipv6_prefixes     = [3, 4, 5]
  intra_subnet_ipv6_prefixes      = [6, 7, 8]
  database_subnet_ipv6_prefixes   = [9, 10, 11]
  elasticache_subnet_ipv6_prefixes = [12, 13, 14]
  redshift_subnet_ipv6_prefixes   = [15, 16, 17]
  enable_dns_hostnames            = true
  enable_dns_support              = true
  manage_default_network_acl      = true
  public_dedicated_network_acl    = false
  tags                            = merge(local.tags, {})
  public_subnet_tags = merge(local.tags,local.publictags, {
    network                              = "public"
  })
  private_subnet_tags = merge(local.tags,local.privatetags, {
    network                              = "private"
  })
  intra_subnet_tags = merge(local.tags,local.intratags, {
    "network" = "intra"
  })
  database_subnet_tags = merge(local.tags,local.databasetags, {
    "network" = "database"
  })
  elasticache_subnet_tags = merge(local.tags,local.elasticachetags, {
    "network" = "elasticache"
  })
  redshift_subnet_tags = merge(local.tags,local.redshifttags, {
    "network" = "redshift"
  })
  default_network_acl_ingress = [
    {
      rule_no    = 99
      action     = "deny"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "172.30.0.0/21"
    },
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
  default_network_acl_egress = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    }
  ]
}

module "nat_instance" {
  count = local.nat_instance[var.nat_type] ? 1 : 0
  source = "int128/nat-instance/aws"

  name                        = "main"
  vpc_id                      = module.vpc.vpc_id
  public_subnet               = module.vpc.public_subnets[0]
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  private_route_table_ids     = module.vpc.private_route_table_ids
}

resource "aws_eip" "nat_instance_ip" {
  count = local.nat_instance[var.nat_type] ? 1 : 0
  network_interface = module.nat_instance[0].eni_id
  tags = {
    "Name" = "nat-instance-main"
  }
}

