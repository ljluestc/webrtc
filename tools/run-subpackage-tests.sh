#!/bin/bash
# This script runs tests only for subpackages that don't require problematic dependencies

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Make sure we're in the right directory
cd "$(dirname "$0")/.." || { echo "Failed to change directory"; exit 1; }

echo -e "${YELLOW}Running tests for internal packages...${NC}"
go test ./internal/... -v
INTERNAL_RESULT=$?

echo -e "${YELLOW}Running tests for pkg/media packages...${NC}"
go test ./pkg/media/... -v
MEDIA_RESULT=$?

echo -e "${YELLOW}Running tests for pkg/null package...${NC}"
go test ./pkg/null/... -v
NULL_RESULT=$?

# Report results
echo -e "\n${YELLOW}Test Results:${NC}"
if [ $INTERNAL_RESULT -eq 0 ]; then
  echo -e "${GREEN}Internal package tests: PASSED${NC}"
else
  echo -e "${RED}Internal package tests: FAILED with code $INTERNAL_RESULT${NC}"
fi

if [ $MEDIA_RESULT -eq 0 ]; then
  echo -e "${GREEN}Media package tests: PASSED${NC}"
else
  echo -e "${RED}Media package tests: FAILED with code $MEDIA_RESULT${NC}"
fi

if [ $NULL_RESULT -eq 0 ]; then
  echo -e "${GREEN}Null package tests: PASSED${NC}"
else
  echo -e "${RED}Null package tests: FAILED with code $NULL_RESULT${NC}"
fi

# Determine overall result - pass if all packages passed
if [ $INTERNAL_RESULT -eq 0 ] && [ $MEDIA_RESULT -eq 0 ] && [ $NULL_RESULT -eq 0 ]; then
  echo -e "\n${GREEN}All subpackage tests PASSED!${NC}"
  exit 0
else
  echo -e "\n${RED}Some subpackage tests FAILED${NC}"
  exit 1
fi
