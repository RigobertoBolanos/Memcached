require_relative 'record'
require_relative 'constants/commands'
require_relative 'errors\server_error'
require_relative 'errors\client_error'

# <command name> <key> <flags> <exptime> <bytes> <cas unique> "noreply"
# <data block>
class Cache
  include Commands

  def initialize
    @hash = Hash.new(Server::NOT_FOUND)
  end

  def get(arguments)
    values = ''
    arguments.each do |key|
      if @hash.key?(key)
        record = @hash[key]
        values.insert(-1, "VALUE #{key} #{record.flags} #{record.exptime} #{record.bytes} #{record.cas_unique}\n#{record.data}\n")
      end
    end
    p values.to_s + 'END'
    values != '' ? "#{values}END\n" : Server::NOT_FOUND
  end

  def get_s(arguments)
    'gets'
  end

  def set(arguments)
    noreply = nil
    data = ''
    if arguments.size == 6
      noreply = arguments[4]
      data = arguments[5]
    else
      data = arguments[4]
    end
    p data
    @hash[arguments[0]] = Record.new(arguments[1].clamp(0, 65_535), # flags
                                     arguments[2],                  # exptime
                                     arguments[3],                  # bytes
                                     nil,                           # cas unique
                                     data)
    noreply.nil? ? Server::STORED : Server::NO_REPLY
  end

  def add(arguments)
    noreply = nil
    data = ''
    if arguments.size == 6
      noreply = arguments[4]
      data = arguments[5]
    else
      data = arguments[4]
    end
    if !@hash.key?(arguments[0])
      @hash[arguments[0]] = Record.new(arguments[1].clamp(0, 65_535), # flags
                                       arguments[2],                  # exptime
                                       arguments[3],                  # bytes
                                       nil,                           # cas unique
                                       data)
      noreply.nil? ? Server::STORED : Server::NO_REPLY
    else
      noreply.nil? ? Server::NOT_STORED : Server::NO_REPLY
    end
  end

  def replace(arguments)
    noreply = nil
    data = ''
    if arguments.size == 6
      noreply = arguments[4]
      data = arguments[5]
    else
      data = arguments[4]
    end
    if @hash.key?(arguments[0])
      @hash[arguments[0]] = Record.new(arguments[1].clamp(0, 65_535), # flags
                                       arguments[2],                  # exptime
                                       arguments[3],                  # bytes
                                       nil,                           # cas unique
                                       data)
      noreply.nil? ? Server::STORED : Server::NO_REPLY
    else
      noreply.nil? ? Server::NOT_STORED : Server::NO_REPLY
    end
  end

  def append(arguments)
    noreply = nil
    data = ''
    if arguments.size == 4
      noreply = arguments[2]
      data = arguments[3]
    else
      data = arguments[2]
    end
    key = arguments[0]
    if @hash.key?(key)
      data = @hash[key].data << data
      @hash[key] = Record.new(@hash[key].flags,   # flags
                              @hash[key].exptime, # exptime
                              @hash[key].bytes,   # bytes
                              nil,                # cas unique
                              data)
      noreply.nil? ? Server::STORED : Server::NO_REPLY
    else
      noreply.nil? ? Server::NOT_STORED : Server::NO_REPLY
    end
  end

  def pre_pend(arguments)
    noreply = nil
    data = ''
    if arguments.size == 4
      noreply = arguments[2]
      data = arguments[3]
    else
      data = arguments[2]
    end
    key = arguments[0]
    if @hash.key?(key)
      data = data << @hash[key].data
      @hash[key] = Record.new(@hash[key].flags,   # flags
                              @hash[key].exptime, # exptime
                              @hash[key].bytes,   # bytes
                              nil,                # cas unique
                              data)
      noreply.nil? ? Server::STORED : Server::NO_REPLY
    else
      noreply.nil? ? Server::NOT_STORED : Server::NO_REPLY
    end
  end

  def cas(arguments)
    'cas'
  end

  def to_s
    @hash.each do |key, value|
      puts "key: #{key}, #{value}"
    end
  end
end