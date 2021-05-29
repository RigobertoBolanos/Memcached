require 'socket'
require_relative 'constants/replies'

class Client
  def initialize(port, hostname)
    @port = port
    @hostname = hostname
  end

  def start
    socket = TCPSocket.open(@hostname, @port)

    while (data = socket.gets.chomp)
      p data + Replies::NO_REPLY
      puts data.chomp unless data == Replies::NO_REPLY
      socket.puts(handle_user_input(gets.chomp))
    end
    socket.close
  end

  def handle_user_input(input)
    command = input.partition(' ').first
    if %w[get gets].include?(command)
      input
    elsif %w[set add replace append prepend cas].include?(command)
      data = gets.chomp
      data = 'nodata' unless data != ''
      "#{input} #{data}"
    end
  end
end
Client.new(2000, 'localhost').start