import nsq

writer = []

def process_message(message):
    global buf
    message.enable_async()
    print "received: " + message.body
    writer.pub('eval_results', 'python-' + message.body)
    message.finish()

if __name__ == "__main__":
    r = nsq.Reader(message_handler=process_message,
            nsqd_tcp_addresses='127.0.0.1:4150',
            topic='user_input', channel='local')

    writer = nsq.Writer(['127.0.0.1:4150'])
    nsq.run()
