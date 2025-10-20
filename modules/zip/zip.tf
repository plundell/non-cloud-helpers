###############################################################
# File: non-cloud-helpers/modules/zip/zip.tf
#
# Package a .js file into a .zip which AWS Lambda can use.
###############################################################

# Terraform block: define required providers and versions
terraform {
  required_providers {
    archive = {
      source  = "registry.opentofu.org/hashicorp/archive"
      version = ">= 2.0"
    }
  }
}

#------------ Required Inputs --------------

variable "source_dir" {
  type        = string
  description = "Directory where all source files are located"
}

variable "output_file_path" {
  type        = string
  description = "The path to the output zip file"
}


#---------- Optional Inputs -------------------
variable "file_map" {
  type        = map(string)
  description = "Files to include in the zip. Keys are relative filepaths in source_dir, values are relative filepaths in archive"
  default = {
    "index.js" = "index.js"
  }
}

variable "template_variables" {
  type        = map(string)
  description = "Template variables used to inject values into the file before archiving. These are applied to all source files."
  default     = null
}




#--------------- Main -----------------

# Package .js file into a .zip which AWS Lambda can use
data "archive_file" "this" {
  type        = "zip"
  output_path = var.output_file_path

  dynamic "source" {
    for_each = var.file_map
    content {
      filename = source.value
      content  = var.template_variables != null ? templatefile("${var.source_dir}/${source.key}", var.template_variables) : file("${var.source_dir}/${source.key}")
    }
  }
}


#---------------- Outputs----------------

output "output_file_path" {
  description = "The path to the output zip file"
  value       = data.archive_file.this.output_path
}

output "hash" {
  description = "The source code hash of the zip file"
  value       = data.archive_file.this.output_base64sha256
}
