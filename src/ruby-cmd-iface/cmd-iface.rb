#!/usr/bin/env ruby -i
require 'nsq'
require 'benchmark'

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

puts "Input:"
ARGF.each_line do |line|
    if counter == 0
      counter = line.to_i
      count = counter
    else
      msg = ""
      roundtripTime = Benchmark.realtime {
        request.write(line)

        msg = response.pop
      }

      results.push( msg.body.strip + ", " + '%.6f' % roundtripTime )
      msg.finish

      counter = counter - 1
      if counter == 0 && count > 0
        puts ""
        puts "Output:"
        for res in results
          puts res
        end
        count = 0
        break
      end
    end
end

response.terminate()
request.terminate()

__END__
