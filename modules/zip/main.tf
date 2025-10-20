###############################################################
# module: non-cloud-helpers/modules/zip
#
# Package multiple files into a .zip, optionally applying
# template variables in the process.
###############################################################


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


