// SPDX-FileCopyrightText: 2023 The Pion community <https://pion.ly>
// SPDX-License-Identifier: MIT

// This file demonstrates correct imports for the webrtc package

package examples

import (
	"fmt"
	"log"

	"github.com/pion/webrtc/v4"
)

func main() {
	// Create a new RTCPeerConnection
	peerConnection, err := webrtc.NewPeerConnection(webrtc.Configuration{
		ICEServers: []webrtc.ICEServer{
			{
				URLs: []string{"stun:stun.l.google.com:19302"},
			},
		},
	})
	if err != nil {
		log.Fatal(err)
	}

	// When the program is done, close the connection
	defer func() {
		if err := peerConnection.Close(); err != nil {
			log.Fatal(err)
		}
	}()

	// Example of creating a data channel
	dataChannel, err := peerConnection.CreateDataChannel("test-channel", nil)
	if err != nil {
		log.Fatal(err)
	}

	// Set data channel handlers
	dataChannel.OnOpen(func() {
		fmt.Println("Data channel is open")
	})

	dataChannel.OnMessage(func(msg webrtc.DataChannelMessage) {
		fmt.Printf("Message from DataChannel: %s\n", string(msg.Data))
	})

	fmt.Println("WebRTC peer connection created successfully")
}
