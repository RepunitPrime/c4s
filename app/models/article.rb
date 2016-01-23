class Article < ActiveRecord::Base
  #Articles can have many comments
  has_many :comment
  belongs_to :user
  belongs_to :topic


  def self.search(search)
    # Title is for the above case, the OP incorrectly had 'name'
    where("title LIKE ? OR text LIKE ? OR Tags LIKE ?", "%#{search}%","%#{search}%","%#{search}%")

  end

end
