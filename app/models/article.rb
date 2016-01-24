class Article < ActiveRecord::Base
  #Articles can have many comments
  has_many :comments

end
