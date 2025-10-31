output "name" {
  description = "The name of the test."
  value       = var.name
}

output "command" {
  description = "The command to run the test."
  value       = var.command
}

output "description" {
  description = "A description of what is being tested."
  value       = var.description
}

output "suggest_fix" {
  description = "A suggestion for a fix for the test failure."
  value       = var.suggest_fix
}
