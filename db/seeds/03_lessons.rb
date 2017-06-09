
  audio = Medium.find_or_create_by name: "audio",        icon: "fa-volume-up"
  video = Medium.find_or_create_by name: "video",        icon: "fa-play-circle"
  inter = Medium.find_or_create_by name: "interactive",  icon: "fa-hand-o-up"
  book  = Medium.find_or_create_by name: "book",         icon: "fa-book"

  html = Format.find_or_create_by name: "html"
  fung = Format.find_or_create_by name: "fung"


category = Category.find_or_create_by name: "属灵操练"
  author   = Author.find_or_create_by  name: "倪柝声", english_name: "Watchman Ni"

  course = category.courses.find_or_create_by author:author, name:"隐藏的吗哪", source_url:"http://www.dyjdj.com/shuku/a/10166/03-1.yinchangdemana/"
  course.crawl

=begin  

category = Category.find_or_create_by name: "交互圣经课程"
category.update name:"圣经课程" if category
category = Category.find_or_create_by name: "圣经课程"
  author   = Author.find_or_create_by  name: "大卫鲍森"
  course = category.courses.find_or_create_by author:author, name:"纵览",  medium:inter, format:fung, source_url:"fung-unlock"


  author   = Author.find_or_create_by  name: "中华福音神学院"
  course = category.courses.find_or_create_by author:author, name:"释经",  medium:inter, format:fung, source_url:"fung-bible"
  course = category.courses.find_or_create_by author:author, name:"旧约",  medium:inter, format:fung, source_url:"fung-old"
  course = category.courses.find_or_create_by author:author, name:"新约",  medium:inter, format:fung, source_url:"fung-new"
  course = category.courses.find_or_create_by author:author, name:"实践",  medium:inter, format:fung, source_url:"fung-practice"

category = Category.find_or_create_by name: "属灵操练"
  author   = Author.find_or_create_by  name: "迈可.莫林诺", english_name: "Michael Molinos"

  course = category.courses.find_or_create_by author:author, name:"灵程指引", source_url:"http://cclw.net/book/lingchenziyin/index.html"
  course.crawl


category = Category.find_or_create_by name: "属灵操练"
  author   = Author.find_or_create_by  name: "劳伦斯", english_name: "Laurent"

  course = category.courses.find_or_create_by author:author, name:"跋", source_url:"http://www.cctmweb.net/lawr/lawr-epil.htm"
  course.populate

  course = category.courses.find_or_create_by author:author, name:"与神同在", source_url:"http://cclw.net/book/yushentongzai/htm/list.htm"
  course.populate

  course = category.courses.find_or_create_by author:author, name:"属灵格言", source_url:"http://www.cclw.net/other/slgy/"
  course.populate

  author   = Author.find_or_create_by  name: "盖恩夫人", english_name: "Jeanne Guyon"

  #course = category.courses.find_or_create_by author:author, name:"更深经历耶稣基督",   source_url:"http://jgospel.net/truth/bible-study/%E6%9B%B4%E6%B7%B1%E7%BB%8F%E5%8E%86%E8%80%B6%E7%A8%A3%E5%9F%BA%E7%9D%A3%E8%AA%B2%E7%A8%8B-%E7%9B%AE%E9%8C%84.c87287.aspx"
  #course.populate

  author   = Author.find_or_create_by  name: "慕安德烈", english_name: "Andrew Murray"
  course = category.courses.find_or_create_by author:author, name:"内在生活課程", source_url:"http://jgospel.net/truth/bible-study/%E5%86%85%E5%9C%A8%E7%94%9F%E6%B4%BB%E8%AA%B2%E7%A8%8B-%E7%9B%AE%E9%8C%84.c87177.aspx"
  course.populate
  course = category.courses.find_or_create_by author:author, name:"敬拜的秘诀",   source_url:"http://jgospel.net/truth/bible-study/%E5%B1%9E%E7%81%B5%E6%93%8D%E7%BB%83-%E6%95%AC%E6%8B%9C%E7%9A%84%E7%A7%98%E8%AF%80-%E7%9B%AE%E9%8C%84.c88036.aspx"
  course.populate
  course = category.courses.find_or_create_by author:author, name:"谦卑",        source_url:"http://jgospel.net/truth/spiritual-formation/%E5%B1%9E%E7%81%B5%E6%93%8D%E7%BB%83-%E8%B0%A6%E5%8D%91%E7%9B%AE%E5%BD%95.c88101.aspx"
  course.populate
  course = category.courses.find_or_create_by author:author, name:"属天的医治",   source_url:"http://jgospel.net/truth/bible-study/%E5%B1%9E%E5%A4%A9%E7%9A%84%E5%8C%BB%E6%B2%BB-%E5%89%8D%E8%A8%80.c88000.aspx"
  course.populate
  course = category.courses.find_or_create_by author:author, name:"等候神",      source_url:"http://jgospel.net/truth/spiritual-formation/%E7%AD%89%E5%80%99%E7%A5%9E-%E6%85%95%E5%AE%89%E5%BE%97%E7%83%88-%E5%BA%8F-%E8%A8%80.c88068.aspx"
  course.populate
  course = category.courses.find_or_create_by author:author, name:"灵命的呼吸",   source_url:"http://jgospel.net/truth/spiritual-formation/%E5%B1%9E%E7%81%B5%E6%93%8D%E7%BB%83-%E9%9D%88%E5%91%BD%E7%9A%84%E5%91%BC%E5%90%B8-1-%E6%85%95%E5%AE%89%E5%BE%97%E7%83%88.c88120.aspx", image_url: "http://book.cczone.org/cover/w168/169-1418198114.jpg"

  course.populate

  course = category.courses.find_or_create_by name:"基督徒与圣灵",   source_url:"http://jgospel.net/truth/bible-study/%E5%B1%9E%E7%81%B5%E6%93%8D%E7%BB%83-%E4%BD%A0%E5%BF%85%E5%BE%97%E5%88%B0%E8%83%BD%E5%8A%9B-1.c87959.aspx"
  course.populate
  
  course = category.courses.find_or_create_by name:"委身于神"
  course.source_url = "http://jgospel.net/truth/spiritual-formation/%E5%A7%94%E8%BA%AB%E4%BA%8E%E7%A5%9E-%E7%AC%AC1%E5%8D%95%E5%85%83-%E8%A1%8C%E5%9C%A8%E5%9C%A3%E7%81%B5%E4%B8%AD.c88124.aspx"
  course.populate
  course.source_url = "http://jgospel.net/truth/spiritual-formation/%E5%A7%94%E8%BA%AB%E4%BA%8E%E7%A5%9E-%E7%AC%AC2%E5%8D%95%E5%85%83-%E5%85%A8%E7%84%B6%E5%A7%94%E8%BA%AB%E4%B8%8E%E7%A5%9E.c88129.aspx"
  course.populate
  course.source_url = "http://jgospel.net/truth/spiritual-formation/%E5%A7%94%E8%BA%AB%E4%BA%8E%E7%A5%9E-%E7%AC%AC3%E5%8D%95%E5%85%83-%E8%AE%B2%E8%BF%B0%E7%94%9F%E5%91%BD%E7%9A%84%E8%AF%9D%E8%AF%AD.c88137.aspx" 
  course.populate
  course.source_url = "http://jgospel.net/truth/spiritual-formation/%E5%A7%94%E8%BA%AB%E4%BA%8E%E7%A5%9E-%E8%BF%9B%E5%85%A5%E7%A5%9E%E7%9A%84%E6%B8%85%E6%B3%89-%E4%BD%95%E8%B0%93%E8%BF%9B%E5%85%A5%E7%A5%9E%E7%9A%84%E6%B8%85%E6%B3%89.c88147.aspx"
  course.populate
  course.source_url = "http://jgospel.net/truth/bible-study/%E5%A7%94%E8%BA%AB%E4%BA%8E%E7%A5%9E-%E7%AC%AC5%E5%8D%95%E5%85%83-%E8%BF%88%E5%90%91%E6%A0%87%E7%AB%BF.c88151.aspx" 
  course.populate

  author   = Author.find_or_create_by  name: "宾路易", english_name: "Jessie Penn-Lewis"
  course = category.courses.find_or_create_by name:"祷告",   source_url:"http://www.cclw.net/other/binluyi/2/htm/list.html"
  course.populate
  course = category.courses.find_or_create_by name:"认识圣灵的工作",   source_url:"http://www.cclw.net/other/binluyi/renshishenling.html"
 # course.populate
  course = category.courses.find_or_create_by name:"众圣徒的争战",   source_url:"http://www.cclw.net/other/binluyi/zstdzz/index.html"
  course.populate



  course = category.courses.find_or_create_by name:"内在生活短篇", source_url:"http://1"
  course.populate


category = Category.find_or_create_by name: "先知启示"
  author   = Author.find_or_create_by  name: "雷克.乔纳", english_name: "Rick Joyner"

  course = category.courses.find_or_create_by author:author, name:"地狱大军",  english_name:"Final Quest", source_url:"http://jgospel.net/truth/bible-study/%E5%9C%B0%E7%8B%B1%E5%A4%A7%E5%86%9B-the-hordes-of-hell-are-marching-%E5%BC%95%E8%A8%80.c96078.aspx"
  course.populate

  course = category.courses.find_or_create_by author:author, name:"末日的呼召",english_name:"The Call",     source_url:"http://jgospel.net/truth/bible-study/%E6%9C%AB%E6%97%A5%E7%9A%84%E5%91%BC%E5%8F%AC-%E7%AC%AC%E4%B8%80%E7%AB%A0-%E8%8D%A3%E8%80%80.c96840.aspx"
  course.populate

category = Category.find_or_create_by name: "门徒培训"
  author   = Author.find_or_create_by  name: "理德夫妇", english_name: "Jerry & Nancy Reed"
  course = category.courses.find_or_create_by author:author, name:"門徒培训",     source_url:"http://jgospel.net/truth/bible-study/%E9%97%A8%E5%BE%92%E5%9F%B9%E8%AE%AD-%E5%9F%B9%E8%AE%AD%E8%80%85%E6%8C%87%E5%8D%97.c86974.aspx"
  course.populate

  course = category.courses.find_or_create_by name:"一对一栽培训练",     source_url:"http://jgospel.net/truth/bible-study/%E4%B8%80%E5%AF%B9%E4%B8%80%E6%A0%BD%E5%9F%B9%E8%AE%AD%E7%BB%83-%E7%AC%AC%E4%B8%80%E7%AB%A0-%E8%AE%A4%E8%AF%86%E8%80%B6%E7%A8%A3%E5%9F%BA%E7%9D%A3.c87012.aspx"
  course.populate

category = Category.find_or_create_by name: "见证传记"
  author   = Author.find_or_create_by  name: "梅塔利", english_name: "Mel Cari"
  course = category.courses.find_or_create_by author:author, name:"灵风吹来",     english_name:"Like a Mighty Wind", source_url:"http://jgospel.net/entertainment/books/%E6%A2%85%E5%A1%94%E5%88%A9%E8%91%97-%E7%81%B5%E9%A3%8E%E5%90%B9%E6%9D%A5-like-a-mighty-wind.c97688.aspx"
  course.populate
  
  author   = Author.find_or_create_by  name: "荣耀秀", english_name: "Pearl G. Young"
  course = category.courses.find_or_create_by author:author, name:"我在这里，请差遣我 （荣教士自传）", source_url:"http://www.360doc.com/content/14/1025/13/19250052_419709623.shtml"
  course.populate
  
  course = category.courses.find_or_create_by name:"荣耀的光辉—罗炳森师母传", source_url:"http://pilgrimsseeing.blogspot.com/p/blog-page.html"
  course.populate
  
  author   = Author.find_or_create_by  name: "葛朗蒂", english_name: ""
  course = category.courses.find_or_create_by author:author, name:"灵命深处 — 宾路易师母传记",  source_url:"http://www.cclw.net/other/binluyi/1/htm/list.html"
debugger
  course.populate
  
#
  

category = Category.find_or_create_by name: "圣经提要"
  course = category.courses.find_or_create_by name:"创世记"
  course.source_url = "http://jgospel.net/truth/bible-study/%E5%9C%A3%E7%BB%8F%E6%8F%90%E8%A6%81-%E5%88%9B%E4%B8%96%E8%AE%B0%E6%8F%90%E8%A6%81.c87529.aspx"
  course.save and course.populate #part 1
  course.source_url = "http://jgospel.net/truth/bible-study/%E5%9C%A3%E7%BB%8F%E6%8F%90%E8%A6%81-%E5%88%9B%E4%B8%96%E8%AE%B0%E7%BB%BC%E5%90%88%E7%81%B5%E8%AE%AD%E8%A6%81%E4%B9%89.c87579.aspx"
  course.save and course.populate #part 2

  course = category.courses.find_or_create_by  name:"馬太福音",  source_url:"http://jgospel.net/truth/bible-study/%E9%A6%AC%E5%A4%AA%E7%A6%8F%E9%9F%B3%E6%8F%90%E8%A6%81.c87339.aspx"
  course.populate
  course = category.courses.find_or_create_by  name:"馬可福音",  source_url:"http://jgospel.net/truth/bible-study/%E5%9C%A3%E7%BB%8F%E5%A0%A4%E8%A6%81-%E9%A6%AC%E5%8F%AF%E7%A6%8F%E9%9F%B3%E6%8F%90%E8%A6%81.c87402.aspx"
  course.populate
  course = category.courses.find_or_create_by  name:"路加福音",  source_url:"http://jgospel.net/truth/bible-study/%E5%9C%A3%E7%BB%8F%E6%8F%90%E8%A6%81-%E8%B7%AF%E5%8A%A0%E7%A6%8F%E9%9F%B3%E6%8F%90%E8%A6%81.c87483.aspx"
  course.populate
  course = category.courses.find_or_create_by  name:"约翰福音",  source_url:"http://jgospel.net/truth/bible-study/%E5%9C%A3%E7%BB%8F%E6%8F%90%E8%A6%81-%E7%BA%A6%E7%BF%B0%E7%A6%8F%E9%9F%B3%E6%8F%90%E8%A6%81.c87507.aspx"
  course.populate
  course = category.courses.find_or_create_by  name:"使徒行传",  source_url:"http://jgospel.net/truth/bible-study/%E6%95%99%E6%9C%83%E7%9A%84%E6%A0%B9%E5%9F%BA-%E4%BD%BF%E5%BE%92%E8%A1%8C%E4%BC%A0-%E5%BC%95%E8%A8%80.c87313.aspx"
  course.populate


category = Category.find_or_create_by name: "圣经要義"
  author   = Author.find_or_create_by  name: "黃共明"
  course = category.courses.find_or_create_by author:author, name:"約翰福音要義",  source_url:"http://jgospel.net/truth/bible-study/%E7%B4%84%E7%BF%B0%E7%A6%8F%E9%9F%B3%E8%A6%81%E7%BE%A9.c87700.aspx"
  course.populate

  course = category.courses.find_or_create_by author:author, name:"启示录要義",  source_url:"http://www.cclw.net/Bible/qslyy/index.html"
  #course.populate

  #course = category.courses.find_or_create_by author:author, name:"但以理书要义",  source_url:"http://zhsw.org/123/z/cjzh/nr/27-%E4%BD%86%E4%BB%A5%E7%90%86%E4%B9%A6%E6%9F%A5%E7%BB%8F%E8%B5%84%E6%96%99%E6%80%BB%E6%B1%87/4685-2541-5629-7602.html"
  #course.populate


#http://www.cctmweb.net/wangshang.htm


category = Category.find_or_create_by name: "甘坚信"
  author = Author.find_or_create_by  name: "甘坚信", english_name: "Kenneth E. Hagin"
  course = category.courses.find_or_create_by author:author, name:"如何被圣灵引导",  source_url:"http://www.360doc.com/content/11/0907/13/7536509_146441735.shtml"
  course.populate

  course = category.courses.find_or_create_by author:author, name:"信心祷告26讲",  source_url:"http://www.360doc.com/content/11/0907/13/7536509_146442406.shtml"
  course.populate


category = Category.find_or_create_by name: "更多"
  author = Author.find_or_create_by  name: "约翰·本仁", english_name: "John Bunyan"
  course = category.courses.find_or_create_by author:author, name:"天路历程",  source_url:"http://www.cclw.net/soul/tianlulichen/tllc.htm"
  course.populate


category = Category.find_or_create_by name: "更多"
  author = Author.find_or_create_by  name: "里程"
  #course = category.courses.find_or_create_by author:author, name:"游子吟",  source_url:"http://cclw.net/gospel/explore/youziyin/htm/index.htm"
  course = category.courses.find_or_create_by author:author, name:"游子吟",  source_url:"http://xybk.fuyin.tv/Books/OCM_Song_Wanderer/b5/Vol1/00.htm"
  #course = category.courses.find_or_create_by author:author, name:"游子吟简体",  source_url:"http://xybk.fuyin.tv/Books/OCM_Song_Wanderer/gb/Vol7/00.htm"
  
  #course.image_url = "http://cdn1.bigcommerce.com/server5600/cb9ee/products/3990/images/8402/l_c1_7r_for_banner__95021.1352857175.1280.1280.jpg?c=2"
  course.crawl



category = Category.find_or_create_by name: "更多"
  author = Author.find_or_create_by  name: "朱志山"
  course = category.courses.find_or_create_by author:author, name:"三十六课",  source_url:"http://www.lifechurchmissions.com/36L.aspx"
  course.crawl


category = Category.find_or_create_by name: "更多"
  author = Author.find_or_create_by  name: "朱志山"
  course = category.courses.find_or_create_by author:author, name:"罗马书",  source_url:"http://www.lifechurchmissions.com/TheMessages.aspx?LinkNo=199"
  course.crawl



category = Category.find_or_create_by name: "福音真理"
  author = Author.find_or_create_by  name: "张郁岚"
  #course = category.courses.find_or_create_by author:author, name:"到底有没有神？",  source_url:"http://www.cclw.net/gospel/explore/rszl/Truth/htm/list.htm"
  #course.crawl
  course = category.courses.find_or_create_by author:author, name:"圣经是神默示的吗？",  source_url:"http://www.cclw.net/gospel/explore/rszl/Bible/htm/list.htm"
  course.crawl
  course = category.courses.find_or_create_by author:author, name:"耶稣是神的儿子吗？",  source_url:"http://www.cclw.net/gospel/explore/rszl/Jesus/htm/list.html"
  course.crawl

  category = Category.find_or_create_by name: "福音真理"
  course = category.courses.find_or_create_by name:"圣经故事广播剧",  source_url:"http://cclw.net/Bible/BibleRadioPlay/BibleRadioPlay.htm"
  course.crawl

=end
