#!/bin/bash
# This script fixes build issues in the WebRTC package

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Fixing WebRTC build issues...${NC}"

# Make sure we're in the right directory
cd "$(dirname "$0")/.." || { echo "Failed to change directory"; exit 1; }

# Fix 1: Rename the testing function in mdns_workaround.go to avoid conflict
echo -e "${YELLOW}Fixing mdns_workaround.go...${NC}"
sed -i 's/func testing() bool/func isTestingMode() bool/g' mdns_workaround.go
sed -i 's/|| testing()/|| isTestingMode()/g' mdns_workaround.go

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully fixed mdns_workaround.go${NC}"
else
  echo -e "${RED}Failed to fix mdns_workaround.go${NC}"
  exit 1
fi

# Fix 2: Fix variable names in track_remote.go
echo -e "${YELLOW}Fixing track_remote.go...${NC}"

# Fix attributes variable naming to be consistent
sed -i 's/attributes := t.peekedAttributes/peekedAttrs := t.peekedAttributes/g' track_remote.go
sed -i 's/return n, attributes, err/return n, peekedAttrs, err/g' track_remote.go

# Change function parameter names to be consistent
sed -i 's/(n int, a interceptor.Attributes, err error)/(n int, attrs interceptor.Attributes, err error)/g' track_remote.go
sed -i 's/a = rtxPacketReceived.attributes/attrs = rtxPacketReceived.attributes/g' track_remote.go
sed -i 's/n, a, err = receiver.readRTP/n, attrs, err = receiver.readRTP/g' track_remote.go
sed -i 's/return n, a, err/return n, attrs, err/g' track_remote.go

# Fix peek function
sed -i 's/peek(b []byte) (n int, a interceptor.Attributes, err error)/peek(b []byte) (n int, attrs interceptor.Attributes, err error)/g' track_remote.go
sed -i 's/n, a, err = t.Read(b)/n, attrs, err = t.Read(b)/g' track_remote.go
sed -i 's/t.peekedAttributes = a/t.peekedAttributes = attrs/g' track_remote.go

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully fixed track_remote.go${NC}"
else
  echo -e "${RED}Failed to fix track_remote.go${NC}"
  exit 1
fi

echo -e "${YELLOW}Running go build to verify fixes...${NC}"
go build ./...

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Build successful! All issues fixed.${NC}"
else
  echo -e "${RED}Build failed. Some issues remain:${NC}"
  go build ./... 2>&1 | grep -E "error:"
  exit 1
fi

echo -e "\n${YELLOW}You can now run tests with:${NC}"
echo "go test ./..."
