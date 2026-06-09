class Agendamento
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS_VALIDOS = %w[CONFIRMADO ATENDIDO AUSENTE].freeze
  FILTROS_STATUS = {
    "PENDENTES" => "CONFIRMADO",
    "TODOS" => nil,
    "ATENDIDOS" => "ATENDIDO",
    "AUSENTES" => "AUSENTE"
  }.freeze

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

  scope :ordenados, -> { order_by(data: :asc, horario: :asc) }

  def self.filtrar_por_status(filtro)
    filtro_normalizado = filtro.to_s.upcase

    unless FILTROS_STATUS.key?(filtro_normalizado)
      raise ArgumentError, "Filtro de status inválido. Use: #{FILTROS_STATUS.keys.join(', ')}"
    end

    status_banco = FILTROS_STATUS[filtro_normalizado]
    return ordenados if status_banco.nil?

    where(status: status_banco).ordenados
  end
end
