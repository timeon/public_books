class Lesson < ActiveRecord::Base
  include RankedModel
  ranks :row_order,  :with_same => :course_id
  default_scope { order('row_order') }

  has_attached_file :image, styles:{medium: '300x300>', thumb: '100x100>' , icon: '50x50>' }, default_url: '/assets/:style/missing_image.png'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/, size:{in: 0..10.megabytes }

  belongs_to :course
  belongs_to :author

  before_save :process_body
  
  self.per_page = 20
  
  def load_body
    self.body = IO.read(file_path) if self.is_file  
  end

  def file_path
    Rails.root.join('app', 'views', 'lessons', id.to_s + ".html")
  end
  
  def to_s
    name
  end    

  def prev
    course.lessons.where("row_order < ?", row_order).order(row_order: :asc).last
  end

  def next
    course.lessons.where(" row_order > ?", row_order).order(row_order: :asc).first
  end

  def add_line
    if body
      self.body = self.body.gsub("</br></br>", "<br><br>\n\n")
      self.body = self.body.gsub("\n\n\n\n", "\n\n")
      self.body = self.body.gsub("\n\n\r\n\r\n", "\n\n")
      self.save
    end   
  end

  
  protected
  def process_body
    self.body = "" if is_file  
    
    if body
      #lines = body.gsub("<br>", "\n").gsub("<p>", "\n").gsub("</p>", "\n").gsub("</br>", "\n").gsub("\r", "").split("\n")
      #course.process_lines(self, lines)
    end   
  end
end

