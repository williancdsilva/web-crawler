class Quote
  include Mongoid::Document
  field :quote, type: String
  #field :tags, type: String
  
  # como usar arrays?
  field :tags, type: Array

  belongs_to :author
end
