#!/bin/bash
# Script to install missing dependencies for the WebRTC tests

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Installing missing dependencies for WebRTC tests...${NC}"

# Install the dtls/v2 package for compatibility with tests
echo -e "${YELLOW}Installing github.com/pion/dtls/v2...${NC}"
go get github.com/pion/dtls/v2

# Check result
if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully installed dtls/v2${NC}"
else
  echo -e "${RED}Failed to install dtls/v2${NC}"
fi

# You might also want to update your go.mod file
echo -e "${YELLOW}Tidying up go.mod file...${NC}"
go mod tidy

# Check result
if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully tidied go.mod${NC}"
else
  echo -e "${RED}Failed to tidy go.mod${NC}"
fi

echo -e "${YELLOW}Now running tests to verify everything works...${NC}"
go test -run TestInvalidFingerprint ./...

echo -e "\n${YELLOW}Installation complete!${NC}"
echo "If you still experience issues, try running the tests with:"
echo "go test -v -timeout 3m ./..."
