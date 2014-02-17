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
      drink = ["紅茶", "コーヒー", "アイスティー"].sample

      if m.body =~ /ping/
        chat.post "pong" 
      elsif m.body =~ /ありすさん/
        chat.post "はい。"
      elsif m.body =~ /かわいいですね/
        chat.post "そうでもないです。"
      elsif m.body =~ /誰にでも股開くんですね/
        chat.post "蹴っ飛ばしますよ。" 
      elsif m.body =~ /ごめんなさい/
        chat.post "気をつけてください。"
      elsif m.body =~ /喉が渇きました/
        chat.post "#{drink}をお淹れしますね。"
      end
     
      # time
      if m.body =~ /^alice?\s?plz?\s?current?\s?time$/
        chat.post Time.now
      end 

      # id
      if m.body =~ /^alice?\s?plz?\s?id$/
        chat.post m.id
      end

      #dice
      if m.body =~ /^alice?\s?plz?\s?dice$/
        chat.post Random.rand(6) + 1
      end

      #title


      last_id = m.id
    end
  end
  sleep 1
end
