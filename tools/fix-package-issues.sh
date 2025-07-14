#!/bin/bash
# Script to fix package conflicts and dependency issues

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Fixing package conflicts and dependencies...${NC}"

# Make sure we're in the right directory
cd "$(dirname "$0")/.." || { echo "Failed to change directory"; exit 1; }

# Fix 1: Rename package in test-package-main.go
echo -e "${YELLOW}Fixing test-package-main.go...${NC}"
if [ -f "test-package-main.go" ]; then
  sed -i 's/package main/package examples/g' test-package-main.go
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully fixed test-package-main.go${NC}"
  else
    echo -e "${RED}Failed to fix test-package-main.go${NC}"
  fi
fi

# Fix 2: Remove circular imports
echo -e "${YELLOW}Fixing circular imports...${NC}"
# Find all Go files that import github.com/pion/webrtc/v4 and are in the webrtc package
CIRCULAR_IMPORT_FILES=$(grep -l "github.com/pion/webrtc/v4" $(grep -l "package webrtc" *.go))

if [ -n "$CIRCULAR_IMPORT_FILES" ]; then
  for file in $CIRCULAR_IMPORT_FILES; do
    echo -e "${YELLOW}Removing circular import in $file${NC}"
    sed -i '/github.com\/pion\/webrtc\/v4/d' "$file"
    
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Successfully removed circular import in $file${NC}"
    else
      echo -e "${RED}Failed to remove circular import in $file${NC}"
    fi
  done
fi

# Fix 3: Add v3 dependency
echo -e "${YELLOW}Adding v3 dependency...${NC}"
if [ ! -f "go.mod" ]; then
  echo -e "${RED}go.mod not found!${NC}"
  echo "Creating go.mod file..."
  go mod init github.com/pion/webrtc/v4
fi

# Add webrtc v3 dependency
go get github.com/pion/webrtc/v3

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully added webrtc/v3 dependency${NC}"
else
  echo -e "${RED}Failed to add webrtc/v3 dependency${NC}"
fi

# Fix 4: Tidy up dependencies
echo -e "${YELLOW}Running go mod tidy...${NC}"
go mod tidy

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully tidied dependencies${NC}"
else
  echo -e "${RED}Failed to tidy dependencies${NC}"
fi

# Fix 5: Try building working packages
echo -e "${YELLOW}Building internal packages...${NC}"
go build ./internal/...

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully built internal packages${NC}"
else
  echo -e "${RED}Failed to build internal packages${NC}"
fi

echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Try building: go build ./pkg/..."
echo "2. Try running: go test ./internal/..."
echo "3. If specific examples fail, edit their imports as needed"
