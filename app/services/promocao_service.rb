class PromocaoService

  DIAS_SEMANA = %w[monday tuesday wednesday thursday friday saturday sunday]
  DESCONTO_PADRAO = 10.0
  OCUPACAO_MAXIMA_PROMOCIONAL = 0.5

  def self.calcular_e_salvar(referencia = Date.current)
    semana_passada = referencia.beginning_of_week(:monday) - 7

    DIAS_SEMANA.each do |dia|
      data_passada = data_do_dia(semana_passada, dia)
      next if data_passada >= Date.current

      atualizar_para_data(data_passada + 7)
    end
  end

  def self.atualizar_para_data(data)
    data = data.to_date
    data_base = data - 7

    return if data_base >= Date.current

    dia = data_base.strftime("%A").downcase
    config = HorarioConfig.find_by(dia_semana: dia, ativo: true)

    unless config&.horarios&.any?
      Promocao.where(data: data).update_all(ativo: false)
      return
    end

    total_horarios = config.horarios.count
    horarios_ocupados = Agendamento.where(data: data_base, :horario.in => config.horarios).pluck(:horario).uniq.count
    ocupacao = horarios_ocupados.to_f / total_horarios

    if ocupacao < OCUPACAO_MAXIMA_PROMOCIONAL
      promocao = Promocao.find_or_initialize_by(data: data)
      promocao.dia_semana = data.strftime("%A").downcase
      promocao.desconto = DESCONTO_PADRAO
      promocao.motivo = "Baixo movimento em #{data_base.iso8601}"
      promocao.ativo = true
      promocao.save!
    else
      Promocao.where(data: data).update_all(ativo: false)
    end
  end

  def self.desconto_para(data)
    atualizar_para_data(data)
    promo = Promocao.find_by(data: data, ativo: true)
    promo&.desconto || 0
  end

  private

  def self.data_do_dia(inicio_semana, dia)
    offset = DIAS_SEMANA.index(dia)
    inicio_semana + offset
  end
end
