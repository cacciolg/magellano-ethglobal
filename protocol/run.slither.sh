#!/bin/bash -ex

default_arg="human"

if [ "$#" -eq 0 ]; then
  arg="$default_arg"
else
  arg="$1"
fi

contract="${2:-}"

# Match input argument against multiple cases
case $arg in
  'human')
    print_arg="--print human-summary --show-ignored-findings"
    ;;
  'inheritance')
    print_arg="--print inheritance-graph"
    ;;
  'function')
    print_arg="--print function-summary"
    ;;
  'contract')
    print_arg="--print contract-summary"
    ;;
  'callgraph')
    print_arg="--print call-graph"
    ;;
  'cfg')
    print_arg="--print cfg"
    ;;
  '-')
    print_arg=""
    ;;
  *)
    echo "Invalid printer: $arg"
    echo "Valid printers: human, inheritance, function, callgraph, cfg"
    exit 1
    ;;
esac


exec docker run \
  -v $(pwd):/tmp \
  -w /tmp \
  solc-analyzers/slither:latest \
  --config-file analyzers/slither.config.json \
  --checklist \
  $print_arg \
  contracts/$contract
