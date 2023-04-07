variable "network" {
  description = "This is the network address of the subnet you want to use"
  type        = string
}
# TODO Spell this out so you know what it is when you read it
variable "subnet_cidr" {
  description = "This is the network cidr of the subnet you want to use"
  type        = string
}
variable "az_count" {
  description = "This is the number of availability zones to use"
  type        = number
  default     = 2
}
variable "network_override" {
  description = "This is used if you want to override the subnet settings that are built in and use your own. setting this variable to override allows you to specify networkbits to add to vpc subnet and which netnum to use. Please see the following documentation. https://developer.hashicorp.com/terraform/language/functions/cidrsubnet "
  type        = string
  default     = "standard"
}
variable "private_newbits" {
  description = "This variable is needed only if you are using the network_override variable. It is used to set the cidr to be used for the private networks"
  type        = number
  default     = null
}
variable "public_newbits" {
  description = "This variable is needed only if you are using the network_override variable. It is used to set the cidr to be used for the public networks"
  type        = number
  default     = null
}
variable "intra_newbits" {
  description = "This variable is needed only if you are using the network_override variable. It is used to set the cidr to be used for the intra networks"
  type        = number
  default     = null
}
variable "database_newbits" {
  description = "This variable is needed only if you are using the network_override variable. It is used to set the cidr to be used for the database networks"
  type        = number
  default     = null
}
variable "elasticache_newbits" {
  description = "This variable is needed only if you are using the network_override variable. It is used to set the cidr to be used for the elasticache networks"
  type        = number
  default     = null
}
variable "redshift_newbits" {
  description = "This variable is needed only if you are using the network_override variable. It is used to set the cidr to be used for the redshift networks"
  type        = number
  default     = null
}
variable "public_netnum" {
  description = "This variable is needed only if you are using the network_override variable. It is used to set the starting netnum to be used for the public networks"
  type        = number
  default     = null
}
variable "intra_netnum" {
  description = "This variable is needed only if you are using the network_override variable. It is used to set the starting netnum to be used for the intra networks"
  type        = number
  default     = null
}
variable "database_netnum" {
  description = "This variable is needed only if you are using the network_override variable. It is used to set the starting netnum to be used for the databse networks"
  type        = number
  default     = null
}
variable "elasticache_netnum" {
  description = "This variable is needed only if you are using the network_override variable. It is used to set the starting netnum to be used for the elasticache networks"
  type        = number
  default     = null
}
variable "redshift_netnum" {
  description = "This variable is needed only if you are using the network_override variable. It is used to set the starting netnum to be used for the redshift networks"
  type        = number
  default     = null
}

# TODO Likely shouldn't be a number. This should be three options, SINGLE_AZ, MULTI_AZ, POOR_PERSON_NAT, OR NONE
variable "nat_type" {
  description = "Set nat type. The options are none, single_az, multi_az, and nat_instance. Single spins up a nat gateway in one availability zone. Multi spins up a nat gateway in each availability zone. nat instance uses the module int128/nat-instance/aws to create a small nat instance."
  type        = string
  default     = "none"
}

variable "publictags" {
  description = "Add tags to public networks"
  type        = map(string)
  default     = null
}

variable "privatetags" {
  description = "Add tags to private networks"
  type        = map(string)
  default     = null
}

variable "intratags" {
  description = "Add tags to intra networks"
  type        = map(string)
  default     = null
}

variable "databasetags" {
  description = "Add tags to database networks"
  type        = map(string)
  default     = null
}

variable "elasticachetags" {
  description = "Add tags to elasticache networks"
  type        = map(string)
  default     = null
}

variable "redshifttags" {
  description = "Add tags to redshift networks"
  type        = map(string)
  default     = null
}
variable "redshift" {
  description = "Ability to add redshift networks. They are not created by default"
  type        = bool
  default     = false
}
variable "intra" {
  description = "Ability to remove intra networks. Set to false to not create."
  type        = bool
  default     = true
}
variable "database" {
  description = "Ability to remove database networks. Set to false to not create."
  type        = bool
  default     = true
}
variable "elasticache" {
  description = "Ability to remove elasticache networks. Set to false to not create."
  type        = bool
  default     = true
}
variable "private" {
  description = "Ability to remove private networks. Set to false to not create."
  type        = bool
  default     = true
}
variable "public" {
  description = "Ability to remove public networks. Set to false to not create."
  type        = bool
  default     = true
}

variable "instance_types" {
  description = "Candidates of spot instance type for the NAT instance. This is used in the mixed instances policy"
  type        = list(string)
  default     = null
}

variable "architecture" {
  description = "Candidates of spot instance type for the NAT instance. This is used in the mixed instances policy"
  type        = list(string)
  default     = null
}

variable "use_spot_instance" {
  description = "Whether to use spot or on-demand EC2 instance"
  type        = bool
  default     = null
}
