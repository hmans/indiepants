class Pants::Link < ActiveRecord::Base
  include Scopes
  
  belongs_to :source,
    polymorphic: true

  belongs_to :target,
    polymorphic: true
end
