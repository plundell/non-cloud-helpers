#---------------- Outputs----------------

output "output_file_path" {
  description = "The path to the output zip file"
  value       = data.archive_file.this.output_path
}

output "hash" {
  description = "The source code hash of the zip file"
  value       = data.archive_file.this.output_base64sha256
}
