json.total current_site.documents.count
json.documents do
  json.array! @documents do |document|
    json.partial! document
  end
end
