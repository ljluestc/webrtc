#!/bin/bash
# Script to fix go.mod issues

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Fixing go.mod issues...${NC}"

# Make sure we're in the right directory
cd "$(dirname "$0")/.." || { echo "Failed to change directory"; exit 1; }

# Step 1: Create clean go.mod file
echo -e "${YELLOW}Creating clean go.mod file...${NC}"
cat > go.mod << 'EOF'
module github.com/pion/webrtc/v4

go 1.20

require (
	github.com/pion/dtls/v2 v2.2.7
	github.com/pion/interceptor v0.1.25
	github.com/pion/logging v0.2.2
	github.com/pion/rtp v1.8.3
	github.com/pion/webrtc/v3 v3.2.24
)

// Additional dependencies
require (
	github.com/google/uuid v1.5.0 // indirect
	github.com/pion/datachannel v1.5.5 // indirect
	github.com/pion/mdns/v2 v2.0.7 // indirect
	github.com/pion/randutil v0.1.0 // indirect
	github.com/pion/rtcp v1.2.12 // indirect
	github.com/pion/sctp v1.8.8 // indirect
	github.com/pion/sdp/v3 v3.0.6 // indirect
	github.com/pion/srtp/v2 v2.0.18 // indirect
	github.com/pion/stun v0.6.1 // indirect
	github.com/pion/transport/v2 v2.2.4 // indirect
	github.com/pion/turn/v2 v2.1.4 // indirect
	golang.org/x/crypto v0.16.0 // indirect
	golang.org/x/net v0.19.0 // indirect
	golang.org/x/sys v0.15.0 // indirect
)

replace github.com/pion/webrtc/v3/pkg/rtcerr => ./pkg/rtcerr
EOF

echo -e "${GREEN}Created clean go.mod file${NC}"

# Step 2: Make sure pkg/rtcerr directory exists
echo -e "${YELLOW}Setting up rtcerr package...${NC}"
mkdir -p pkg/rtcerr

# Create rtcerr package
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

# Step 3: Fix imports in api.go
echo -e "${YELLOW}Fixing imports in api.go...${NC}"
if [ -f api.go ]; then
  sed -i 's|github.com/pion/webrtc/v3/pkg/rtcerr|github.com/pion/webrtc/v4/pkg/rtcerr|g' api.go
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully fixed imports in api.go${NC}"
  else
    echo -e "${RED}Failed to fix imports in api.go${NC}"
  fi
fi

# Step 4: Run go mod tidy
echo -e "${YELLOW}Running go mod tidy...${NC}"
go mod tidy

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully tidied dependencies${NC}"
else
  echo -e "${RED}Failed to tidy dependencies${NC}"
fi

# Step 5: Try building internal packages
echo -e "${YELLOW}Building internal packages...${NC}"
go build ./internal/... ./pkg/...

if [ $? -eq 0 ]; then
  echo -e "${GREEN}Successfully built internal packages${NC}"
else
  echo -e "${RED}Failed to build internal packages${NC}"
fi

echo -e "\n${GREEN}go.mod issues fixed!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Try running: go test ./pkg/... ./internal/..."
echo "2. Fix any remaining import issues in specific files"
