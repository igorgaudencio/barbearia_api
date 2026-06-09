class Agendamento
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS_PENDENTE = "PENDENTE"
  STATUS_ATENDIDO = "ATENDIDO"
  STATUS_AUSENTE = "AUSENTE"
  STATUS_LEGADO_CONFIRMADO = "CONFIRMADO"
  STATUSES = [STATUS_PENDENTE, STATUS_ATENDIDO, STATUS_AUSENTE, STATUS_LEGADO_CONFIRMADO].freeze

  field :nome,          type: String
  field :email,         type: String
  field :data,          type: Date
  field :horario,       type: String
  field :status,        type: String, default: STATUS_PENDENTE
  field :servico_id,    type: String
  field :servico_nome,  type: String
  field :servico_preco, type: Float
  field :desconto,      type: Float, default: 0.0

  validates :nome,       presence: true
  validates :email,      presence: true
  validates :data,       presence: true
  validates :horario,    presence: true
  validates :servico_id, presence: true
  validates :status,     inclusion: { in: STATUSES }
end
