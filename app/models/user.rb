class User < ActiveRecord::Base

  #With this line you can make the user act as a voter
  acts_as_voter

  has_many :post
  has_many :comments
  has_many :ad_comments



  #Handle Password (Encryption, Decryption)

  attr_accessor :password, :activation_token, :reset_token
  before_save :encrypt_password
  after_save :clear_password
  before_create :create_activation_digest

  # Validate Profile Pic
  validates :profile_pic,
            attachment_content_type: { content_type: /\Aimage\/.*\Z/ },
            attachment_size: { less_than: 5.megabytes }
  validates_format_of :phone, with: /\A[0-9]{11}\Z/, :allow_blank => true, :on => :update, :message => 'Invalid. Enter a valid 11-digit Germany number'

  # Attach Profile Pic to User
  has_attached_file :profile_pic

  #Validate Username, email, password
  EMAIL_REGEX = /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/

  validates :name, :length => { :in => 0..100 }
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX, :length => { :in => 3..100 }
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

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end


  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end