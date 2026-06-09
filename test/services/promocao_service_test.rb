require "test_helper"

class PromocaoServiceTest < ActiveSupport::TestCase
  setup do
    Agendamento.delete_all
    HorarioConfig.delete_all
    Promocao.delete_all
  end

  test "cria desconto para o mesmo dia da semana seguinte quando ocupacao fica abaixo de cinquenta por cento" do
    data_promocional = Date.current.beginning_of_week(:monday)
    data_base = data_promocional - 7

    HorarioConfig.create!(
      dia_semana: data_base.strftime("%A").downcase,
      horarios: ["09:00", "10:00", "11:00", "12:00"],
      ativo: true
    )
    Agendamento.create!(
      nome: "Cliente",
      email: "cliente@email.com",
      data: data_base,
      horario: "09:00",
      servico_id: "servico-1"
    )

    assert_equal 10.0, PromocaoService.desconto_para(data_promocional)

    promocao = Promocao.where(data: data_promocional).first
    assert promocao.ativo
    assert_equal "monday", promocao.dia_semana
  end

  test "nao cria desconto quando ocupacao chega a cinquenta por cento" do
    data_promocional = Date.current.beginning_of_week(:monday) + 1.day
    data_base = data_promocional - 7

    HorarioConfig.create!(
      dia_semana: data_base.strftime("%A").downcase,
      horarios: ["09:00", "10:00", "11:00", "12:00"],
      ativo: true
    )
    ["09:00", "10:00"].each do |horario|
      Agendamento.create!(
        nome: "Cliente",
        email: "#{horario.delete(":")}@email.com",
        data: data_base,
        horario: horario,
        servico_id: "servico-1"
      )
    end

    assert_equal 0, PromocaoService.desconto_para(data_promocional)
  end

  test "nao bloqueia consulta de desconto para datas alem da proxima semana" do
    data_futura = Date.current + 14.days

    assert_equal 0, PromocaoService.desconto_para(data_futura)
    assert_nil Promocao.where(data: data_futura).first
  end
end
