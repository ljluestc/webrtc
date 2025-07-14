#!/bin/bash
# This script focuses on the problematic test with extra debug options

# Set increased timeout and run only the problematic test
go test -timeout 1m -v -run TestInvalidFingerprintCausesFailed ./...

# If it fails, run with race detector
if [ $? -ne 0 ]; then
  echo "Test failed, running with race detector..."
  go test -timeout 2m -v -race -run TestInvalidFingerprintCausesFailed ./...
fi
