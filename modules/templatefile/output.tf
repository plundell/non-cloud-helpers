output "contents" {
  value       = local.contents
  description = "The contents of the file with replacement values inserted if provided"
}

output "tempfile" {
  value       = var.delete_tempfile ? null : local.tempfile #can still be null if no replacements are provided
  description = "The filepath of a temporary file which needs to be cleaned up after this module is used"
}
