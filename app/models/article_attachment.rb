class ArticleAttachment < ActiveRecord::Base
  belongs_to :article

  has_attached_file :attach_file,
                    :path => ":rails_root/public/files/:id/:filename",
                    :url  => "/files/:id/:filename"

  validates_attachment_file_name :attach_file, :matches => [/txt\Z/,/ico\Z/,/log\Z/,/png\Z/, /jpe?g\Z/, /gif\Z/,/docx\Z/,/doc\Z/,/pdf\Z/]

  validates :attach_file,
            attachment_size: { less_than: 5.megabytes }


end
