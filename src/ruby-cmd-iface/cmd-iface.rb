require 'nsq'

NSQ_ADDRESS='127.0.0.1:4150'

request = Nsq::Producer.new(
  nsqd: NSQ_ADDRESS,
  topic: 'test_topic'
)

response = Nsq::Consumer.new(
  nsqd: NSQ_ADDRESS,
  topic: 'test_topic',
  channel: 'local'
)


request.write('test payload')
request.terminate()

msg = response.pop
puts msg.body
msg.finish
response.terminate
