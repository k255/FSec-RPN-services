#!/usr/bin/env ruby -i
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


counter = 0
count = 0
results = Array.new

ARGF.each_line do |line|
    if counter == 0
      puts "Input:"
      counter = line.to_i
      count = counter
    else
      request.write(line)

      msg = response.pop
      results.push(msg.body)
      msg.finish

      counter = counter - 1
      if counter == 0 && count > 0
        puts ""
        puts "Output:"
        for res in results
          puts "res: " + res
        end
        count = 0
        break
      end
    end
end

__END__
