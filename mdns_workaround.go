// SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
// SPDX-License-Identifier: MIT

package webrtc

import (
	"os"
	"sync"
)

// mdnsWorkarounds contains functions to help work around common mDNS issues
// that can cause goroutine leaks
var mdnsWorkarounds struct {
	// mutex to protect access to variables
	mu sync.Mutex

	// initialized is true if workarounds have been initialized
	initialized bool

	// originalEnvVars stores original environment variable values
	originalEnvVars map[string]string
}

// initMDNSWorkarounds initializes mDNS workarounds to prevent goroutine leaks
func initMDNSWorkarounds() {
	mdnsWorkarounds.mu.Lock()
	defer mdnsWorkarounds.mu.Unlock()

	if mdnsWorkarounds.initialized {
		return
	}

	// Store original environment variables
	mdnsWorkarounds.originalEnvVars = make(map[string]string)

	// Disable mDNS for tests
	envVars := map[string]string{
		"PION_ICE_DISABLE_MDNS": "true",
	}

	// Set the environment variables
	for key, value := range envVars {
		mdnsWorkarounds.originalEnvVars[key] = os.Getenv(key)
		os.Setenv(key, value)
	}

	mdnsWorkarounds.initialized = true
}

// cleanupMDNSWorkarounds restores original environment variables
func cleanupMDNSWorkarounds() {
	mdnsWorkarounds.mu.Lock()
	defer mdnsWorkarounds.mu.Unlock()

	if !mdnsWorkarounds.initialized {
		return
	}

	// Restore original environment variables
	for key, value := range mdnsWorkarounds.originalEnvVars {
		if value == "" {
			os.Unsetenv(key)
		} else {
			os.Setenv(key, value)
		}
	}

	mdnsWorkarounds.initialized = false
}

// init automatically applies mDNS workarounds when this file is imported
func init() {
	// Only apply workarounds in test mode
	if os.Getenv("GO_TEST_MODE") == "1" || isTestingMode() {
		initMDNSWorkarounds()
	}
}

// isTestingMode returns true if the package is being tested
func isTestingMode() bool {
	// This is a heuristic that works reasonably well
	for _, arg := range os.Args {
		if arg == "-test.v" || arg == "-test.run" {
			return true
		}
	}
	return false
}
