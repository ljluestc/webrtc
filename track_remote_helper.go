package webrtc

import (
	"log"
	"sync"
	"time"

	"github.com/pion/interceptor"
	"github.com/pion/rtp"
)

// TrackRemote represents a single inbound source of media.
type TrackRemote struct {
	mu sync.RWMutex

	id       string
	streamID string
