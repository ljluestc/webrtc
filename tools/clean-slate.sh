#!/bin/bash
# Script to start with a clean slate

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting with a clean slate...${NC}"

# Make sure we're in the right directory
cd "$(dirname "$0")/.." || { echo "Failed to change directory"; exit 1; }

# Step 1: Backup important files
echo -e "${YELLOW}Step 1: Backing up important files...${NC}"
mkdir -p backup
cp -f go.mod backup/go.mod.bak 2>/dev/null || true
cp -f go.sum backup/go.sum.bak 2>/dev/null || true
cp -f track_remote.go backup/track_remote.go.bak 2>/dev/null || true
cp -f mdns_workaround.go backup/mdns_workaround.go.bak 2>/dev/null || true
echo -e "${GREEN}Backup created in ./backup directory${NC}"

# Step 2: Clean go.mod and go.sum
echo -e "${YELLOW}Step 2: Cleaning up dependency files...${NC}"
rm -f go.mod go.sum
echo -e "${GREEN}Removed go.mod and go.sum${NC}"

# Step 3: Initialize a new module
echo -e "${YELLOW}Step 3: Initializing a new module...${NC}"
go mod init github.com/pion/webrtc/v4
echo -e "${GREEN}Created new go.mod file${NC}"

# Step 4: Create rtcerr package
echo -e "${YELLOW}Step 4: Creating rtcerr package...${NC}"
mkdir -p pkg/rtcerr

cat > pkg/rtcerr/errors.go << 'EOF'
// SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
// SPDX-License-Identifier: MIT

// Package rtcerr contains WebRTC-specific errors
package rtcerr

import "errors"

// Common error types defined by the WebRTC spec
var (
	// ErrInvalidModification indicates an invalid modification was attempted
	ErrInvalidModification = errors.New("invalid modification")

	// ErrInvalidState indicates an operation was attempted in an invalid state
	ErrInvalidState = errors.New("invalid state")

	// ErrInvalidParameter indicates that a parameter was invalid
	ErrInvalidParameter = errors.New("invalid parameter")

	// ErrUnsupportedOperation indicates that an operation is not supported
	ErrUnsupportedOperation = errors.New("unsupported operation")

	// ErrOperationError indicates an operation failed for an unknown reason
	ErrOperationError = errors.New("operation error")
)
EOF

echo -e "${GREEN}Created rtcerr package${NC}"

# Step 5: Set up examples directory
echo -e "${YELLOW}Step 5: Setting up examples directory...${NC}"
mkdir -p examples

cat > examples/examples.go << 'EOF'
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
}
EOF

echo -e "${GREEN}Created examples package${NC}"

# Step 6: Add basic dependencies
echo -e "${YELLOW}Step 6: Adding basic dependencies...${NC}"
go get github.com/pion/dtls/v2
go get github.com/pion/interceptor
go get github.com/pion/logging
go get github.com/pion/rtp
go get github.com/pion/webrtc/v3

echo -e "${GREEN}Added basic dependencies${NC}"

# Step 7: Run go mod tidy
echo -e "${YELLOW}Step 7: Running go mod tidy...${NC}"
go mod tidy
echo -e "${GREEN}Dependencies tidied${NC}"

echo -e "\n${GREEN}Clean slate ready!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Run ./tools/complete-fix.sh to apply all fixes"
echo "2. Test with: go test ./pkg/..."
echo "3. Original files were backed up to ./backup directory"
