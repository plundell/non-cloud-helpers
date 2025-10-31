locals {
  bash_script = "${path.module}/apply-templates.bash"
}


# This external data-block runs the bash script that applies replacements to the input file and writes 
# the processed content to a temporary output file. The script prints the temp file path as a JSON 
# object which the data-block captures and makes available as data.external.apply_templates.result.output_file.
data "external" "apply_templates" {
  count = var.replacements != null ? 1 : 0
  program = concat(
    [
      "bash", local.bash_script,
      "-i", var.filepath,
    ],
    flatten([for r in var.replacements : [r[0], r[1]]])
  )
}


# After running the script we read the temporary file into the contents variable.
locals {
  tempfile = var.replacements == null ? null : data.external.apply_templates[0].result.output_file
  contents = var.replacements == null ? file(var.filepath) : file(local.tempfile)
}

# If we want to delete the temporary file after processing we run a data-block that 
# removes the file and prints an empty JSON object. By virtue of referencing local.contents
# this block will run after we have captured the contents.
# data "external" "remove_tempfile" {
#   count      = var.delete_tempfile && local.tempfile != null && length(local.contents) > 0 ? 1 : 0
#   program    = ["bash", "-c", "rm -f ${local.tempfile} && echo '{}';"]
#   depends_on = [local.contents]
# }
