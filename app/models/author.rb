class Author
  include Mongoid::Document
  field :name, type: String
  field :about, type: String

  has_many :quotes, dependent: :destroy
end
