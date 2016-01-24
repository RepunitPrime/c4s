# This migrate script is used to add  Files to the articles table using PaperClip method
class AddAttachFileToArticles < ActiveRecord::Migration
  def self.up
    add_attachment :article_attachments, :attach_file
  end

  def self.down
    remove_attachment :article_attachments, :attach_file
  end
end
