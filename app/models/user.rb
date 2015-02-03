class User < ActiveRecord::Base
  has_secure_password
  
  has_many :posts,
    foreign_key: "host",
    primary_key: "host"

  scope :local, -> { where(local: true) }
  scope :remote, -> { where(local: false) }

  def remote?
    !local?
  end
end
