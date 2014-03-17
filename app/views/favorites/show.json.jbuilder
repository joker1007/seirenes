json.extract! @favorite, :id, :pasokara_id, :user_id, :created_at
json.pasokara do
  json.extract! @favorite.pasokara, :id, :title, :thumbnail
end
