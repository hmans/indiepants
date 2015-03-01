json.(document,
  :url, :uid, :type, :title,
  :html, :data, :tags, :meta,
  :previous_paths)

json.published_at document.published_at.iso8601
