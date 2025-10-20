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
