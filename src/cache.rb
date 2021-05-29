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
    'get'
  end

  def get_s(arguments)
    'gets'
  end

  def set(arguments)
    noreply = nil
    data = ''
    if arguments.size == 6
      noreply = arguments[5]
      data = arguments[6]
    else
      data = arguments[5]
    end
    @hash[arguments[0]] = Record.new(arguments[1].clamp(0, 65_535), # flags
                                     arguments[2],                  # exptime
                                     arguments[3],                  # bytes
                                     arguments[4],                  # cas unique
                                     data)
    noreply.nil? ? Server::STORED : Server::NO_REPLY
  end

  def add(arguments)
    [nil, 'add']
  end

  def replace(arguments)
    [nil, 'replace']
  end

  def append(arguments)
    [nil, 'append']
  end

  def pre_pend(arguments)
    [nil, 'prepend']
  end

  def cas(arguments)
    [nil, 'cas']
  end

  def to_s
    @hash.each do |key, value|
      puts "#{key} #{value}"
    end
  end
end