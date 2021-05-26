class Server
  def initialize(port)
    @port = port
    @cache = {}
  end

  def start
    @serversocket = TCPServer.open(@port)    # Socket to listen on port 2000
    p 'Memcached Server started'
    loop do # Servers run forever
      Thread.start(@serversocket.accept) do |client|
        p 'Connection with client stablished'
        client.puts(Time.now.ctime) # Send the time to the client

        client.puts 'Closing the connection. Bye!'

        client.close                  # Disconnect from the client
      end
    end
  end
end
