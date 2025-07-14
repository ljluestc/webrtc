#!/bin/bash
# This script installs all required dependencies for testing

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Installing required dependencies...${NC}"

# Main WebRTC dependencies
echo -e "${YELLOW}Installing main WebRTC dependencies...${NC}"
go get github.com/pion/dtls/v2
go get github.com/pion/transport/v3
go get github.com/stretchr/testify

# Update go.mod
echo -e "${YELLOW}Updating go.mod...${NC}"
go mod tidy

echo -e "${GREEN}Dependencies installed successfully!${NC}"
echo -e "${YELLOW}Now you can run the tests with:${NC}"
echo "go test -v -run TestSimple ./..."
