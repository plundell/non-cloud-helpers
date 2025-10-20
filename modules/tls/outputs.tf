#----------------- Output ------------------
output "public_key_pem" {
  description = "The public key pem."
  value       = tls_private_key.this.public_key_pem
}

output "private_key_pem" {
  description = "The private key pem."
  value       = tls_private_key.this.private_key_pem
}
