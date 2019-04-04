class User < ApplicationRecord
  validates :user_name, :session_token, presence: true, uniqueness: true 
  validates :password, length: {minimum: 6, allow_nil: true} 
  validates :password_digest, presence: true

  after_initialize :ensure_session_token

  attr_reader :password  
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    # Convert string -> BCrypt Password
    BCrypt::Password.new(self.password_digest).is_password?(password)
    # why not just compare strings this way?
    # self.password_digest == BCrypt::Password.create(password)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
    # why not save this to db here with self.save! ?
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    if user && user.is_password?(password)
      return user
    end
    nil
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    self.session_token
  end

end
