class HorarioConfig
  include Mongoid::Document
  include Mongoid::Timestamps

  field :dia_semana, type: String
  field :horarios,   type: Array,   default: []
  field :ativo,      type: Boolean, default: true

  validates :dia_semana, presence: true, uniqueness: true
end