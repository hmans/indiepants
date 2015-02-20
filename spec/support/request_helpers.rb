module RequestHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def expected_document_json(document)
    {
      url: document.url,
      uid: document.uid,
      type: document.type,
      title: document.title,
      html: document.html,
      data: document.data,
      tags: document.tags,
      published_at: document.published_at.iso8601
    }.with_indifferent_access
  end
end
