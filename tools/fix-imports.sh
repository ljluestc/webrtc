#!/bin/bash
# Script to fix import issues across the codebase

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Fixing import issues across the codebase...${NC}"

# Make sure we're in the right directory
cd "$(dirname "$0")/.." || { echo "Failed to change directory"; exit 1; }

# Step 1: Fix v3 rtcerr imports
echo -e "${YELLOW}Fixing v3 rtcerr imports...${NC}"
find . -name "*.go" -type f -exec grep -l "github.com/pion/webrtc/v3/pkg/rtcerr" {} \; | while read -r file; do
  echo -e "${YELLOW}Fixing imports in $file${NC}"
  sed -i 's|github.com/pion/webrtc/v3/pkg/rtcerr|github.com/pion/webrtc/v4/pkg/rtcerr|g' "$file"
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully fixed imports in $file${NC}"
  else
    echo -e "${RED}Failed to fix imports in $file${NC}"
  fi
done

# Step 2: Fix circular imports
echo -e "${YELLOW}Fixing circular imports...${NC}"
find . -name "*.go" -type f -exec grep -l "package webrtc" {} \; | while read -r file; do
  if grep -q "github.com/pion/webrtc/v4" "$file"; then
    echo -e "${YELLOW}Fixing circular import in $file${NC}"
    sed -i '/github.com\/pion\/webrtc\/v4/d' "$file"
    
    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Successfully fixed circular import in $file${NC}"
    else
      echo -e "${RED}Failed to fix circular import in $file${NC}"
    fi
  fi
done

# Step 3: Fix package conflicts
echo -e "${YELLOW}Fixing package conflicts...${NC}"
if [ -f "test-package-main.go" ]; then
  echo -e "${YELLOW}Updating test-package-main.go${NC}"
  sed -i 's/package main/package examples/g' test-package-main.go
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully updated test-package-main.go${NC}"
  else
    echo -e "${RED}Failed to update test-package-main.go${NC}"
  fi
fi

# Step 4: Create examples directory if needed
echo -e "${YELLOW}Setting up examples directory...${NC}"
if [ ! -d "examples" ]; then
  mkdir -p examples
  echo -e "${GREEN}Created examples directory${NC}"
  
  # Create a base examples package file
  cat > "examples/examples.go" << 'EOF'
// SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
// SPDX-License-Identifier: MIT

// Package examples contains example code for the Pion WebRTC library
package examples

import (
	"fmt"
)

// ListExamples prints information about available examples
func ListExamples() {
	fmt.Println("WebRTC Examples:")
	fmt.Println("- data-channels: WebRTC data channels example")
	fmt.Println("- rtp-forwarder: Forward RTP packets")
	fmt.Println("- save-to-disk: Save media to disk")
	fmt.Println("- simulcast: WebRTC simulcast example")
	fmt.Println("- ... and more in the examples directory")
}

// RunExample is a placeholder for running examples
func RunExample(name string) error {
	fmt.Printf("Running example: %s\n", name)
	fmt.Println("This is just a placeholder. Real examples should be run from their respective directories.")
	return nil
}
EOF

  echo -e "${GREEN}Created examples package${NC}"
fi

echo -e "\n${GREEN}Import issues fixed!${NC}"
echo -e "${YELLOW}To verify the fixes, try building:${NC}"
echo "go build ./pkg/... ./internal/..."
