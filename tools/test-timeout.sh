#!/bin/bash
# This script runs Go tests with an increased timeout value

# Default timeout value (3 minutes)
TIMEOUT=${1:-3m}

# Run the tests with increased timeout
go test -timeout $TIMEOUT ./... "$@"
