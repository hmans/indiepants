module ApplicationHelper
  def clean_html(source)
    Formatter.new(source).sanitize.to_s.html_safe
  end

  def render_post_form(form)
    post = form.object
    if post.type.present?
      render "#{form.object.type.gsub('.', '/').tableize}/form", form: form, post: form.object
    else
      content_tag(:p) { "Post can't be edited." }
    end
  rescue ActionView::MissingTemplate
    content_tag(:p) { "No form found for this post type." }
  end
end
