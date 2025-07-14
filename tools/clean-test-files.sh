#!/bin/bash
# Script to clean up duplicate test files

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Cleaning up duplicate test files...${NC}"

# List of duplicate test files to remove
DUPLICATE_FILES=(
  "skip_tests.go"
  "skip_problematic_test.go"
)

# Remove the files if they exist
for file in "${DUPLICATE_FILES[@]}"; do
  if [ -f "$file" ]; then
    echo -e "${YELLOW}Removing $file...${NC}"
    rm "$file"
    echo -e "${GREEN}Removed $file${NC}"
  else
    echo -e "${YELLOW}File $file does not exist, skipping.${NC}"
  fi
done

echo -e "${GREEN}Clean up complete!${NC}"
echo -e "${YELLOW}Now try running tests with:${NC}"
echo "go test ./internal/... ./pkg/..."
