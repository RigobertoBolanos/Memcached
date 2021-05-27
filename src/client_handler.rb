class ClientHandler
  def initialize(socket, semaphore, cache)
    @socket = socket
    @semaphore = semaphore
    @cache = cache
  end

  def handle_input(input)
    case input.partition(' ').first
    when Server::GET
      @socket.puts('GET request')
    when Server::GETS
      @socket.puts('GETS request')
    when Server::SET
      @socket.puts('SET request')
    when Server::ADD
      @socket.puts('ADD request')
    when Server::REPLACE
      @socket.puts('REPLACE request')
    when Server::APPEND
      @socket.puts('APPEND request')
    when Server::PREPEND
      @socket.puts('PREPEND request')
    when Server::CAS
      @socket.puts('CAS request')
    else
      @socket.puts('NONE')
    end
  end

  def get  
  end

  def gets  
  end

  def set  
  end

  def add  
  end

  def replace  
  end

  def append  
  end

  def prepend  
  end

  def cas  
  end

  def run
    @socket.puts('Connection stablished, you can input now')
    loop do
      handle_input(@socket.gets.chomp)
    end
  end
end