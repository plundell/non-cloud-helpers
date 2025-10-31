
variable "name" {
  type        = string
  description = "A name which describes the test, usually the name of the resource being tested."
  validation {
    condition     = var.name != null && length(var.name) > 0
    error_message = "Expected a non-empty name"
  }
}

variable "command" {
  type        = string
  description = "The command to run the test. Should exit with non-zero on failure. Can output extra information to stdout."
}

variable "description" {
  type        = string
  description = "A description of what is being tested."
  default     = null
}

variable "suggest_fix" {
  type        = string
  description = "A suggestion for a fix for the test failure."
  default     = null
}

variable "run_tests" {
  type = list(object({
    name        = string
    command     = string
    description = optional(string)
    suggest_fix = optional(string)
  }))
  default     = null
  description = "A list of tests to run. Each test should be the object output by this module."

  validation {
    condition     = var.run_tests == null || all(var.run_tests[*].name != null && var.run_tests[*].command != null)
    error_message = "Each test must have a name and command."
  }
}



