variables {	
	filepath = "tests/test_input_file.txt"
}

run "no_replacements" {
  command = plan


  variables {
    replacements = null
    delete_tempfile = false #should not have an effect when no replacements are provided
  }

  assert {
    condition     = output.contents != ""
    error_message = "Output should contain file contents even without replacements"
  }

  assert {
    condition     = output.tempfile == null
    error_message = "Tempfile should be null when no replacements are provided"
  }
}

run "single_pattern_replacement" {
  command = plan



  variables {
    replacements = [
      ["Hello", "Hi"]
    ]
  }

  assert {
    condition     = can(regex("Hi", output.contents))
    error_message = "Output should contain the replaced value 'Hi'"
  }

  assert {
    condition     = !can(regex("Hello", output.contents))
    error_message = "Output should not contain the original value 'Hello'"
  }

  assert {
    condition     = output.tempfile == null
    error_message = "Tempfile should not exist because the default value of 'delete_tempfile' is true"
  }
}

run "multiple_replacements" {
  command = plan

  variables {
    replacements = [
      ["Hello", "Hi"],
      ["World", "Universe"]
    ]
    delete_tempfile = false
  }

  assert {
    condition     = can(regex("Hi", output.contents))
    error_message = "First replacement should be applied"
  }

  assert {
    condition     = can(regex("Universe", output.contents))
    error_message = "Second replacement should be applied"
  }
  assert {
    condition     = output.tempfile == null
    error_message = "Tempfile should exist because we passed 'delete_tempfile=false'"
  }
}

run "regex_replacement" {
  command = plan


  variables {
    replacements = [
    //   ["\\d+", "9"] //sed doesn't support perl-style regexes
      ["[[:digit:]]+", "9"],
	  ["World$", "Galaxy"]
    ]
  }

  assert {
    condition     = !can(regex("1\\.0", output.contents))
    error_message = "Regex replacement should remove the number 1.0"
  }

  assert {
    condition     = can(regex("9\\.9", output.contents))
    error_message = "Regex replacement should add the number 9.9"
  }

  assert {
    condition     = can(regex("Galaxy", output.contents))
    error_message = "Regex replacement should add the word 'Galaxy'"
  }

  assert {
    condition     = can(regex("World Again", output.contents))
    error_message = "Regex replacement should not remove the word 'World' when it's not at the end of the line"
  }
}