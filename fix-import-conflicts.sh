#!/bin/bash
# This script fixes import conflicts in Go files

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Fixing import conflicts in Go files...${NC}"

# Fix mdns_workaround.go - rename "testing" variable to "testDNS"
echo -e "${YELLOW}Fixing mdns_workaround.go...${NC}"
sed -i 's/testing := "8.8.8.8:80"/testDNS := "8.8.8.8:80"/' mdns_workaround.go
sed -i 's/conn, err := net.Dial("udp", testing)/conn, err := net.Dial("udp", testDNS)/' mdns_workaround.go

# Fix duplicate testing imports in test files
echo -e "${YELLOW}Fixing duplicate testing imports...${NC}"

# peerconnection_media_test_fix.go
if grep -q '"testing"' peerconnection_media_test_fix.go; then
  sed -i 's/"testing"/"testing" \/\/ global import/g' peerconnection_media_test_fix.go
  echo -e "${GREEN}Fixed peerconnection_media_test_fix.go${NC}"
fi

# skip_tests.go
if [ -f skip_tests.go ] && grep -q '"testing"' skip_tests.go; then
  sed -i 's/import (\n\t"testing"\n)/import (\n\t\/\/ use global testing import\n)/g' skip_tests.go
  echo -e "${GREEN}Fixed skip_tests.go${NC}"
fi

# test_util_override.go
if [ -f test_util_override.go ] && grep -q '"testing"' test_util_override.go; then
  sed -i 's/import (\n\t"testing"\n)/import (\n\t\/\/ use global testing import\n)/g' test_util_override.go
  echo -e "${GREEN}Fixed test_util_override.go${NC}"
fi

# testhelper.go
if [ -f testhelper.go ] && grep -q '"testing"' testhelper.go; then
  sed -i 's/import (\n\t"testing"\n)/import (\n\t\/\/ use global testing import\n)/g' testhelper.go
  echo -e "${GREEN}Fixed testhelper.go${NC}"
fi

# Fix track_remote.go - fix return values mismatch
echo -e "${YELLOW}Fixing track_remote.go...${NC}"
sed -i 's/return i, n, err/return n, err/g' track_remote.go
sed -i 's/attributes :=/attrs :=/g' track_remote.go
sed -i 's/attributes == nil/attrs == nil/g' track_remote.go

echo -e "${GREEN}All import conflicts fixed!${NC}"
echo -e "${YELLOW}Now try building or running tests:${NC}"
echo "go build ./..."
echo "go test ./..."
