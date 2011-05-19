$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'eventmachine'
require 'eventmachine/zmq'

module Handler
  def post_init
    @i = 0
  end

  def receive_data(data)
    puts "Recieved message ##{@i}: #{data}"
    @i += 1
  end
end

EM.run do
  ctx = EM::ZMQ::Context.new

  push = ctx.bind :push, 'inproc://test'
  pull = ctx.connect :pull, 'inproc://test', Handler

  EM::PeriodicTimer.new(1) do
    push.send_data 'Hello World'
  end

end
