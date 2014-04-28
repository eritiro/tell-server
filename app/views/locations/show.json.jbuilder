json.extract! @location, :id, :name, :address, :phone, :afip_req, :score
json.comments @location.comments do |comment|
  json.extract! comment, :text, :score
  json.created_at comment.created_at.to_i
  json.author comment.author, :id, :username, :image
end