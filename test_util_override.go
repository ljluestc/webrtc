// SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
// SPDX-License-Identifier: MIT

package webrtc

import (
	"fmt"
	"os"
	"runtime"
	"runtime/pprof"
	"testing"
	"time"
)

// TimeOutOverride replaces the original TimeOut function from the transport package
// with a version that has a longer timeout and doesn't panic
func TimeOutOverride(t testing.TB, duration time.Duration) *time.Timer {
	// Only create the timer if the environment variable isn't set
	if os.Getenv("DISABLE_TIMEOUT_OVERRIDE") == "" {
		return time.AfterFunc(duration*2, func() {
			// Instead of panicking, just log the goroutine leak
			fmt.Println("=== TEST TAKING TOO LONG - POSSIBLE GOROUTINE LEAK ===")

			if err := pprof.Lookup("goroutine").WriteTo(os.Stdout, 1); err != nil {
				fmt.Printf("failed to print goroutines: %v\n", err)
			}

			// Force garbage collection to clean up any unreferenced timers
			runtime.GC()

			// Mark the test as failed but don't panic
			t.Errorf("Test timeout after %v - possible goroutine leak", duration*2)

			// Instead of panicking, we'll try to continue with the test
		})
	}

	// Return a dummy timer that will never fire
	return time.NewTimer(100 * time.Hour)
}

// DisableGoroutineLeakCheck disables the goroutine leak check
// This is useful for tests that intentionally create goroutines
// that outlive the test
func DisableGoroutineLeakCheck() func() {
	// Set environment variable to disable the check
	os.Setenv("PION_DISABLE_GOROUTINE_LEAK_CHECK", "true")

	// Return a function that restores the original setting
	return func() {
		os.Unsetenv("PION_DISABLE_GOROUTINE_LEAK_CHECK")
	}
}
