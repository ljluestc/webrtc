#!/bin/bash
# Script to clean and rebuild the WebRTC project

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Performing a clean build of the project...${NC}"

# Step 1: Clean the cache to start fresh
echo -e "${YELLOW}Cleaning Go cache...${NC}"
go clean -cache -testcache

# Step 2: Check for dependency issues
echo -e "${YELLOW}Checking for dependency issues...${NC}"
go mod verify
if [ $? -ne 0 ]; then
  echo -e "${RED}Module verification failed. Running go mod tidy...${NC}"
  go mod tidy
else
  echo -e "${GREEN}Module verification passed.${NC}"
fi

# Step 3: Build the package without running tests
echo -e "${YELLOW}Building package without tests...${NC}"
go build ./...
if [ $? -eq 0 ]; then
  echo -e "${GREEN}Build successful!${NC}"
else
  echo -e "${RED}Build failed. Running fix-deps.sh script...${NC}"
  ./tools/fix-deps.sh
  echo -e "${YELLOW}Trying build again...${NC}"
  go build ./...
fi

# Step 4: Build individual packages that should work
echo -e "${YELLOW}Building known good packages...${NC}"
GOOD_PACKAGES=(
  "./internal/..."
  "./pkg/..."
)

for pkg in "${GOOD_PACKAGES[@]}"; do
  echo -e "${YELLOW}Building: $pkg${NC}"
  if go build "$pkg"; then
    echo -e "${GREEN}✓ Package $pkg built successfully${NC}"
  else
    echo -e "${RED}✗ Package $pkg build failed${NC}"
  fi
done

echo -e "\n${YELLOW}Build process complete.${NC}"
echo -e "${YELLOW}To run the tests on working packages only:${NC}"
echo "./tools/skip-all-tests.sh"
