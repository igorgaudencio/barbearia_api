class Agendamento
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS_VALIDOS = %w[CONFIRMADO ATENDIDO AUSENTE].freeze

  field :nome,       type: String
  field :email,      type: String
  field :data,       type: Date
  field :horario,    type: String
  field :status,     type: String, default: "CONFIRMADO"
  field :servico_id, type: String
  field :servico_nome,  type: String
  field :servico_preco, type: Float

  validates :nome,       presence: true
  validates :email,      presence: true
  validates :data,       presence: true
  validates :horario,    presence: true
  validates :servico_id, presence: true
  validates :status,     inclusion: { in: STATUS_VALIDOS }
end
