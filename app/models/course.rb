require 'open-uri'

class Course < ActiveRecord::Base
  has_many :lessons, dependent: :destroy
  has_attached_file :image, styles:{medium: '300x300>', thumb: '100x100>' , icon: '50x50>' }, default_url: '/assets/:style/missing_image.png'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/, size:{in: 0..10.megabytes }
  validates_uniqueness_of :name
  #validates_uniqueness_of :source_url

  belongs_to :category
  belongs_to :medium
  belongs_to :format
  belongs_to :author

  self.per_page = 20
   
  
  def to_s
    name
  end    

  def populate
    if lessons.count == 0
      crawl
    end
  end

  def crawl
    puts "#{category} - #{name} - #{source_url} " 

    if source_url == "http://pilgrimsseeing.blogspot.com/p/blog-page.html"
      crawl_robinson      
    elsif source_url == "http://www.dyjdj.com/shuku/a/10166/03-1.yinchangdemana/"
      crawl_hidden_manna
    elsif source_url == "http://cclw.net/Bible/BibleRadioPlay/BibleRadioPlay.htm"
      crawl_bible_stories
    elsif source_url == "http://www.lifechurchmissions.com/36L.aspx"
      crawl_life_church 'fung-36.html'
    elsif source_url == "http://www.lifechurchmissions.com/TheMessages.aspx?LinkNo=199"
      crawl_life_church 'fung-romans.html'
    elsif source_url == "http://cclw.net/gospel/explore/youziyin/htm/index.htm"
      crawl_cclw_sow 
    elsif source_url == "http://xybk.fuyin.tv/Books/OCM_Song_Wanderer/b5/Vol1/00.htm"
      crawl_sow 
    elsif source_url == "http://xybk.fuyin.tv/Books/OCM_Song_Wanderer/gb/Vol7/00.htm"
      crawl_sow 
    elsif source_url == "http://www.cclw.net/soul/tianlulichen/tllc.htm"
      crawl_tllc 
    elsif source_url == "http://www.360doc.com/content/11/0907/13/7536509_146441735.shtml"
      crawl_kenneth_hagin 
    elsif source_url == "http://www.360doc.com/content/11/0907/13/7536509_146442406.shtml"
      crawl_kenneth_hagin 
    elsif source_url == "http://www.360doc.com/content/14/1025/13/19250052_419709623.shtml"
      crawl_rong_jiao_shi 
    elsif source_url == "http://cclw.net/book/yushentongzai/htm/list.htm"
      crawl_yushentongzai 
    elsif source_url == "http://cclw.net/book/lingchenziyin/index.html"
      crawl_lingchenziyin
    elsif source_url == "http://www.cclw.net/other/slgy/"
      crawl_shulinggeyan
    elsif source_url == "http://www.cctmweb.net/lawr/lawr-epil.htm"
      crawl_ba
    elsif source_url and source_url.include? "http://fungclass.fhl.net/"
      crawl_fungclass 
    elsif source_url and source_url.include? "jgospel.net"
      crawl_jgospel 
    elsif source_url and source_url.include? "www.fuyin.tv"
      crawl_fuyin_tv 
    elsif source_url and source_url.include? "fungclass.fhl.net"
      crawl_fung_class 
#    elsif source_url and source_url.include? "http://www.cclw.net/other/binluyi/zstdzz/index.html"
#      crawl_cclw_saints
    elsif source_url.include? "http://www.cclw.net/gospel/explore/rszl/"
      crawl_truth 
    else
      crawl_none  
    end

  end


  def line_to_name(line)
    line = line.gsub("\u00A0", ' ').strip
    line.slice!("圣经堤要 - #{name}")
    line.slice!("培训者指南 - ")
    line.slice!("#{category.name} - #{name}")
    line.slice!("#{category.name} - ")
    line.slice!("#{name} ——")
    line.slice!("#{name}_")
    line.slice!("#{name} -")
    line.slice!("#{name}——")
    line.slice!("#{name}—")
    line.slice!("#{name} ")
    line = line.gsub("  ", ' ')
    line = line.gsub("章", '章 ')
    line = line.gsub("  ", ' ')
    line = line.gsub("_", ' ')
    line = line.gsub("　", '')
    line = line.gsub("\r\n\t", '').strip
    
    line = name if line.blank?
    return line
  end

  def insert?(lesson_name)
     if lesson_name == "第二十一章 亚伯拉罕生以撒"
       return true
     elsif lesson_name == "第四十九章 雅各临死前给众子说预言并留遗言"
       return true
     else
       return false  
     end 
  end
  
  def page_name(doc)
    line = doc.css('h1').text.strip
    return line_to_name(line)
  end

  def toc? line
    if line.include?("目錄") or
       line.include?("目录") or
       line.include?("培训者指南")  
       true
     else
       false
     end  
          
  end
  
  def process_line(line)
    line = line.text.lstrip.gsub("\uE5E5", '').gsub("\u00A0", '').gsub("\u3000", '').gsub("\u3000", '').strip if line.respond_to? 'text'
    line = "<h2>#{line}</h2>" if ["壹、內容綱要", "壹、内容纲要", "貳、逐節詳解", "贰、逐节详解", "參、靈訓要義", "参、灵训要义"].include? line
    return line
  end



  def process_lines (lesson, lines)
    lines.delete_if {|line| line.blank?}
    lesson.body = lines.join("<br><br>\n\n")
    lesson.description =  lines[0].blank? ? "" : line_to_name(lines[0]).truncate(255, omission: '')
    lesson
  end



  def save_lesson (lesson_name, lines, is_file=false)
    
    lesson = self.lessons.find_or_create_by name: lesson_name, is_file: is_file
    process_lines(lesson, is_file ? [""]: lines)
    lesson.description = description if lesson.description.include? '<' and  lesson.description.include? '>' 
    lesson.save
    
    if is_file    
      IO.write(lesson.file_path, lines[0])
    end  

    logger.info "#{category} - #{name} - #{lesson.name}: #{lesson.description}" 
    puts "#{category} - #{name} - #{lesson.name}: #{lesson.description}"
  end
  
  def sanitize_body body
      body = body.gsub('', '')
      #body = body.gsub('<a ', '<span ').gsub('</a>', '</span>')
      body = body.gsub("center", "left")
      body = body.gsub("\n", "")
      body = body.gsub("\u00A0", "")
      body = body.gsub("　", "")
      body = body.gsub("(", " (")
      body = body.gsub(")", ") ")
      body = body.gsub("font:13.5pt;color:#C24D1B", "font:13.5pt;color:#C24D1B;display:none")
      body = body.gsub("<b><span", "<br><b><span")
      body = body.gsub("<br><br><b>", "<b>")
      body = body.gsub("<br><br></font>", "</font>")
      body = body.gsub("<br><br></div>", "</div>")
      body = body.gsub("<br><br><br><br>", "<br><br>")
      body = body.gsub("<br><br><br>", "<br><br>")
      body = body.gsub("<br><br><br>", "<br><br>")
      body = body.gsub("<br><br><br>", "<br><br>")
      body = body.gsub("<br><br>", "<br><br>\n\n")
  end

  def crawl_none
    debugger
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    self.save
  end  
  
  def crawl_fungclass
    coder = HTMLEntities.new
    
    self.medium = Medium.find_by name: "interactive"
    self.format = Format.find_or_create_by name: "fung"
    self.save
    
    doc = Nokogiri::HTML(open(source_url))

    self.name = doc.title[10..-2]
    links = doc.css('tr td a')

    urls = links.map{|link| URI.escape link['href']}

    urls.each do |url|
      doc = Nokogiri::HTML(open(url), nil, 'gb18030')
      lines = doc.css('.post-body').text.split("\n")
      save_lesson(lines[0], lines[1..-1])
    end
  end
    
  
  def crawl_robinson
    coder = HTMLEntities.new
    
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    self.save
    
    doc = Nokogiri::HTML(open(source_url), nil, 'utf-8')

    links = doc.css('#post-body-3257335438027347076 h4 a')
    urls = links.map{|link| URI.escape link['href']}

    urls.each do |url|
      doc = Nokogiri::HTML(open(url), nil, 'utf-8')
      lines = doc.css('.post-body').text.split("\n")
      save_lesson(lines[0], lines[1..-1])
    end
  end
  
  def crawl_yushentongzai
    coder = HTMLEntities.new
    
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    self.save
    
    doc = Nokogiri::HTML(open(source_url), nil, 'gb18030')
#debugger
    links = doc.css('tr td p a')
    #links = doc.css('a')
    urls = links.map{|link| URI.escape link['href']}

    base_url =  source_url.slice(0..source_url.rindex('/'))

    links.each do |link|
      url = link[:href]
      url = base_url + url if !url.include? base_url
      title = link.text
      doc = Nokogiri::HTML(open(url), nil, 'gb18030')
      #lines = doc.css('tr td p').text.split("\r\n\r\n")
      lines = doc.css('td').text.split("\n").delete_if{|line| line.blank?}
      lines = doc.css('td').text.split("\n\n").delete_if{|line| line.blank?}
      lines.map!{|line|line.gsub(" \n", "")}
      lines.map!{|line|line.gsub("\n", "")}
      lines.map!{|line|line.gsub("\uE5E5", "")}
      lines.map!{|line|line.gsub("注释：", "<b>注释：</b><br><br><ol></ol>")}
      
      lines[0].gsub! title, ""

#debugger
      save_lesson(title, lines)
    end
  end
  
  def crawl_lingchenziyin
    coder = HTMLEntities.new
    
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    self.save
    
    doc = Nokogiri::HTML(open(source_url), nil, 'gb18030')

    links = doc.css('center a')
    #links = doc.css('a')
    urls = links.map{|link| URI.escape link['href']}

    base_url =  source_url.slice(0..source_url.rindex('/'))

    links.each do |link|
      url = link[:href]
      url = base_url + url if !url.include? base_url
      title = link.text
      begin
       
        doc = Nokogiri::HTML(open(url), nil, 'gb18030')

        lines = doc.css('font').text.split(/\n|\t\n/).delete_if{|line| line.blank?} 
        lines.map!{|line|line.gsub(" \n", "").gsub("\n", "").gsub("\uE5E5", "").gsub("上一章   目录 下一章", "")}
        lines = lines.delete_if{|line| line.blank?}
        lines[0].gsub! title, ""

        save_lesson(title, lines)
      rescue
      end  
    end
  end

  def crawl_shulinggeyan
    coder = HTMLEntities.new
    
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    self.save
    
    doc = Nokogiri::HTML(open(source_url), nil, 'gb18030')

    links = doc.css('center a')
    #links = doc.css('a')
    urls = links.map{|link| URI.escape link['href']}

    base_url =  source_url.slice(0..source_url.rindex('/'))

    links.each do |link|
      url = link[:href]
      url = base_url + url if !url.include? base_url
      title = link.text
      begin
        doc = Nokogiri::HTML(open(url), nil, 'gb18030')

        #lines = doc.css('tr td p').text.split("\r\n\r\n")
        lines = doc.css('td').text.split(/\n\n|\t\n/).delete_if{|line| line.blank?} 
        lines = lines.delete_if{|line| line.blank?}
        lines = lines[1..-2]

        lines.map!{|line|line.gsub(" \n", "").gsub("\n", "").gsub("\uE5E5", "")}
        lines[0].gsub! title, ""
        save_lesson(title, lines)
      rescue
      end  
    end
  end


  # parse one single page into multiple lessons
  def crawl_ba
    book  = Medium.find_or_create_by name: "book",         icon: "fa-book"
    html = Format.find_or_create_by name: "html"
    max_title_length = 32
    
    self.medium = book
    self.format = html
    self.save
    
    doc = Nokogiri::HTML(open(source_url), nil, 'GBK')
    
    lines = doc.css('center').to_a[0].text.split("\n\n").map!{|line|line.gsub("\n", "")}
    lesson = nil
    course = self
    started = false;
    lines.each do |line|
#debugger
      if line.length < 32
        started = true;         
      end

      if line.blank? or !started  
        next
      end

      if line.length < max_title_length 
        if !lesson.blank?
          logger.info "#{course.category} - #{course.name} - #{lesson.name}" 
          puts "#{course.category} - #{course.name} - #{lesson.name}"
        end 

        lesson = course.lessons.find_or_create_by name: line
      else
        if lesson.body
          lesson.body += "<br><br>\n\n" + line 
        else
          lesson.body  = line  
        end  
      end
      
      lesson.save  if lesson
   end
    
  end
  

  def crawl_jgospel
    coder = HTMLEntities.new
    
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    self.save
    
    if !source_url.blank?
      doc = Nokogiri::HTML(open(source_url), nil, 'utf-8')

    elsif !source.blank?
      doc = Nokogiri::HTML(source, nil, 'utf-8')
    end

    links = doc.css('.relatedList li a')
    urls = links.map{|link| URI.escape link['href']}
    
    lesson_urls = []
    lesson_urls << source_url if ! toc?(page_name(doc))  
    lesson_urls += urls

    lesson_urls.each do |url|
      url = "http://jgospel.net" + url if !url.include? "http://"

      doc = Nokogiri::HTML(open(url), nil, 'utf-8')
      lesson_name = page_name(doc)
      
      sections = doc.css('#contentBody p').to_a
      sections = sections.map{ |line| process_line(line) }
      
      lesson_lines = []
      sections.each do |section|
        lesson_lines += section.split("\r\n\t")
      end  
      
      if lesson_name.include? line_to_name(lesson_lines[0]) or
         line_to_name(lesson_lines[0]).include? lesson_name  
         lesson_lines.delete_at 0
      end
      
      save_lesson(lesson_name, lesson_lines)
      
      lessons.create if insert?("lesson_name")
    end
    
  end


  def crawl_rong_jiao_shi
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    self.save
    
    doc = Nokogiri::HTML(open(source_url), nil, 'utf-8')
    lines = doc.css('#articlecontent p').to_a
    lesson = nil
    
    lines.each do |line|
      if lesson == nil 
        lesson = lessons.find_or_create_by name: process_line(line)
      else
        if line.text.strip[0..4].include? "第" and line.text.strip[0..4].include? "章" or line.text.strip[0..6].include? "荣教士证道词"
          lesson.save
          
          logger.info "#{category} - #{name} - #{lesson.name}: #{lesson.description}" 
          puts "#{category} - #{name} - #{lesson.name}: #{lesson.description}" 
  
          lesson = lessons.find_or_create_by name: line.text.strip
        else
          line = process_line line

          if lesson.description == nil
            lesson.description =  line.truncate(255, omission: '')
          end          

          if lesson.body
            lesson.body += '</br></br>' + line 
          else
            lesson.body  = line  
          end  
        end
      end
      
      lesson.save  
   end
    
  end
  

  def crawl_kenneth_hagin
    book  = Medium.find_or_create_by name: "book",         icon: "fa-book"
    html = Format.find_or_create_by name: "html"
    max_title_length = 30
    
    books = ["信心祷告26讲", "医治属于我们", "一切忧虑卸给神"]
    self.medium = book
    self.format = html
    self.save
    
    doc = Nokogiri::HTML(open(source_url), nil, 'utf-8')
    lines = doc.css('#articlecontent p, #articlecontent h1, #articlecontent h3').to_a
    lesson = nil
    course = self
    started = false;
    
    lines.each do |line|
      if !line.children.blank? and !line.children[0].name.blank? and line.children[0].name == "strong"
        line = "<b>#{line.text.strip}</b>"
      else
        line = process_line line
      end  

      #puts line[0..128]

      if line.include? "第一部分 如何被圣灵引导" and not line.include? ".."
        started = true;         
      end

      if line.include? "信心祷告26讲" and not line.include? ".."
        started = true;         
      end

      if line.blank? or !started  
        next
      end
          
      if line.length < max_title_length and  line[0] == "第" and line[2..3] == "部分"
        started = true;
        course = category.courses.find_or_create_by author:author, medium: book, format: html, name:line[4..-1].strip
        course.save  

        logger.info "#{course.category} - #{course.name}" 
        puts "#{course.category} - #{course.name}"
        
      elsif line.length < max_title_length and books.include? line.strip
        started = true;
        course = category.courses.find_or_create_by author:author, medium: book, format: html, name:line 
        course.save  

        logger.info "#{course.category} - #{course.name}" 
        puts "#{course.category} - #{course.name}"
        
      elsif line.length < max_title_length and  line[0] == "第" and ( line[2..4].include? "章" or line[2..4].include? "讲")
        if !lesson.blank?
          lesson.save
          
          logger.info "#{course.category} - #{course.name} - #{lesson.name}" 
          puts "#{course.category} - #{course.name} - #{lesson.name}"
        end 

        lesson = course.lessons.find_or_create_by name: line
      else
        if lesson.description == nil
          lesson.description =  line.truncate(255, omission: '')
        end          

        if lesson.body
          lesson.body += "<br><br>\n\n" + line 
        else
          lesson.body  = line  
        end  
      end
      
      lesson.save  if lesson
   end
    
  end
  
    
  def crawl_truth
    coder = HTMLEntities.new
    
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    self.save
    
    base_url =  source_url.slice(0..source_url.rindex('/'))
    doc = Nokogiri::HTML(open(source_url), nil, "gb2312")
    links = doc.css('tr > td > a')
    
    links = links.to_a.delete_if {|link| link['href'].include? "#"}

    links.each do |link|
      next if link.text.blank? or link.text.include?("../../") 
      url = URI.escape link['href']
      url = base_url + url if !url.include? base_url

      doc = Nokogiri::HTML(open(url), nil, 'gb2312')
      titles = doc.css('[style^="font-size: 16"]')
      titles[0].content = "" if titles.size > 0 and !titles[0].blank? 
      
      body = doc.css('tr:nth-child(1) td')
      body = doc.css('tr:nth-child(2) td') if body.text.blank?
      
      body = body.to_html({encoding: 'UTF-8'})
      body = body.gsub("下一页", "")
      
      body = sanitize_body body
      save_lesson link.text, [body]
    end
  end
 
 
  def crawl_tllc
    coder = HTMLEntities.new
    
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    self.save
    base_url =  source_url.slice(0..source_url.rindex('/'))
    doc = Nokogiri::HTML(open(source_url))
    links = doc.css('tr td a')
    links = links.to_a.delete_if {|link| link['href'].include? "#"}

    links.each do |link|
      url = URI.escape link['href']
      url = base_url + url if !url.include? base_url

      doc = Nokogiri::HTML(open(url), nil, 'gb18030')
      
      content = doc.at_css "td"

      title = content.css('b')
      title.first.content = "" if !title.blank?

      doc.css('img ~ br').each {|br| br.name = 'i' }
      doc.css('a ~ br').each {|br| br.name = 'i' }
      doc.css('img').each {|img| img["height"] = 'auto' }

      links = doc.css('a')
      links[-1].content = '' if links[-1]
      links[-2].content = '' if links[-2]

      sups = doc.css('sup a')
      sups.each do |sup| 
        sup["data-rel"] = "popup" 
        sup["data-transition"] = "pop"
        sup.content = "[注" + sup.content + "]"
      end  
      doc.css('sup').each {|sup| sup.name = 'span' }
      
        
      pops = doc.css('hr ~ hr ~ p')
      pops = doc.css('hr ~ p') if pops.size == 0
      if pops != nil and pops.size > 0
        pops.each do |pop|
          if pop.css('a') != nil and pop.css('a').first
            pop = pop.dup
            pop.name = 'div'
            pop['id'] = pop.css('a').first["name"]  
            pop['data-role']="popup"
            pop.parent = content            
          end  
        end
      end
      
      #doc.css('hr').each {|br| br.name = 'i' }

      body = doc.css('tr td').to_html({encoding: 'UTF-8'})
      body = sanitize_body body
      body = body.gsub("images/", "/images/pilgrim/").gsub("#ca0100", "gray")
      body = body.gsub("老世故", "世故").gsub("宣道师", "传道").gsub("道学村", "道德村").gsub("毁灭城", "将亡城").gsub("柔顺", "易迁").gsub("尽忠", "忠信").gsub("灰心沼", "绝望沼")
      body = body.gsub("《旧约全书·", "《").gsub("《新约全书·", "《").gsub("》第", "》").gsub("章第", "章")
      
      save_lesson link.text, [body]
    end
  end


  def crawl_hidden_manna
    coder = HTMLEntities.new
    
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    self.save
debugger    
    base_url =  source_url.slice(0..source_url.rindex('/'))
    doc = Nokogiri::HTML(open(source_url))
    links = doc.css('tr td a')
    links = links.to_a.delete_if {|link| link['href'].include? "#"}

    links.each do |link|
      url = URI.escape link['href']
      url = base_url + url if !url.include? base_url

      doc = Nokogiri::HTML(open(url), nil, 'gb18030')
      
      titles   = doc.css 'b span'
      contents = doc.css "span p"

      body = contents.to_html({encoding: 'UTF-8'})
      body = sanitize_body body
      body = body.gsub("font-size:11pt; color=#ca0100", "font-weight:bold")
      body = body.gsub(/font-size: *1.pt/, "")
      body = body[0..16000]
      
      for i in 0..titles.size-1 
#        debugger
        save_lesson titles[i].text, [body]
      end
      
    end
  end
  


  def crawl_cclw_sow
    coder = HTMLEntities.new
    
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    self.save
    base_url =  source_url.slice(0..source_url.rindex('/'))
    doc = Nokogiri::HTML(open(source_url))
    links = doc.css('tr td a')
    links = links.to_a.delete_if {|link| link['href'].include? "#"}

    links.each do |link|
      url = URI.escape link['href']
      url = base_url + url if !url.include? base_url

      doc = Nokogiri::HTML(open(url), nil, 'gb18030')
      
      titles   = doc.css 'b span'
      contents = doc.css "span p"

      body = contents.to_html({encoding: 'UTF-8'})
      body = sanitize_body body
      body = body.gsub("font-size:11pt; color=#ca0100", "font-weight:bold")
      body = body.gsub(/font-size: *1.pt/, "")
      body = body[0..16000]
      
      for i in 0..titles.size-1 
#        debugger
        save_lesson titles[i].text, [body]
      end
      
    end
  end
  

  def crawl_bible_stories
    coder = HTMLEntities.new
    
    self.medium = Medium.find_by name: "audio"
    self.format = Format.find_or_create_by name: "mp3"
    self.save
    doc = Nokogiri::HTML(open(source_url))
    ot_links = doc.css('div:nth-child(5) table  tr td a')
    nt_links = doc.css('div:nth-child(9) table  tr td a')

    links = ot_links + nt_links
    links = links.to_a.delete_if {|link| link['href'].include? "#"}

    links.each do |link|
      url  = URI.escape link['href']
      path = url.gsub("http://www.jdtjy.com/html/shengjingyuandi/shengjinggushi/jiuyuegushi/", "")
      path = path.gsub("http://www.jdtjy.com/html/shengjingyuandi/shengjinggushi/xinyuegushi/", "")
      path = path.upcase.gsub("MP3", "mp3")

      url = "http://audio.awr.org/asia/HongKong/mandarin/ONT/" + path
      puts "  #{url}"
      file_name = link.text.gsub(".", "-").strip + ".mp3"
      file_path = Rails.root.join('public', "bible_stories", file_name)
      
      open(file_path, 'wb') do |file|
        file << open(url).read
      end
            
    end
  end
    
  def crawl_sow
    coder = HTMLEntities.new
    
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    self.save
    self.lessons.destroy_all
    
    base_url =  source_url.slice(0..source_url.rindex('/'))
    doc = Nokogiri::HTML(open(source_url))
    links = doc.css('tr td a')
    links = links.to_a.delete_if {|link| link['href'].include? "#"}

    links.each do |link|
      url = URI.escape link['href']
      url = url.gsub("/-", "/0").gsub("/010", "/10").gsub("/011", "/11").gsub("/012", "/12")
      url = base_url + url if !url.include? base_url

      doc = Nokogiri::HTML(open(url))
      title = link.text
      
      doc.css('a').each {|ele| ele.name = 'i' and ele.content = '' }
      doc.css('hr').each {|ele| ele.name = 'i'}
      doc.css('br').each {|ele| ele.name = 'i'}
      
      titles   = doc.css 'center center'
      
      for i in 0..titles.size-1 
        lesson_name = titles[i].text.dup.strip

        # remove titles from body
        titles[i].content = ''
        
        contents = doc.css "tr > td"
        body = contents.to_html({encoding: 'UTF-8'})
        body = sanitize_body body
        body = body.gsub('color="#030303"', 'style="font-weight:bold"')
        body = body.gsub('color="#92532A"', 'style="font-weight:bold"')
        body = body.gsub('color="#8F4f35"', 'style="font-weight:bold"')
        body = body.gsub('color="#1A4D60"', 'style="font-weight:bold"')
        body = body.gsub('color="#333333"', 'style="font-weight:bold"')
        body = body.gsub('color="#525A5A"', 'style="font-weight:bold"')
        body = body.gsub('color="#101010"', 'style="font-weight:bold"')
        
        
        body = body.gsub(/font-size: *1.pt/, "")
         
        if !self.lessons.find_by(name:lesson_name) 
          body_length = body.size
          if body_length > 16384
            save_lesson lesson_name, [body[0..16383]]
            
            save_lesson lesson_name + "--续", [body[-16360..-1]]
          else  
            save_lesson lesson_name, [body]
          end
        end
            
      end
      
    end
  end  


  def crawl_life_church (file_name)
    coder = HTMLEntities.new
    
    id_prefix = "ctl00_ContentPlaceHolder1_"
    note_id_prefix = "ctl00_ContentPlaceHolder1_TheMessagesGridControl_gvMessageList_"
    
    self.medium = Medium.find_by name: "book"
    self.format = Format.find_or_create_by name: "html"
    
    self.save
    base_url =  source_url.slice(0..source_url.rindex('/'))
    doc = Nokogiri::HTML(open(source_url), nil, 'utf-8')


    rows = doc.css("tr[valign=top]")

    rows.reverse.each do |row|
      date = row.css("td")[0].text
      
      lesson_name = row.css("td")[1].css("a")[0].text if !row.css("td")[1].css("a").blank? 
      lesson_name = row.css("td")[1].text if lesson_name.blank?
      lesson_name = lesson_name.gsub("之", "") if name == "罗马书"
      lesson_name = "三十六课纵览 " + lesson_name if name == "三十六课" and lesson_name[0] == "之"

      next if lesson_name.blank?
      next if ["有应许的信仰",  "《罗马书》(英文)", "罗马书"].include? lesson_name
      next if row.css("td")[3].blank?

      lesson_link = row.css("td")[1].css("a")[0]['href'] if !lesson_name.blank?

      #verse = row.css("td")[1].css("span").text
      verse = row.css(".verselink").text
      verse = verse.gsub("经文: ", "") if !verse.blank?


      #body +=    "    <h4>#{name} | <span style=\"text-align:right\">#{verse}</span> </h4>\n"
      #body +=    "      <a href=#{base_url + href}><img src=\"/images/life-church/right.png\" class=\"link-icon\"></a>\n"
      
      lesson_doc  = Nokogiri::HTML(open(base_url + lesson_link), nil, 'utf-8')
      media_links = lesson_doc.css("[target=msgMedia]") 
      
      # media tabls      
      body  = ""
      body +=    "<div data-role=\"tabs\" id=\"media-tabs\">\n"
      body +=    "  <div data-role=\"navbar\">\n"
      body +=    "    <ul>\n"
      media_links.each do |media|
        img = media.css("img")[0]['src'].gsub("images/", "/images/life-church/")
        next if img.include? "youkulink.png"
        next if img.include? "audio_en.png"
        url = media['href'].gsub("LCMVideoPlayer.html?v=", "").gsub("LCMAudioPlayer.html?a=", "")
        id  = media['id'].gsub(id_prefix, "")
        id = YouTubeAddy.extract_video_id(url) if url.include? "youtube.com"
        file_url = "/life_church/#{id}.html"
        body +=  "      <li><a href=\"#{file_url}\" data-ajax=\"false\"><img src=\"#{img}\" class=\"nav_button\"></a></li>\n"
      end
      body +=    "    </ul>\n"
      body +=    "  </div>\n\n"
      body +=    "</div>\n\n"

      media_links.each do |media|
        img = media.css("img")[0]['src'].gsub("images/", "/images/life-church/")
        next if img.include? "audio_en.png"
        url = media['href'].gsub("LCMVideoPlayer.html?v=", "").gsub("LCMAudioPlayer.html?a=", "")
        id  = media['id'].gsub(id_prefix, "")
        id = YouTubeAddy.extract_video_id(url) if url.include? "youtube.com"
        next if url.include? "youku.com"
        
        page    ="  <div id=\"#{id}\" class=\"videoWrapper\">\n"
        if url.include? "youtube.com"  
          page +="    <iframe width=\"100%\" src=\"#{url}\" frameborder=\"0\" height=\"500px\" allowfullscreen></iframe>\n"
        elsif url.include? ".mp4"
          page +="    <video  width=\"100%\" src=\"#{url}\" controls></video>\n"
        elsif url.include? ".mp3"
          page +="    <audio  width=\"100%\" src=\"#{url}\" controls></audio>\n"
        end
        page   +="  </div>\n"
        
        file_path = Rails.root.join('public', 'life_church', id.to_s + ".html")
        IO.write(file_path, page)
      end

      intro_cn = lesson_doc.css('textarea[name="ctl00$ContentPlaceHolder1$txtScriptureIntroCN"]').children.to_html
      intro_en = lesson_doc.css('textarea[name="ctl00$ContentPlaceHolder1$txtScriptureIntroEN"]').children.to_html
      
      # notes tabls      
      links = row.css("td")[4].css("a") + row.css("td")[5].css("a")
      body +=    "<div data-role=\"tabs\" id=\"note-tabs\">\n"
      body +=    "  <div data-role=\"navbar\">\n"
      body +=    "    <ul>\n"
      body +=  "      <li><a href=\"\#intro\" data-ajax=\"false\"><img src=\"/images/life-church/intro_en.png\" class=\"nav_button\"></a></li>\n" if !intro_cn.blank? or !intro_en.blank?
      
      links.each do |link|
        url = link['href']
        img = link.css("img")[0]['src'].gsub("images/", "/images/life-church/")
        id  = link['id'].gsub(note_id_prefix, "")
        file_url = "/life_church/#{id}.html"
        next if !["notes_cn.png", "notes_en.png", "transcript_cn.png"].include? link.css("img")[0]['src'].gsub("images/", "")
        body +=  "      <li><a href=\"#{file_url}\" data-ajax=\"false\"><img src=\"#{img}\" class=\"nav_button\"></a></li>\n"
      end
      body +=    "    </ul>\n"
      body +=    "  </div>\n\n"
      links.each do |link|
        url = link['href']
        id  = link['id'].gsub(note_id_prefix, "")
        next if !["notes_cn.png", "notes_en.png", "transcript_cn.png"].include? link.css("img")[0]['src'].gsub("images/", "")
        begin
          note_doc = Nokogiri::HTML(open(url))
          note_doc.css("span").map {|sp| sp['style']=""}
          note = note_doc.css("body").children.to_html if note_doc
          note = note.gsub('<p class="MsoNormal"><span lang="EN-US" style=""> </span></p>', '')

          file_path = Rails.root.join('public', 'life_church', id.to_s + ".html")
          IO.write(file_path, note)
        rescue
        end  
      end

      if !intro_cn.blank? or !intro_en.blank?
        body +=  "  <div id=\"intro\">\n"
        body +=  "    <div>#{intro_cn}</div>\n"
        body +=  "    <div>#{intro_en}</div>\n"
        body +=  "  </div>\n"
      end  

      body +=    "</div>\n\n"
      
      save_lesson "#{lesson_name}: #{verse}", [body]
    end

  end


  def next
    Course.where("id > ?", id).order("id ASC").first
  end

  def prev
    Course.where("id < ?", id).order("id DESC").first
  end
  
end

