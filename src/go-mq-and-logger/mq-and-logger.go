package main

import (
	"github.com/nsqio/nsq/nsqd"
	"github.com/nsqio/go-nsq"
	"os"
	"log"
)

func main() {
	done := make(chan bool)

	go func() {
		opts := nsqd.NewOptions()
		nsqd := nsqd.New(opts)
		nsqd.Main()
	}()

	cfg := nsq.NewConfig()

	c, err := nsq.NewConsumer("logger", "local", cfg)
	if err != nil {
		log.Fatal(err)
	}

	c.AddHandler(nsq.HandlerFunc(func(m *nsq.Message) error {
		f, err := os.OpenFile("c:/tmp/dat.log", os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0644)
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
