require 'rubygems'
require 'skype'

Skype.config :app_name => "seconoid"

hearing_threshold = 10
last_id = 0
last_time = Time.now.to_i

loop do
  Skype.chats.each do |chat|
    chat.messages.each do |m|
      next unless last_id < m.id
      last_time = m.time.to_i

      next unless Time.now.to_i - last_time < hearing_threshold

      # chat
      chat.post "pong" if m.body.include? "ping"
      chat.post "はい。" if m.body.include? "ありすさん"
      chat.post "そうでもないです。" if m.body.include? "かわいいですね"
      chat.post "蹴っ飛ばしますよ。" if m.body.include? "誰にでも股開くんですね"
      chat.post "次から気をつけてください。" if m.body.include? "ごめんなさい"
      if m.body.include? "喉が渇きました"
        chat.post "紅茶をお淹れしますね。" if last_time % 2 == 0
        chat.post "コーヒーをお淹れしますね。" if last_time % 2 == 1
      end
     
      # time
      chat.post Time.now if m.body.include? "alice ruby puts Time.now"

      # id
      chat.post m.id if m.body.include? "alice ruby puts id"

      #dice
      chat.post Random.rand(5) + 1 if m.body.include? "alice plz dice"

      last_id = m.id
    end
  end
  sleep 1
end
