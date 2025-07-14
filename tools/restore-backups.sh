#!/bin/bash
# Script to restore backup files after quick fix

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Restoring backup files...${NC}"

# Remove temporary files
if [ -f "dtls_test.go" ]; then
  echo -e "${YELLOW}Removing dtls_test.go${NC}"
  rm "dtls_test.go"
fi

# Restore backups if they exist
for file in *.bak; do
  if [ -f "$file" ]; then
    original_name="${file%.bak}"
    echo -e "${YELLOW}Restoring $file to $original_name${NC}"
    mv "$file" "$original_name"
  fi
done

echo -e "${GREEN}Backup files restored!${NC}"
