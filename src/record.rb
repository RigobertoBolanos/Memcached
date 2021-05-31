# <command name> <key> <flags> <exptime> <bytes> <cas unique> "noreply"
# <data block>
class Record
  attr_accessor :flags, :exptime, :bytes, :cas_unique, :noreply, :data

  def initialize(flags, exptime, bytes, cas_unique, data)
    @flags = flags
    @exptime = exptime
    @bytes = bytes
    @cas_unique = cas_unique
    @data = data
  end

  def to_s
    "flags: #{@flags}, exptime: #{@exptime}, bytes: #{@bytes}, cas_unique: #{@cas_unique}, data: #{@data}"
  end
end
