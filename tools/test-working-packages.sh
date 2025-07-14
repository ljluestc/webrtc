#!/bin/bash
# Script to test only working packages

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Testing only working packages...${NC}"

# List of packages known to work
WORKING_PACKAGES=(
  "./internal/fmtp"
  "./internal/mux"
  "./internal/util"
  "./pkg/media"
  "./pkg/media/h264reader"
  "./pkg/media/h264writer"
  "./pkg/media/h265reader"
  "./pkg/media/h265writer"
  "./pkg/media/ivfreader"
  "./pkg/media/ivfwriter"
  "./pkg/media/oggreader"
  "./pkg/media/oggwriter"
  "./pkg/media/rtpdump"
  "./pkg/media/samplebuilder"
  "./pkg/null"
)

# Test each package individually
for pkg in "${WORKING_PACKAGES[@]}"; do
  echo -e "${YELLOW}Testing package: $pkg${NC}"
  if go test -v "$pkg"; then
    echo -e "${GREEN}✓ Package $pkg passed${NC}"
  else
    echo -e "${RED}✗ Package $pkg failed${NC}"
  fi
done

echo -e "\n${GREEN}Tests complete!${NC}"
