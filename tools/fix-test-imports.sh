#!/bin/bash
# This script fixes import conflicts in test files

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Fixing import conflicts in test files...${NC}"

# Find all Go test files
TEST_FILES=$(find . -name "*_test.go")

# Check for dtls/v2 imports and replace them with v3
for file in $TEST_FILES; do
  if grep -q "github.com/pion/dtls/v2" "$file"; then
    echo -e "${YELLOW}Fixing imports in $file${NC}"
    # Replace dtls/v2 with dtls/v3
    sed -i 's/github.com\/pion\/dtls\/v2/github.com\/pion\/dtls\/v3/g' "$file"
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Successfully updated imports in $file${NC}"
    else
      echo -e "${RED}Failed to update imports in $file${NC}"
    fi
  fi
done

# Update Go modules
echo -e "${YELLOW}Updating Go modules...${NC}"
go mod tidy

# Check result
if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully updated Go modules${NC}"
else
  echo -e "${RED}Failed to update Go modules${NC}"
fi

echo -e "${YELLOW}You may now try running the tests with:${NC}"
echo "./tools/skip-dtls-tests.sh"
