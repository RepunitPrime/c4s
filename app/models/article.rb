class Article < ActiveRecord::Base
  #Articles can have many comments
  acts_as_votable
  has_many :comment, :dependent => :destroy
  has_many :article_attachments, :dependent => :destroy
  belongs_to :user
  belongs_to :topic


  validates :title, :presence => true, :uniqueness => false, :length => { :in => 0..60 }

  def self.search(search)
    # Title is for the above case, the OP incorrectly had 'name'
    where("title LIKE ? OR text LIKE ? OR Tags LIKE ?", "%#{search}%","%#{search}%","%#{search}%")
  end

  def self.searchByTag(search)
    # Title is for the above case, the OP incorrectly had 'name'
    where("tags_search LIKE ?","%#{search}%")
  end

  def self.searchByTopic(search)
    # Title is for the above case, the OP incorrectly had 'name'
    topic = Topic.find_by_topic_name(search)
    where("topic_id = "+ topic.id.to_s)
  end

  def self.selectByTopic()
    # Title is for the above case, the OP incorrectly had 'name'
    Topic.joins(:articles).select("topics.topic_name, count(articles.topic_id) as count").group("topics.topic_name")
  end

end
