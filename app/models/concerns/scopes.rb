concern :Scopes do
  included do
    scope :newest, -> { order("created_at DESC") }
    scope :recently_updated, -> { order("updated_at DESC") }
  end
end
