###############################################################
# module: non-cloud-helpers/modules/tls
#
# Generate an RSA key pair and return the pem values.
###############################################################



# Generate key pair
resource "tls_private_key" "this" {
  algorithm = var.algorithm
  rsa_bits  = var.bits
}


