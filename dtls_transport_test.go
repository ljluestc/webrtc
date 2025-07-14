// SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
// SPDX-License-Identifier: MIT

//go:build !js
// +build !js

package webrtc

import (
	"testing"
)

// This test is skipped because it requires github.com/pion/dtls/v2
// To run the real tests, install the dependency with: go get github.com/pion/dtls/v2
func TestInvalidFingerprintCausesFailedSimple_SkipDTLS(t *testing.T) {
	t.Skip("Skipping test that requires github.com/pion/dtls/v2")
}
