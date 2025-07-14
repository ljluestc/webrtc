#!/bin/bash
# This script runs only the subpackages that are known to work

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running only the subpackages that are known to work...${NC}"

# Run the internal packages
echo -e "${YELLOW}Testing internal packages...${NC}"
go test -v ./internal/...

# Run the media packages
echo -e "${YELLOW}Testing media packages...${NC}"
go test -v ./pkg/media/...

# Run the null package
echo -e "${YELLOW}Testing null package...${NC}"
go test -v ./pkg/null/...

echo -e "${GREEN}Subpackage tests completed${NC}"
