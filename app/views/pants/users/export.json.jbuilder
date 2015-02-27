json.prettify!
json.user { json.partial! @user }
json.documents do
  json.array! @user.documents do |document|
    json.partial! document
  end
end
