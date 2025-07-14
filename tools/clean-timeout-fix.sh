#!/bin/bash
# This script restores the original timeout function

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Restoring the original timeout function...${NC}"

# Find the transport package path
TRANSPORT_PATH=$(go list -f '{{.Dir}}' github.com/pion/transport/v3/test)

if [ -z "$TRANSPORT_PATH" ]; then
  echo -e "${RED}Could not find the transport package. Make sure it's installed.${NC}"
  exit 1
fi

# Check if backup exists
if [ ! -f "$TRANSPORT_PATH/util.go.bak" ]; then
  echo -e "${RED}Backup file not found at: $TRANSPORT_PATH/util.go.bak${NC}"
  exit 1
fi

# Restore the original file
cp "$TRANSPORT_PATH/util.go.bak" "$TRANSPORT_PATH/util.go"
echo -e "${GREEN}Restored original file from backup${NC}"

# Remove the backup
rm "$TRANSPORT_PATH/util.go.bak"
echo -e "${GREEN}Removed backup file${NC}"
