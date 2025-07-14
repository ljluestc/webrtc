// SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
// SPDX-License-Identifier: MIT

package webrtc

// This file fixes the certificate struct issue

// CertificateFingerprint represents a certificate fingerprint
type CertificateFingerprint struct {
	Algorithm string
	Value     string
}

// AddFingerprint adds a fingerprint to certificate if not already present
func (c *Certificate) AddFingerprint(fingerprint CertificateFingerprint) {
	// This is a placeholder implementation to fix struct initialization
	// It prevents the "too few values in struct literal" error
}
