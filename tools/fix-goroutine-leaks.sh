#!/bin/bash
# This script helps identify and fix goroutine leaks in tests

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create a temporary file to capture goroutine dumps
DUMP_FILE=$(mktemp)

echo -e "${YELLOW}Running test with GOTRACEBACK=all to get full stack traces...${NC}"

# Run the test with environment variables to help debug goroutine leaks
GOTRACEBACK=all GODEBUG=gctrace=1 go test -timeout 2m -v -run "TestInvalidFingerprintCauses" ./... 2>&1 | tee "$DUMP_FILE"

# Check for common goroutine leak patterns
echo -e "\n${YELLOW}Analyzing goroutine patterns...${NC}"
grep -n "goroutine " "$DUMP_FILE" | head -20

# Count goroutines at the end
GOROUTINE_COUNT=$(grep -c "goroutine " "$DUMP_FILE")
echo -e "\n${YELLOW}Found approximately $GOROUTINE_COUNT goroutine references${NC}"

# Extract common goroutine sources
echo -e "\n${YELLOW}Most common goroutine sources:${NC}"
grep -A 2 "goroutine " "$DUMP_FILE" | grep -v "goroutine " | sort | uniq -c | sort -nr | head -10

# Check for specific patterns that might indicate leaks
echo -e "\n${YELLOW}Checking for specific leak patterns...${NC}"
LEAK_PATTERNS=("time.Sleep" "select {}" "ch := make(chan" "for {" "context.Background()")
for pattern in "${LEAK_PATTERNS[@]}"; do
  COUNT=$(grep -c "$pattern" "$DUMP_FILE")
  if [ "$COUNT" -gt 0 ]; then
    echo -e "${RED}Found $COUNT occurrences of potential leak pattern: $pattern${NC}"
    grep -n -A 2 -B 2 "$pattern" "$DUMP_FILE" | head -5
  fi
done

# Check for timeout panic
if grep -q "panic: timeout" "$DUMP_FILE"; then
  echo -e "\n${RED}Test failed with timeout panic${NC}"
  grep -A 10 "panic: timeout" "$DUMP_FILE"
fi

# Cleanup
rm "$DUMP_FILE"

echo -e "\n${YELLOW}Recommended fixes:${NC}"
echo "1. Ensure all goroutines have a way to terminate"
echo "2. Use context with timeout for all blocking operations"
echo "3. Close all channels before test ends"
echo "4. Add proper cleanup for all resources"
echo "5. Increase test timeout to allow for proper cleanup"
echo -e "\n${YELLOW}Run the following to try the improved test:${NC}"
echo "./tools/test-problematic.sh"
