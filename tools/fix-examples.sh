#!/bin/bash
# Script to fix WebRTC examples

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Fixing WebRTC examples...${NC}"

# Make sure we're in the right directory
cd "$(dirname "$0")/.." || { echo "Failed to change directory"; exit 1; }

# Create examples directory if it doesn't exist
if [ ! -d "examples" ]; then
  mkdir -p examples
  echo -e "${GREEN}Created examples directory${NC}"
fi

# Create a simple README.md in examples directory
echo -e "${YELLOW}Creating README.md in examples directory...${NC}"
cat > "examples/README.md" << 'EOF'
# WebRTC Examples

This directory contains examples for using the Pion WebRTC library.

## Structure

Each subdirectory contains a standalone example that demonstrates a specific feature.

## Running Examples

To run an example, navigate to its directory and run:
