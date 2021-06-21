# frozen_string_literal: true

class ServerError < StandardError
  SERVER_ERROR = 'Server error ocurred, please try again'
  def initialize(msg = SERVER_ERROR)
    super(msg)
  end
end
