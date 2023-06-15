data "aws_availability_zones" "available" {}

locals {
  # This determines the size of the private subnets
  private_subnets = {
    "/16" = "3"
    "/17" = "3"
    "/18" = "3"
    "/19" = "3"
    "/20" = "4"
  }
  #private subnet override
  private_network_override = {
    standard = local.private_subnets[var.subnet_cidr]
    override = var.private_newbits
  }
  public_network_override = {
    standard = local.subnets[var.subnet_cidr]
    override = var.public_newbits
  }
  intra_network_override = {
    standard = local.subnets[var.subnet_cidr]
    override = var.intra_newbits
  }
  database_network_override = {
    standard = local.subnets[var.subnet_cidr]
    override = var.database_newbits
  }
  elasticache_network_override = {
    standard = local.subnets[var.subnet_cidr]
    override = var.elasticache_newbits
  }
  redshift_network_override = {
    standard = local.subnets[var.subnet_cidr]
    override = var.redshift_newbits
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
  subnets = {
    "/16" = "6"
    "/17" = "5"
    "/18" = "5"
    "/19" = "5"
    "/20" = "5"
  }
  public_subnets = {
    "/16" = "49"
    "/17" = "17"
    "/18" = "17"
    "/19" = "17"
    "/20" = "17"
  }
  intra_subnets = {
    "/16" = "52"
    "/17" = "20"
    "/18" = "20"
    "/19" = "20"
    "/20" = "20"
  }
  database_subnets = {
    "/16" = "55"
    "/17" = "23"
    "/18" = "23"
    "/19" = "23"
    "/20" = "23"
  }
  elasticache_subnets = {
    "/16" = "58"
    "/17" = "26"
    "/18" = "26"
    "/19" = "26"
    "/20" = "26"
  }
  redshift_subnets = {
    "/16" = "61"
    "/17" = "29"
    "/18" = "29"
    "/19" = "29"
    "/20" = "29"
  }
  redshiftno = {
    false = var.az_count
    true  = 0
  }
  databaseno = {
    false = var.az_count
    true  = 0
  }
  publicno = {
    false = var.az_count
    true  = 0
  }
  privateno = {
    false = var.az_count
    true  = 0
  }
  intrano = {
    false = var.az_count
    true  = 0
  }
  elasticacheno = {
    false = var.az_count
    true  = 0
  }
  single_nat_gateway = {
    "none"         = false
    "single_az"    = true
    "multi_az"     = false
    "nat_instance" = false
  }
  enable_nat_gateway = {
    "none"         = false
    "single_az"    = true
    "multi_az"     = true
    "nat_instance" = false
  }
  one_nat_gateway_per_az = {
    "none"         = false
    "single_az"    = false
    "multi_az"     = true
    "nat_instance" = false
  }
  nat_instance = {
    "none"         = false
    "single_az"    = false
    "multi_az"     = false
    "nat_instance" = true
  }
  tags = {

  }
  publictags = merge(var.publictags, {
  })
  privatetags = merge(var.privatetags, {
  })
  intratags = merge(var.intratags, {
  })
  databasetags = merge(var.databasetags, {
  })
  elasticachetags = merge(var.elasticachetags, {
  })
  redshifttags = merge(var.redshifttags, {
  })
  aclingress = var.default_network_acl_ingress
  aclegress = var.default_network_acl_egress
  cidr_subnet = "${var.network}${var.subnet_cidr}"
  #   endpoints

  endpoint = {
    s3 = {
      service          = "s3"
      route_tables_ids = [module.vpc.private_route_table_ids]
      tags             = { Name = "s3-vpc-endpoint" }
      create           = var.s3
    }
    dynamodb = {
      service          = "dynamodb"
      route_tables_ids = [module.vpc.private_route_table_ids]
      tags             = { Name = "dynamodb-vpc-endpoint" }
      create           = var.dynamo
    }
  }
}

resource "aws_eip" "nat_gateway_ips" {
  count = var.nat_type == "single_az" ? 1 : var.nat_type == "multi_az" ? var.az_count : 0
  vpc   = true
}

module "vpc" {
  source                           = "terraform-aws-modules/vpc/aws"
  version                          = "3.18.1"
  name                             = "services"
  cidr                             = local.cidr_subnet
  azs                              = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  private_subnets                  = [for num in range(local.privateno[var.private], length(slice(data.aws_availability_zones.available.names, 0, var.az_count))) : cidrsubnet(local.cidr_subnet, local.private_network_override[var.network_override], num)]
  public_subnets                   = [for num in range(local.publicno[var.public], length(slice(data.aws_availability_zones.available.names, 0, var.az_count))) : cidrsubnet(local.cidr_subnet, local.public_network_override[var.network_override], num + local.public_netnum_override[var.network_override])]
  intra_subnets                    = [for num in range(local.intrano[var.intra], length(slice(data.aws_availability_zones.available.names, 0, var.az_count))) : cidrsubnet(local.cidr_subnet, local.intra_network_override[var.network_override], num + local.intra_netnum_override[var.network_override])]
  database_subnets                 = [for num in range(local.databaseno[var.database], length(slice(data.aws_availability_zones.available.names, 0, var.az_count))) : cidrsubnet(local.cidr_subnet, local.database_network_override[var.network_override], num + local.database_netnum_override[var.network_override])]
  elasticache_subnets              = [for num in range(local.elasticacheno[var.elasticache], length(slice(data.aws_availability_zones.available.names, 0, var.az_count))) : cidrsubnet(local.cidr_subnet, local.elasticache_network_override[var.network_override], num + local.elasticache_netnum_override[var.network_override])]
  redshift_subnets                 = [for num in range(local.redshiftno[var.redshift], length(slice(data.aws_availability_zones.available.names, 0, var.az_count))) : cidrsubnet(local.cidr_subnet, local.redshift_network_override[var.network_override], num + local.redshift_netnum_override[var.network_override])]
  enable_nat_gateway               = local.enable_nat_gateway[var.nat_type]
  single_nat_gateway               = local.single_nat_gateway[var.nat_type]
  one_nat_gateway_per_az           = local.one_nat_gateway_per_az[var.nat_type]
  reuse_nat_ips                    = true
  external_nat_ip_ids              = aws_eip.nat_gateway_ips.*.id
  enable_ipv6                      = true
  assign_ipv6_address_on_creation  = true
  private_subnet_ipv6_prefixes     = [0, 1, 2]
  public_subnet_ipv6_prefixes      = [3, 4, 5]
  intra_subnet_ipv6_prefixes       = [6, 7, 8]
  database_subnet_ipv6_prefixes    = [9, 10, 11]
  elasticache_subnet_ipv6_prefixes = [12, 13, 14]
  redshift_subnet_ipv6_prefixes    = [15, 16, 17]
  enable_dns_hostnames             = true
  enable_dns_support               = true
  manage_default_network_acl       = true
  public_dedicated_network_acl     = false
  tags                             = merge(local.tags, {})
  public_subnet_tags = merge(local.tags, local.publictags, {
    network = "public"
  })
  private_subnet_tags = merge(local.tags, local.privatetags, {
    network = "private"
  })
  intra_subnet_tags = merge(local.tags, local.intratags, {
    "network" = "intra"
  })
  database_subnet_tags = merge(local.tags, local.databasetags, {
    "network" = "database"
  })
  elasticache_subnet_tags = merge(local.tags, local.elasticachetags, {
    "network" = "elasticache"
  })
  redshift_subnet_tags = merge(local.tags, local.redshifttags, {
    "network" = "redshift"
  })
  default_network_acl_ingress = local.aclingress
  default_network_acl_ingress = local.aclegress

}

module "nat_instance" {
  count                       = local.nat_instance[var.nat_type] ? 1 : 0
  source                      = "truemark/nat-instance/aws"
  version                     = "3.0.1"
  name                        = "main"
  vpc_id                      = module.vpc.vpc_id
  public_subnet               = module.vpc.public_subnets[0]
  private_subnets_cidr_blocks = concat(module.vpc.private_subnets_cidr_blocks, module.vpc.database_subnets_cidr_blocks, module.vpc.elasticache_subnets_cidr_blocks, module.vpc.redshift_subnets_cidr_blocks)
  private_route_table_ids     = module.vpc.private_route_table_ids
  architecture                = var.architecture
  instance_types              = var.instance_types
  use_spot_instance           = var.use_spot_instance
}

resource "aws_eip" "nat_instance_ip" {
  count             = local.nat_instance[var.nat_type] ? 1 : 0
  network_interface = module.nat_instance[0].eni_id
  tags = {
    "Name" = "nat-instance-main"
  }
}

################################################################################
# Endpoint(s)
################################################################################

locals {
  endpoints = { for k, v in local.endpoint : k => v if var.create  && try(v.create, true)   }
}

data "aws_vpc_endpoint_service" "this" {
  for_each = local.endpoints

  service      = lookup(each.value, "service", null)
  service_name = lookup(each.value, "service_name", null)

  filter {
    name   = "service-type"
    values = [lookup(each.value, "service_type", "Gateway")]
  }
}

resource "aws_vpc_endpoint" "this" {
  for_each = local.endpoints

  vpc_id            = module.vpc.vpc_id
  service_name      = data.aws_vpc_endpoint_service.this[each.key].service_name
  vpc_endpoint_type = lookup(each.value, "service_type", "Gateway")
  auto_accept       = lookup(each.value, "auto_accept", null)

  security_group_ids  = lookup(each.value, "service_type", "Interface") == "Interface" ? length(distinct(concat(var.security_group_ids, lookup(each.value, "security_group_ids", [])))) > 0 ? distinct(concat(var.security_group_ids, lookup(each.value, "security_group_ids", []))) : null : null
  subnet_ids          = lookup(each.value, "service_type", "Interface") == "Interface" ? distinct(concat(var.subnet_ids, lookup(each.value, "subnet_ids", []))) : null
  route_table_ids     = lookup(each.value, "service_type", "Interface") == "Gateway" ? lookup(each.value, "route_table_ids", null) : null
  policy              = lookup(each.value, "policy", null)
  private_dns_enabled = lookup(each.value, "service_type", "Interface") == "Interface" ? lookup(each.value, "private_dns_enabled", null) : null

  tags = merge(var.tags, lookup(each.value, "tags", {}))

  timeouts {
    create = lookup(var.timeouts, "create", "10m")
    update = lookup(var.timeouts, "update", "10m")
    delete = lookup(var.timeouts, "delete", "10m")
  }
}
