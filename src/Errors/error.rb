# frozen_string_literal: true

class Error < StandardError
  ERROR = 'Nonexistent command name'
  def initialize(msg = ERROR)
    super(msg)
  end
end
