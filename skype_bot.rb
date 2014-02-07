require 'rubygems'
require 'skype'

Skype.config :app_name => "seconoid"

last_id = 0
loop do
  Skype.chats.each do |chat|
    chat.messages.each do |m|
      next unless last_id < m.id
      chat.post "pong" if m.body.include? "ping"
      last_id = m.id
    end
  end
  sleep 1
end
