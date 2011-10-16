require 'detroit-minitest'

When 'Given a test file called "(((.*?)))" containing' do |file, text|
  File.open(file ,'w'){ |f| f << text }
end

