module EventMachine
  module ZMQ
    class Context < ::ZMQ::Context

      READ = [:sub, :req, :rep, :xreq, :xrep, :pull]
      WRITE = [:pub, :req, :rep, :xreq, :xrep, :push]

      def bind type, address, handler=nil, *args, &blk
        sock = socket type_const_from_args(type)
        [*address].each {|addr| sock.bind addr}

        create(sock, handler, *args, &blk)
      end

      def connect type, address, handler=nil, *args, &blk
        sock = socket type_const_from_args(type)
        [*address].each {|addr| sock.connect addr}

        create(sock, handler, *args, &blk)
      end

    private

      def create sock, handler=nil, *args, &blk
        klass = EM.send(:klass_from_handler, Connection, handler, *args)

        EM.watch(sock.getsockopt(::ZMQ::FD), klass, *args, &blk).tap {|conn|
          conn.instance_variable_set(:@socket, sock)

          if READ.include? sock.name.downcase.to_sym
            cnn.notify_readable if conn.readable?
            conn.notify_readable = true
          end

          if WRITE.include? sock.name.downcase.to_sym
            conn.notify_writable = true
          end
        }
      end

      def type_const_from_args arg
        arg.is_a?(Symbol) ? ::ZMQ.const_get(arg.to_s.upcase) : arg
      end

    end
  end
end
