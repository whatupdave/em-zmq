module EventMachine
  module ZMQ
    class Connection < EventMachine::Connection
      attr_reader :socket

      def bind addr
        socket.bind addr
      end

      def connect addr
        socket.bind addr
      end

      def subscribe channel
        socket.setsockopt ZMQ::SUBSCRIBE, channel
      end

      def unsubscribe channel
        socket.setsockopt ZMQ::UNSUBSCRIBE, channel
      end

      def send_data(data, more=false)
        sndmore = more ? ::ZMQ::SNDMORE : 0

        success = socket.send_string(data.to_s, ::ZMQ::NonBlocking | sndmore)
        self.notify_writable = true unless success
        success
      end

      def readable?
        a = []
        socket.getsockopt(::ZMQ::EVENTS,a)
        (a.first & ::ZMQ::POLLIN) == ::ZMQ::POLLIN
      end

      def notify_readable
        return unless readable?

        loop do
          if msg = get_message
            receive_data msg.copy_out_string
            while socket.more_parts?
              if msg = get_message
                receive_data msg.copy_out_string
              else
                break
              end
            end
          else
            break
          end
        end
      end

      def notify_writable
        self.notify_writable = false
      end

    private

      def get_message
        msg = ::ZMQ::Message.new
        socket.recvmsg(msg, ::ZMQ::NonBlocking) ? msg : nil
      end

      def detach
        super
        socket.close
      end

    end
  end
end
