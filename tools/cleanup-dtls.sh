#!/bin/bash
# This script cleans up DTLS conflicts in the WebRTC project

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Cleaning up DTLS conflicts...${NC}"

# Step 1: Find files with dtls references
echo -e "${YELLOW}Finding files with DTLS references...${NC}"
DTLS_FILES=$(grep -l "github.com/pion/dtls" --include="*.go" . || echo "")

if [ -z "$DTLS_FILES" ]; then
  echo -e "${GREEN}No DTLS references found.${NC}"
else
  echo -e "${YELLOW}Found files with DTLS references:${NC}"
  echo "$DTLS_FILES"

  # Step 2: Check for version conflicts
  echo -e "${YELLOW}Checking for version conflicts...${NC}"
  V2_FILES=$(grep -l "github.com/pion/dtls/v2" --include="*.go" . || echo "")
  V3_FILES=$(grep -l "github.com/pion/dtls/v3" --include="*.go" . || echo "")

  if [ -n "$V2_FILES" ] && [ -n "$V3_FILES" ]; then
    echo -e "${RED}Found mixed DTLS versions!${NC}"
    echo -e "${YELLOW}Files with v2:${NC}"
    echo "$V2_FILES"
    echo -e "${YELLOW}Files with v3:${NC}"
    echo "$V3_FILES"

    echo -e "${YELLOW}Would you like to convert all to v2? (y/n)${NC}"
    read -r CONVERT
    if [ "$CONVERT" = "y" ]; then
      echo -e "${YELLOW}Converting v3 to v2...${NC}"
      find . -name "*.go" -type f -exec sed -i 's|github.com/pion/dtls/v3|github.com/pion/dtls/v2|g' {} \;
      echo -e "${GREEN}Conversion complete!${NC}"
    fi
  elif [ -n "$V2_FILES" ]; then
    echo -e "${GREEN}All files use dtls/v2 consistently.${NC}"
  elif [ -n "$V3_FILES" ]; then
    echo -e "${GREEN}All files use dtls/v3 consistently.${NC}"
  fi
fi

echo -e "\n${GREEN}DTLS cleanup complete!${NC}"
echo -e "${YELLOW}Now run:${NC}"
echo "./tools/update-deps.sh"
