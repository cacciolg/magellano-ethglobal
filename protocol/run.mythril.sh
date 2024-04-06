#!/bin/bash -ex

default_arg="text"

if [ "$#" -eq 0 ]; then
  arg="$default_arg"
else
  arg="$1"
fi

contract="${2:-*.sol}"

# Match input argument against multiple cases
case $arg in
  'text')
    print_arg="text"
    ;;
  'markdown')
    print_arg="markdown"
    ;;
  'json')
    print_arg="json"
    ;;
  'jsonv2')
    print_arg="jsonv2"
    ;;
  *)
    echo "Invalid printer: $arg"
    echo "Valid printers: text, markdown, json, jsonv2"
    exit 1
    ;;
esac

exec docker run \
  -v $(pwd):/tmp \
  -w /tmp \
  solc-analyzers/mythril:latest \
  analyze contracts/$contract \
  --solc-json analyzers/mythril.solc.json \
  -o $print_arg --max-depth 22 -t4
