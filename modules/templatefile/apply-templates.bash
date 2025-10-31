#!/usr/bin/env bash
set -eu
function usage() {
  echo "Apply templates to an input file and write the result to an output file." >&2
  echo "If no output file is provided, the result is written to a temporary file." >&2
  echo "This script will echo a JSON object: { \"output_file\": \"path/to/output_file\" }" >&2
  echo "" >&2
  echo "Usage: $0 -i path/to/input_file [-o path/to/output_file] [pattern1 replacement1 ...]" >&2
}


# Handle command-line arguments
while getopts "i:o:" opt; do
  case $opt in
    i) input_file="$OPTARG" ;;
    o) output_file="$OPTARG" ;;
    *) usage ; exit 1 ;;
  esac
done

default_output_dir="/tmp/tofu"

# After getopts OPTIND is the index of the next argument to be processed,
# so shift by OPTIND-1 in order to remove everything already processed.
shift $((OPTIND - 1))

# Validate inputs
if [ -z "${input_file:-}" ]; then
  echo "-i input_file is required" >&2
  exit 1
fi
if [ $(( $# % 2 )) -ne 0 ]; then
  echo "Pattern/replacement args must come in pairs (even number of args)." >&2
  exit 1
fi

# Make sure the files are in order
if [ ! -f "$input_file" ] || [ ! -s "$input_file" ]; then
  echo "Input file does not exist or is empty: $input_file" >&2
  exit 1
fi
output_file="${output_file:-}"
if [ -z "${output_file}" ]; then
	mkdir -p "${default_output_dir}"
	output_file="$(mktemp "${default_output_dir}/$(basename "$input_file").XXXXXX")" #create a temporary file if no output file is provided
elif [ ! -f "${output_file}" ]; then
	touch "${output_file}" #create an empty file if it doesn't exist
elif [ -s "${output_file}" ]; then
  echo "Output file is not empty: $output_file" >&2
  exit 1
fi


# Copy the contents of the input file to the output file as is...
cat "$input_file" > "$output_file"

# ...then iterate over pairs and apply replacements in order
while [ $# -gt 0 ]; do
  pattern="$1"; replacement="$2"
  shift 2

  # Use a rarely-used delimiter to avoid common escaping issues
  delim=$'\x1F'  # Unit Separator, unlikely to appear in normal text

  # Escape backslashes and ampersands in the replacement for sed's RHS
  rep_esc=${replacement//\\/\\\\}
  rep_esc=${rep_esc//&/\\&}
  
  # Escape the delimiter in the replacement
  rep_esc=${rep_esc//${delim}/\\${delim}}

  # Escape the delimiter in the pattern (LHS)
  pat_esc=${pattern//${delim}/\\${delim}}

  # Perform in-place global replacement on the output file
  sed -i -E -e "s${delim}${pat_esc}${delim}${rep_esc}${delim}g" "$output_file"
done

echo "{\"output_file\": \"$output_file\"}"

