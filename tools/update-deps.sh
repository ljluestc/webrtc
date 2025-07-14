#!/bin/bash
# This script updates dependencies in the WebRTC project

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Updating dependencies...${NC}"

# Step 1: Update go.mod to use the correct dtls version
echo -e "${YELLOW}Getting correct DTLS version...${NC}"
go get github.com/pion/dtls/v2

# Step 2: Tidy up go.mod
echo -e "${YELLOW}Tidying up go.mod...${NC}"
go mod tidy

# Step 3: Verify dependencies
echo -e "${YELLOW}Verifying dependencies...${NC}"
go mod verify

echo -e "\n${GREEN}Dependencies updated successfully!${NC}"
echo -e "${YELLOW}Now run tests with:${NC}"
echo "./tools/run-good-tests.sh"
