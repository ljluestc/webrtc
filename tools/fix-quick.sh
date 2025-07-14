#!/bin/bash
# Quick fix script for WebRTC test issues

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Applying quick fix for test issues...${NC}"

# Step 1: Clean up duplicate test files
echo -e "${YELLOW}Step 1: Cleaning up duplicate test files...${NC}"
for file in skip_tests.go skip_problematic_test.go; do
  if [ -f "$file" ]; then
    rm "$file"
    echo -e "${GREEN}Removed $file${NC}"
  fi
done

# Step 2: Verify dtlstransport_test.go
echo -e "${YELLOW}Step 2: Verifying dtlstransport_test.go...${NC}"
if [ -f "dtlstransport_test.go" ]; then
  echo -e "${GREEN}dtlstransport_test.go exists${NC}"
else
  echo -e "${RED}dtlstransport_test.go not found!${NC}"
  exit 1
fi

# Step 3: Verify tests can build
echo -e "${YELLOW}Step 3: Verifying tests can build...${NC}"
if go test -c ./internal/fmtp; then
  echo -e "${GREEN}Test build successful!${NC}"
  rm -f fmtp.test
else
  echo -e "${RED}Test build failed${NC}"
  exit 1
fi

# Step 4: Run tests on working packages
echo -e "${YELLOW}Step 4: Running tests on internal packages...${NC}"
go test ./internal/...

echo -e "\n${GREEN}Quick fix complete!${NC}"
echo -e "${YELLOW}To run all working tests, use:${NC}"
echo "./tools/test-working-packages.sh"
