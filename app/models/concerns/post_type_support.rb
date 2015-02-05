module PostTypeSupport
  extend ActiveSupport::Concern

  # We want to use ActiveRecord's STI, but not with Ruby class names. This
  # is for two reasons:
  #
  # 1. We may be trading post data with Pants compatible systems that
  #    are not implemented in Ruby; so the contents of the `type` column
  #    should be plain and simple. We're going for `pants.post` instead
  #    of `Pants::Post`.
  #
  # 2. Posts received from other sites may have been created using a custom
  #    post class that is not available on _our_ system. Out of the box,
  #    this would cause STI to raise exceptions. Instead, our code will simply
  #    fall back to the `Post` class if the referenced class can't be found,
  #    which will still happily render the pre-rendered HTML that came with
  #    the post.
  #
  # It's a bit nasty, but it works. Hooray!
  #
  module ClassMethods
    def find_sti_class(name)
      klass = name.gsub('.', '/').classify
      klass.safe_constantize || Post
    end

    def sti_name
      self.to_s.underscore.gsub('/', '.')
    end
  end

  # Default _all_ post types to the same partial. Custom post type
  # classes are, of course, invited to override this.
  #
  def to_partial_path
    "posts/post"
  end
end
