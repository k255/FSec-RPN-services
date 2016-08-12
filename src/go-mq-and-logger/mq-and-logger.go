package main

import (
	"github.com/nsqio/nsq/nsqd"
)

func main() {
	done := make(chan bool)

	go func() {
		opts := nsqd.NewOptions()
		nsqd := nsqd.New(opts)
		nsqd.Main()
	}()

	done <- true
}
