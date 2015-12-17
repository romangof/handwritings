class Handwriting

  attr_reader(
    :id, :title, :created, :modified,
    :rate_neatness,
    :rate_cursivity,
    :rate_emebellishment,
    :rate_char_widht )

  def initialize(hash)
    @id = hash["id"]
    @title = hash["title"]
    @created = hash["date_created"]
    @modified = hash["date_modified"]
    @rate_neatness = hash["rating_neatness"]
    @rate_cursivity = hash["rating_cursivity"]
    @rate_emebellishment = hash["rating_embellishment"]
    @rate_char_widht = hash["rating_character_width"]
  end
  
end