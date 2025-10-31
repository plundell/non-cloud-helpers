###############################################################
# module: non-cloud-helpers/modules/zip
#
# Package multiple files into a .zip, optionally applying
# template variables in the process.
###############################################################
locals {
  #Turn the map into a list of tuples so we can use them for both "count" and "for_each"
  file_list = [
    for source_file, dest_file in var.file_map :
    ["${var.source_dir}/${source_file}", dest_file]
  ]
}

# Load each file and apply the template variables if provided
module "templatefile" {
  count        = length(local.file_list)
  source       = "../templatefile"
  filepath     = local.file_list[count.index][0]
  replacements = var.template_variables
}

data "archive_file" "this" {
  type        = "zip"
  output_path = var.output_file_path

  dynamic "source" {
    for_each = local.file_list
    content {
      filename = source.value[1] # path of file inside zip
      content  = module.templatefile[source.key].contents
    }
  }
}


