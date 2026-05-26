class Agendamento
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nome,    type: String
  field :email,   type: String
  field :data,    type: Date
  field :horario, type: String
  field :status,  type: String, default: "confirmado"

  validates :nome,    presence: true
  validates :email,   presence: true
  validates :data,    presence: true
  validates :horario, presence: true
end
