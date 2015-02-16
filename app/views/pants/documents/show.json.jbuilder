json.(@document,
  :url, :type, :title,
  :html, :data, :tags)
  
json.published_at @document.published_at.iso8601
