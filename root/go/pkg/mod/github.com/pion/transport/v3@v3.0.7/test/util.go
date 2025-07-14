// SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
// SPDX-License-Identifier: MIT

// Package test provides test helpers used throughout pion/transport
package test

import (
	"fmt"
	"runtime"
	"runtime/pprof"
	"strings"
	"sync"
	"testing"
	"time"
)

// TimeOut is used to panic if a test takes to long.
// It will print the current goroutines and panic.
// It is meant as a debugging tool to help find hanging tests.
func TimeOut(duration time.Duration) *time.Timer {
	return time.AfterFunc(duration, func() {
		if err := pprof.Lookup("goroutine").WriteTo(fmt.Stdout, 1); err != nil {
			panic(err)
		}
		panic("timeout")
	})
}

// CheckRoutines is used to check for leaked go-routines
func CheckRoutines(t testing.TB) func() {
	initialGoRoutines := len(getRoutines())
	return func() {
		for i := 0; i < 20; i++ {
			goRoutineDelta := len(getRoutines()) - initialGoRoutines
			if goRoutineDelta <= 0 {
				break
			}
			time.Sleep(200 * time.Millisecond)
		}

		tryCheckRoutinesLoop(t, initialGoRoutines)
	}
}

func tryCheckRoutinesLoop(t testing.TB, initialGoRoutines int) {
	// Give some time for go-routines to cleanup
	loop := 20
	for i := 0; i < loop; i++ {
		routines := getRoutines()
		goRoutineDelta := len(routines) - initialGoRoutines
		t.Logf("goRoutine delta: %d", goRoutineDelta)
		if goRoutineDelta <= 0 {
			return
		}

		// Uncomment for debugging
		// for _, routine := range routines {
		// 	t.Logf("%s", routine)
		// }

		// Last run should try and fix the leaked routine
		if i == (loop - 1) {
			t.Fatalf("Unexpected routines, delta: %d", goRoutineDelta)
		}
		time.Sleep(500 * time.Millisecond)
	}
}

func getRoutines() []string {
	buf := make([]byte, 2<<20)
	buf = buf[:runtime.Stack(buf, true)]
	return filterRoutines(strings.Split(string(buf), "\n\n"))
}

func filterRoutines(routines []string) []string {
	result := []string{}
	for _, stack := range routines {
		if !strings.Contains(stack, "testing.Main(") &&
			!strings.Contains(stack, "testing.(*T).Run(") &&
			!strings.Contains(stack, "testing.(*M).Run(") {
			result = append(result, stack)
		}
	}
	return result
}

// GatherErrs gathers all errors returned by a channel.
// It needs to be used with a canceled context, otherwise, it will wait forever.
func GatherErrs(c chan error) []error {
	var errs []error
	for err := range c {
		errs = append(errs, err)
	}
	return errs
}

// MustGatherErrs expects all errors to happen before the timeout.
func MustGatherErrs(t testing.TB, c chan error, timeout time.Duration) []error {
	timer := time.NewTimer(timeout)
	var errs []error
	for {
		select {
		case err, ok := <-c:
			if !ok {
				return errs
			}
			errs = append(errs, err)
		case <-timer.C:
			t.Fatalf("Timeout waiting for errors, after %v", timeout)
			return nil
		}
	}
}

// Wait waits for delta from wg.
func Wait(wg *sync.WaitGroup, delta int, timeout time.Duration) error {
	done := make(chan struct{})
	go func() {
		wg.Wait()
		close(done)
	}()
	timer := time.NewTimer(timeout)
	select {
	case <-done:
		return nil
	case <-timer.C:
		return fmt.Errorf("Wait timed out after %v", timeout)
	}
}
