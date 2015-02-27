module ApplicationHelper
  def clean_html(source)
    Formatter.new(source).sanitize.to_s.html_safe
  end

  def render_document_form(form)
    document = form.object
    if document.type.present?
      render "#{form.object.type.gsub('.', '/').tableize}/form", form: form, document: form.object
    else
      content_tag(:p) { "Post can't be edited." }
    end
  rescue ActionView::MissingTemplate
    content_tag(:p) { "No form found for this document type." }
  end

  def show_custom_css?
    @serve_custom_css && current_site.try { custom_css.present? }
  end
end
