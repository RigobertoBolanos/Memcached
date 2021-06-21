# frozen_string_literal: true

class ClientError < StandardError
  CLIENT_ERROR = 'The input doesn\'t conform to the protocol in some way'
  def initialize(msg = CLIENT_ERROR)
    super(msg)
  end
end
