variable "filepath" {
  type        = string
  description = "The path to the file to be processed."
}

variable "replacements" {
  type        = list(tuple([string, string]))
  description = "A list of tuples containing the replacements. The first element in each tuple is the regex pattern, the second is the replacement string."
  default     = null
}

variable "delete_tempfile" {
  type        = bool
  description = "Whether to delete the temporary file after processing."
  default     = true
}
