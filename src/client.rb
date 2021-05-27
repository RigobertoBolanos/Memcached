require 'socket'

class Client
  def initialize(port, hostname)
    @port = port
    @hostname = hostname
  end

  def start
    socket = TCPSocket.open(@hostname, @port)

    while (data = socket.gets)     # Read lines from the socket
      puts data.chopG
      socket.puts(gets.chomp)
    end
    socket.close
  end
end

Client.new(2000, 'localhost').start
