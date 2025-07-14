#!/bin/bash
# Script to fix dependency issues in the WebRTC project

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Fixing dependency issues...${NC}"

# Step 1: Update go.mod to use the correct dtls version
echo -e "${YELLOW}Ensuring dtls/v3 is used...${NC}"
go get github.com/pion/dtls/v3

# Step 2: Remove any dtls/v2 references
echo -e "${YELLOW}Removing any dtls/v2 references...${NC}"
if grep -r "github.com/pion/dtls/v2" --include="*.go" .; then
  echo -e "${YELLOW}Found dtls/v2 references, updating to v3...${NC}"
  find . -name "*.go" -type f -exec sed -i 's|github.com/pion/dtls/v2|github.com/pion/dtls/v3|g' {} \;
fi

# Step 3: Clean up the go.mod file
echo -e "${YELLOW}Tidying up go.mod...${NC}"
go mod tidy

# Step 4: Verify the fix worked
echo -e "${YELLOW}Verifying fix...${NC}"
if ! grep -r "github.com/pion/dtls/v2" --include="*.go" .; then
  echo -e "${GREEN}Successfully updated all dtls references to v3${NC}"
else
  echo -e "${RED}Some dtls/v2 references remain. Manual inspection needed.${NC}"
fi

echo -e "\n${YELLOW}Dependencies updated. Now run the tests with:${NC}"
echo "./tools/skip-all-tests.sh"
