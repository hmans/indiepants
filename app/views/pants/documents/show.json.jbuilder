json.(@document,
  :url, :type, :title,
  :html, :data, :tags,
  :previous_urls)
  
json.published_at @document.published_at.iso8601
