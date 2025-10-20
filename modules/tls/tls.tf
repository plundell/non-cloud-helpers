###############################################################
# File: non-cloud-helpers/modules/tls/tls.tf
#
# Generate an RSA key pair and return the pem values.
###############################################################

terraform {
  required_providers {
    tlsname = {
      source  = "registry.opentofu.org/hashicorp/tls"
      version = ">= 3.0"
    }
  }
}

#------------ Optional Inputs --------------
variable "algorithm" {
  type        = string
  description = "The algorithm to use for the key pair"
  default     = "RSA"
}

variable "bits" {

  type        = number
  description = "The number of bits for the key"
  default     = 2048
}

#-------------- Main -----------------------
# Generate key pair
resource "tls_private_key" "this" {
  algorithm = var.algorithm
  rsa_bits  = var.bits
}


#----------------- Output ------------------
output "public_key_pem" {
  description = "The public key pem."
  value       = tls_private_key.this.public_key_pem
}

output "private_key_pem" {
  description = "The private key pem."
  value       = tls_private_key.this.private_key_pem
}
