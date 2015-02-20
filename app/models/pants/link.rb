class Pants::Link < ActiveRecord::Base
  include Scopes

  belongs_to :source,
    polymorphic: true

  belongs_to :target,
    polymorphic: true

  scope :rel, ->(rel) { where("? = ANY(rels)", rel) }
  scope :no_rel, -> { where("array_length(rels, 1) = 0") }
end
