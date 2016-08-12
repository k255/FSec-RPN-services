set GOPATH=%~dp0%
go get github.com\nsqio\nsq\nsqd

go install go-mq-and-logger

pip install pynsq
pip install host_pool

gem install nsq-ruby
