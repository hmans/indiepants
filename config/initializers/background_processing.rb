if Rails.env.production?
  Background.mode = :threads
end
