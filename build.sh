#!/bin/bash

export GOPATH=$(pwd)
go get github.com/nsqio/go-nsq
go get github.com/nsqio/nsq/nsqd

go install go-mq-and-logger

pip install pynsq
pip install host_pool

gem install nsq-ruby
