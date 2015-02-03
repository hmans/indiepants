class User < ActiveRecord::Base
  has_many :posts,
    foreign_key: "host",
    primary_key: "host"
end
