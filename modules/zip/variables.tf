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
  type        = list(tuple([string, string]))
  description = "Template variables used to inject values into the file before archiving. These are applied to all source files."
  default     = null
}
