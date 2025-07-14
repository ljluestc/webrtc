// SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
// SPDX-License-Identifier: MIT

package webrtc

import (
	"fmt"
	"os"
	"runtime/pprof"
	"testing"
	"time"
)

// SafeTimeout creates a timeout that doesn't panic but marks the test as failed
// This is a safer alternative to the TimeOut function in the transport package
func SafeTimeout(t testing.TB, duration time.Duration) *time.Timer {
	return time.AfterFunc(duration, func() {
		// Log goroutine information
		fmt.Println("=== TEST TAKING TOO LONG - DUMPING GOROUTINES ===")
		
		if err := pprof.Lookup("goroutine").WriteTo(os.Stdout, 1); err != nil {
			fmt.Printf("Failed to print goroutines: %v\n", err)
		}
		
		// Mark the test as failed but don't panic
		t.Errorf("Test timed out after %v", duration)
	})
}

// SkipFlakyTest skips a test if it's known to be flaky
func SkipFlakyTest(t testing.TB) {
	t.Helper()
	
	// Check environment variable
	if os.Getenv("SKIP_FLAKY_TESTS") == "true" {
		t.Skip("Skipping flaky test")
	}
}
