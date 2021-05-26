require_relative 'client'
require_relative 'server'

Thread.new { Server.new(2000).start }
sleep(2)
Thread.new { Client.new(2000, 'localhost').start }
