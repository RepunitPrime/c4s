class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :post
end
