require 'socket'
require_relative 'client_handler'
require_relative 'constants/replies'
require_relative 'cache'

class Server
  include Replies

  def initialize(port)
    @port = port
    @cache = Cache.new
    @semaphore = Mutex.new
  end

  def start
    @serversocket = TCPServer.open(@port)
    p 'Memcached Server started'
    loop do
      Thread.start(@serversocket.accept) do |socket|
        ClientHandler.new(socket, @semaphore, @cache).run
      end
    end
  end
end
Server.new(2000).start