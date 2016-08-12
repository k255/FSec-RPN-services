package main

import (
	"github.com/nsqio/nsq/nsqd"
	"github.com/nsqio/go-nsq"
	"github.com/nsqio/nsq/nsqadmin"
	"os"
	"log"
)

const LOGGER_PATH = "/tmp/fsec.log"

func main() {
	done := make(chan bool)

	go func() {
		opts := nsqd.NewOptions()
		nsqd := nsqd.New(opts)
		nsqd.Main()

		nsqadminOpts := nsqadmin.NewOptions()
		nsqadminOpts.NSQDHTTPAddresses = []string{"localhost:4151"}
		nsqadmin := nsqadmin.New(nsqadminOpts)
		nsqadmin.Main()
	}()

	cfg := nsq.NewConfig()

	c, err := nsq.NewConsumer("logger", "local", cfg)
	if err != nil {
		log.Fatal(err)
	}

	c.AddHandler(nsq.HandlerFunc(func(m *nsq.Message) error {
		f, err := os.OpenFile(LOGGER_PATH, os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0644)
    n, err := f.Write(m.Body)
		log.Println("log file bytes written:", n)
		if err != nil {
			log.Fatal(err)
		}
		defer f.Close()
		f.Sync()
		return nil
	}))

	c.ConnectToNSQD("127.0.0.1:4150")

	done <- true
}
