concern :DocumentTypeSupport do
  # We want to use ActiveRecord's STI, but not with Ruby class names. This
  # is for two reasons:
  #
  # 1. We may be trading documents with Pants compatible systems that
  #    are not implemented in Ruby; so the contents of the `type` column
  #    should be plain and simple. We're going for `pants.post` instead
  #    of `Pants::Post`.
  #
  # 2. Documents received from other sites may have been created using a custom
  #    document class that is not available on _our_ system. Out of the box,
  #    this would cause STI to raise exceptions. Instead, our code will simply
  #    fall back to the `Document` class if the referenced class can't be found,
  #    which will still happily render the pre-rendered HTML that came with
  #    the post.
  #
  # It's a bit nasty, but it works. Hooray!
  #
  class_methods do
    def find_sti_class(name)
      klass = name.gsub('.', '/').classify.safe_constantize

      # Default to Post if class not found, or not a subclass of Post.
      if klass.nil? || !(klass <= Pants::Document)
        klass = Pants::Document
      end

      klass
    end

    def sti_name
      self.to_s.underscore.gsub('/', '.')
    end
  end

  # Default _all_ post types to the same partial. Custom post type
  # classes are, of course, invited to override this.
  #
  def to_partial_path
    "documents/document"
  end
end
