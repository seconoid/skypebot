require 'rubygems'
require 'skype'
require 'open-uri'
require 'nokogiri'
require 'uri'

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
      coin = ["裏", "表"].sample

      if m.body =~ /^ping/
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
      elsif m.body =~ /嘆き147配置/
        chat.post "http://textage.cc/score/13/_nageki.html?1AC04R0257631401234567=11~59-62"
      elsif m.body =~ /おやすみなさい/
        chat.post "おやすみなさい。しっかり寝てね。"
      end
     
      # time
      if m.body =~ /^alice\s?plz\s?current\s?time$/
        chat.post Time.now
      end 

      # id
      if m.body =~ /^alice\s?plz\s?id$/
        chat.post m.id
      end

      #dice
      if m.body =~ /^alice\s?plz\s?dice$/
        chat.post Random.rand(6) + 1
      end

      #title
      if m.body.include? "http"
        URI.extract(m.body, ["http", "https"]).each do |uri|
          url = uri.to_s
          charset = nil
          html = open(url) do |f|
            charset = f.charset
            f.read
          end

          doc = Nokogiri::HTML.parse(html, nil, charset)

          chat.post "Title: #{doc.title}"
        end
      end

      #coin
      if m.body =~ /^alice\s?plz\s?coin$/
        chat.post "#{coin} です。"
      end

      last_id = m.id

      #in English
      if m.body =~ /^alice\s?what\s?meaning\s?of\s?"[a-z].*"$/
        m.body.scan(/".*"/).each do |str|
          str.scan(/[a-z]+[a-z]/).each do |ward|
            chat.post "http://ejje.weblio.jp/content/#{ward.to_s}"
          end
        end
      end

    end
  end
  sleep 1
end
