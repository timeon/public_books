class String

  def t locale="cn"

    text = self
    
    if locale == :'zh-TW' or locale == :tw or locale == "tw"  
      locale = 'tw'
    else
      locale = 'cn' 
    end    
    
    if text.length > 63
      file = Tempfile.new('foo')
      if locale == 'tw'
        text.gsub!(/\?locale=../, '?locale='+locale) 
      else
        text.gsub!(/\?locale=../, '') 
      end

      file.write(text + "\n")
      file.close
      command = "cconv -f utf-8 -t utf8-#{locale} -i #{file.path}"
    else
      file = nil  
      command = "echo #{text} | cconv -f utf-8 -t utf8-#{locale} "
    end
    
    result = ""
    begin
      IO.popen(command) do |io|
         result = io.read
      end
    rescue
    end    
    
    file.unlink if file   # deletes the temp file
    
    result
  end
  
end
