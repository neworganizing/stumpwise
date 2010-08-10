class ThemeAsset
  include MongoMapper::EmbeddedDocument
  plugin Joint
  attachment :file
  
  def url
    "/gridfs/#{file_id}/#{URI.encode(file_name)}"
  end
end