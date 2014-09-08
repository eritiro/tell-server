json.array!(@versions) do |version|
  json.extract! version, :id, :name, :hipotesis, :blog_url
  json.url version_url(version, format: :json)
end
