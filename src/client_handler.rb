require_relative 'errors\error'

class ClientHandler
  def initialize(socket, semaphore, cache)
    @socket = socket
    @semaphore = semaphore
    @cache = cache
  end

  def run
    @socket.puts('Connection stablished, you can input now')
    loop do
      @socket.puts(handle_input(@socket.gets.chomp))
    end
  end

  private

  def handle_input(input)
    command, arguments = verify_input(input)

    case command
    when Cache::GET     then @cache.get(arguments)
    when Cache::GETS    then @cache.get_s(arguments)
    when Cache::SET     then @cache.set(arguments)
    when Cache::ADD     then @cache.add(arguments)
    when Cache::REPLACE then @cache.replace(arguments)
    when Cache::APPEND  then @cache.append(arguments)
    when Cache::PREPEND then @cache.pre_pend(arguments)
    when Cache::CAS     then @cache.cas(arguments)
    else raise Error
    end
  rescue Error, ServerError, ClientError => e
    e.message
  ensure
    @cache.to_s
  end

  def verify_input(input)
    command = input.partition(' ').first
    arguments = input.partition(' ').last.split(' ')
    p "command:#{command}, arguments:#{arguments}"

    if %w[get gets].include?(command)
      verify_retrieve_command(arguments)
    elsif %w[set add replace append prepend cas].include?(command)
      verify_storage_command(command, arguments)
    else raise Error
    end

    [command, arguments]
  end

  def verify_storage_command(command, arguments)
    case command
    when Cache::APPEND, Cache::PREPEND
      if arguments.empty? ||
         arguments.size > 4 ||
         arguments.size < 3 ||
         (arguments.size == 4 && arguments[4] != 'noreply')

        raise ClientError
      end

      arguments[1] = arguments[1].to_i # convert flags, exptime and bytes to integer
    else
      if arguments.empty? ||
         arguments.size > 6 ||
         arguments.size < 5 ||
         (arguments.size == 6 && arguments[4] != 'noreply')

        raise ClientError
      end

      arguments[1, 3] = arguments[1, 3].map(&:to_i) # convert flags, exptime and bytes to integer
    end
    verify_data_bytes(arguments)
  end

  def verify_retrieve_command(arguments)
    if arguments.empty? ||
       arguments.size != 1

      raise ClientError
    end
  end

  def verify_data_bytes(arguments)
    if (arguments.size == 6 && arguments[5] != 'nodata' && arguments[5].length != arguments[3].to_i) || # 
       (arguments.size == 5 && arguments[4] != 'nodata' && arguments[4].length != arguments[3].to_i) || #
       (arguments.size == 4 && arguments[3] != 'nodata' && arguments[3].length != arguments[1].to_i) || #
       (arguments.size == 3 && arguments[2] != 'nodata' && arguments[2].length != arguments[1].to_i) || #
       (arguments.size == 6 && arguments[5] == 'nodata' && !arguments[3].to_i != 0) ||                  #
       (arguments.size == 5 && arguments[4] == 'nodata' && !arguments[3].to_i != 0) ||                  #
       (arguments.size == 4 && arguments[3] == 'nodata' && !arguments[1].to_i != 0) ||                  #
       (arguments.size == 3 && arguments[2] == 'nodata' && !arguments[1].to_i != 0)                     #

      raise ClientError
    end
  end
end
