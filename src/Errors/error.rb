class Error < StandardError
    def initialize(msg="Nonexistent command name")
      super(msg)
    end
end