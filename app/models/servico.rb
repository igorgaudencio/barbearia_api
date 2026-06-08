class Servico
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nome,  type: String
  field :preco, type: Float
  field :ativo, type: Boolean, default: true

  validates :nome,  presence: true
  validates :preco, presence: true, numericality: { greater_than: 0 }
end
