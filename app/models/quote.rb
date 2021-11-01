class Quote
  include Mongoid::Document
  field :quote, type: String
  field :tags, type: Array

  belongs_to :author
end
