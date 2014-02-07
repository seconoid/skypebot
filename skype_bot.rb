require 'rubygems'
require 'skype'

Skype.config :app_name => "my_skype_app"

## send message
Skype.message "secon6", "hello!!"

## call
#Skype.call "secon6"

## get recent chat list
puts Skype.search("secon6")

## send message to group chat
Skype.chatmessage "#name1/name2;$a1b2cdef3456", "hello chat!!"