class User < ActiveRecord::Base

  #Handle Password (Encryption, Decryption)
  attr_accessor :password
  before_save :encrypt_password
  after_save :clear_password

  # Validate Profile Pic
  validates :profile_pic,
            attachment_content_type: { content_type: /\Aimage\/.*\Z/ },
            attachment_size: { less_than: 5.megabytes }

  # Attach Profile Pic to User
  has_attached_file :profile_pic

  #Validate Username, email, password
  EMAIL_REGEX = /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true
  #Only on Create so other actions like update password attribute can be nil
  validates_length_of :password, :in => 6..20, :on => :create

  #Method to authenticate the username, password
  def self.authenticate(username_or_email, login_password)

    if  EMAIL_REGEX.match(username_or_email)
      user = User.find_by_email(username_or_email)
    else
      user = User.find_by_username(username_or_email)
    end

    if user && user.match_password(login_password)
      return user
    else
      return false
    end
  end

  #Method to check password length (used when updating user password)
  def self.check_password_validity(password)
    if(password.length >= 6 && password.length <= 20)
      return true
    end
    else
      return false
  end

  #Method to match password with encrypted password
  def match_password(login_password="")
    encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
  end

  #Method to encrypt password
  def encrypt_password
    unless password.blank?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  #Method to clear the password
  def clear_password
    self.password = nil
  end

end