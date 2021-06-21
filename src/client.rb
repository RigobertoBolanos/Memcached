require 'socket'
require_relative 'constants/replies'
require_relative 'errors/client_error'
require_relative 'errors/error'

class Client
  def initialize(hostname, port)
    @socket = TCPSocket.open(hostname, port)
  end

  def start
    p @socket.gets.chomp
    loop do
      handle_user_input(gets.chomp)
    end
    socket.close
  end

  def handle_user_input(input)
    command = input.partition(' ').first
    if %w[get gets].include?(command)
      handle_retrieve_command(input)
    elsif %w[set add replace append prepend cas].include?(command)
      handle_storage_command(input)
    else
      p Error::ERROR
    end
  end

  def handle_storage_command(input)
    data = gets.chomp
    data = 'nodata' unless data != ''
    @socket.puts("#{input} #{data}")

    data = @socket.gets.chomp
    p data unless data == Replies::NO_REPLY
  end

  def handle_retrieve_command(input)
    @socket.puts(input)
    reply = ''
    while reply != Replies::END_REPLY &&
          reply != ClientError::CLIENT_ERROR &&
          reply != Replies::NOT_FOUND
      reply = @socket.gets.chomp
      p reply
    end
  end
end
Client.new('localhost', 2000).start