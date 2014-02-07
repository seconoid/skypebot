require 'rubygems'
require 'skype'

Skype.config :app_name => "seconoid"

last_id = 0
loop do
  Skype.chats.each do |chat|
    chat.messages.each do |m|
      next unless last_id < m.id
      chat.post "pong" if m.body.include? "ping"
      chat.post "はい。" if m.body.include? "ありすさん"
      chat.post "そうでもないです。" if m.body.include? "かわいいですね"
      chat.post "蹴っ飛ばしますよ。" if m.body.include? "誰にでも股開くんですね"
      chat.post "次から気をつけてください。" if m.body.include? "ごめんなさい"
      last_id = m.id
    end
  end
  sleep 1
end