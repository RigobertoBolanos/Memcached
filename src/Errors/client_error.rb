class ClientError < StandardError
    def initialize(msg="The input doesn't conform to the protocol in some way")
        super(msg)
    end
end