class ServerError < StandardError
    def initialize(msg="Server error ocurred, please try again")
        super(msg)
    end
end