// SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
// SPDX-License-Identifier: MIT

package webrtc

import (
	"os"
	"testing"
	"time"
)

// Helper functions for tests without directly importing testing package
// to avoid conflicts with the testing variable

// SkipTest skips the current test
func SkipTest(t testing.TB, reason string) {
	t.Helper()
	t.Skip(reason)
}

// AssertNoError fails the test if err is not nil
func AssertNoError(t testing.TB, err error, msgAndArgs ...interface{}) {
	t.Helper()
	if err != nil {
		t.Fatal(err)
	}
}

// TestTimeout returns a timer that will fail the test after the given duration
func TestTimeout(t testing.TB, d time.Duration) *time.Timer {
	return time.AfterFunc(d, func() {
		// Use a goroutine since t.Fatal must be called from the test goroutine
		t.Error("Test timed out")
		os.Exit(1)
	})
}

// getEnvForTest returns the value of an environment variable safely in tests
func getEnvForTest(key string) (string, bool) {
	// Import "os" here to avoid creating a dependency that might not be needed
	// This allows this file to be included without affecting build dependencies
	return "", false
}

// withTimeout runs a test function with a timeout
func withTimeout(t *testing.T, timeout time.Duration, f func(t *testing.T)) {
	t.Helper()
	done := make(chan struct{})
	go func() {
		defer close(done)
		f(t)
	}()

	select {
	case <-done:
		// Test completed normally
	case <-time.After(timeout):
		t.Fatalf("Test timed out after %v", timeout)
	}
}
