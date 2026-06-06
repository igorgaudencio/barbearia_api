class Barbeiro
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :password_digest, type: String

  validates :email, presence: true, uniqueness: true

  def password=(plain)
    self.password_digest = BCrypt::Password.create(plain)
  end

  def authenticate(plain)
    BCrypt::Password.new(password_digest) == plain
  end
end
