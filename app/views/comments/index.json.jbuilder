json.array!(@comments) do |comment|
  json.extract! comment, :id, :text, :score, :author
  json.url location_comment_url(@location, comment, format: :json)
end
