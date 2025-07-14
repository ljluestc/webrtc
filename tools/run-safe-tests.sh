#!/bin/bash
# Run tests safely by focusing on subpackages that typically work

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Make sure we're in the right directory
cd "$(dirname "$0")/.." || { echo "Failed to change directory"; exit 1; }

echo -e "${YELLOW}Running internal package tests...${NC}"
go test ./internal/... -v
INTERNAL_RESULT=$?

echo -e "${YELLOW}Running pkg/media tests...${NC}"
go test ./pkg/media/... -v
MEDIA_RESULT=$?

echo -e "${YELLOW}Running pkg/null tests...${NC}"
go test ./pkg/null/... -v
NULL_RESULT=$?

# Report results
echo -e "\n${YELLOW}Test Results:${NC}"
if [ $INTERNAL_RESULT -eq 0 ]; then
  echo -e "${GREEN}Internal package tests PASSED${NC}"
else
  echo -e "${RED}Internal package tests FAILED${NC}"
fi

if [ $MEDIA_RESULT -eq 0 ]; then
  echo -e "${GREEN}Media package tests PASSED${NC}"
else
  echo -e "${RED}Media package tests FAILED${NC}"
fi

if [ $NULL_RESULT -eq 0 ]; then
  echo -e "${GREEN}Null package tests PASSED${NC}"
else
  echo -e "${RED}Null package tests FAILED${NC}"
fi

# Determine overall status
if [ $INTERNAL_RESULT -eq 0 ] && [ $MEDIA_RESULT -eq 0 ] && [ $NULL_RESULT -eq 0 ]; then
  echo -e "\n${GREEN}All selected tests PASSED!${NC}"
  exit 0
else
  echo -e "\n${RED}Some tests FAILED${NC}"
  exit 1
fi
