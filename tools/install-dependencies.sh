#!/bin/bash
# Install required dependencies for the WebRTC tests

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Installing required dependencies...${NC}"

# Make sure we're in the right directory
cd "$(dirname "$0")/.." || { echo "Failed to change directory"; exit 1; }

# Try to get the required dependencies
echo -e "${YELLOW}Installing dtls/v2...${NC}"
go get github.com/pion/dtls/v2

echo -e "${YELLOW}Installing transport/v3...${NC}"
go get github.com/pion/transport/v3

echo -e "${YELLOW}Installing stretchr/testify...${NC}"
go get github.com/stretchr/testify

# Update go.mod
echo -e "${YELLOW}Running go mod tidy...${NC}"
go mod tidy

echo -e "${GREEN}Dependencies installed. Now try running:${NC}"
echo "./tools/skip-problematic-tests.sh"
