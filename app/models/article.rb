class Article < ActiveRecord::Base
  #Articles can have many comments
  has_many :comment
  belongs_to :user
  belongs_to :topic

end
