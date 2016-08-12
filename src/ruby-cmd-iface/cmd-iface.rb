#!/usr/bin/env ruby -i
require 'nsq'
require 'benchmark'

NSQ_ADDRESS='127.0.0.1:4150'

request = Nsq::Producer.new(
  nsqd: NSQ_ADDRESS,
  topic: 'user_input'
)

logRequest = Nsq::Producer.new(
  nsqd: NSQ_ADDRESS,
  topic: 'logger'
)

response = Nsq::Consumer.new(
  nsqd: NSQ_ADDRESS,
  topic: 'eval_results',
  channel: 'local'
)


counter = 0
count = 0
results = Array.new

exprLog = ''
resultLog = ''

puts "Input:"
ARGF.each_line do |line|
    if counter == 0
      counter = line.to_i
      count = counter
    else
      msg = ""
      roundtripTime = Benchmark.realtime {
        request.write(line.strip)
        msg = response.pop
      }

      exprLog += line.strip + "\n"
      resultLog += msg.body + ", " + '%.5f' % roundtripTime + "\n"

      results.push( msg.body + ", " + '%.5f' % roundtripTime )
      msg.finish

      counter = counter - 1
      if counter == 0 && count > 0
        puts ""
        puts "Output:"
        for res in results
          puts res
        end
        logRequest.write("Input:" + "\n" + count.to_s + "\n" + exprLog + "\nOutput:\n" + resultLog + "\n")
        count = 0
        exprLog = ""
        resultLog = ""
        break
      end
    end
end

response.terminate()
request.terminate()

__END__
