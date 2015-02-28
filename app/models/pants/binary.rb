class Pants::Binary < ActiveRecord::Base
  validates :payload,
    presence: true
end
