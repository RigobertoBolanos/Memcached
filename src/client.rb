require 'socket'

class Client
  def initialize(port, hostname)
    @port = port
    @hostname = hostname
  end

  def start
    s = TCPSocket.open(@hostname, @port)
    puts 'Connection with Memcached Server stablished'
    while (line = s.gets)     # Read lines from the socket 
      puts line.chop       # And print with platform line terminator
    end

    s.close
  end
end
