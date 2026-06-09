class Promocao
  include Mongoid::Document
  include Mongoid::Timestamps

  field :dia_semana,   type: String  # "monday", "tuesday", etc
  field :data,         type: Date    # data exata com desconto
  field :desconto,     type: Float, default: 10.0
  field :motivo,       type: String, default: "Baixo movimento na semana anterior"
  field :ativo,        type: Boolean, default: true

  index({ data: 1 }, { unique: true })
end
