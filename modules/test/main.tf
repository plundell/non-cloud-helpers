###############################################################
# File: test/main.tf
#
# Purpose: Register a test which can be run by the test/run/main.tf module
###############################################################

resource "local_file" "test_script" {
  count = var.run_tests == null ? 0 : length(var.run_tests)

  filename = "${path.root}/.test_scripts/${var.run_tests[count.index].name}.sh"
  content  = <<-EOT
    #!/bin/bash
    set -euo pipefail
    
    # Test: ${var.run_tests[count.index].name}
    # Description: ${var.run_tests[count.index].description}
	# Suggest fix: ${var.run_tests[count.index].suggest_fix}
    
    ${var.run_tests[count.index].command}
  EOT

  file_permission = "0755"
}

resource "null_resource" "run_test" {
  count = var.run_tests == null ? 0 : length(var.run_tests)

  # Trigger re-run if any tests have changed
  triggers = {
    script_content = local_file.test_script[count.index].content
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "================"
      echo "Test: ${var.run_tests[count.index].name}"
      echo "Description: ${var.run_tests[count.index].description}"
      echo "================"
      
      if ! ${local_file.test_script[count.index].filename}; then
        echo "FAILED"
        ${var.run_tests[count.index].suggest_fix != null ? "echo \"${var.run_tests[count.index].suggest_fix}\"" : ""}
        exit 1
      fi
      
      echo "PASSED"
      echo ""
    EOT
  }

  #   depends_on = [local_file.test_script[count.index]]
}



###############################################################
# End of test/main.tf
###############################################################
