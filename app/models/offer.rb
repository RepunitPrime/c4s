class Offer < ActiveRecord::Base

  belongs_to :user
  has_many :offer_comments

  has_attached_file :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates :image,
            attachment_size: { less_than: 5.megabytes }

  # Method used to Search for offers
  def self.searchOffersForSale(search)
    where("(title LIKE ? OR detail LIKE ? OR tags LIKE ?) AND forSale = 'sale'", "%#{search}%","%#{search}%","%#{search}%")
  end

  # Method used to Search for offers
  def self.searchOffersForExchange(search)
    where("(title LIKE ? OR detail LIKE ? OR tags LIKE ? OR bookexpected LIKE ? ) AND forSale = 'exchange'", "%#{search}%","%#{search}%","%#{search}%","%#{search}%")
  end

  def self.searchByTagForSale(search)
    # Title is for the above case, the OP incorrectly had 'name'
    where("tags_search LIKE ? AND forSale = 'sale'","%#{search}%")
  end

  def self.searchByTagForExchange(search)
    # Title is for the above case, the OP incorrectly had 'name'
    where("tags_search LIKE ? AND forSale = 'exchange'","%#{search}%")
  end
  
end
