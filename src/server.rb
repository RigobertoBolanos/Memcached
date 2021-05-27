require 'socket'
require_relative 'client_handler'
require_relative 'constants/commands'
require_relative 'constants/replies'

class Server

  include Commands
  include Replies

  def initialize(port)
    @port = port
    @cache = {}
    @semaphore = Mutex.new
  end

  def start
    @serversocket = TCPServer.open(@port)    # Socket to listen on port 2000
    p 'Memcached Server started'
    loop do # Servers run forever
      Thread.start(@serversocket.accept) do |socket|
        ClientHandler.new(socket, @semaphore, @cache).run
        # socket.close
      end
    end
  end

end
Server.new(2000).start