require "test_helper"

module Api
  module V1
    class AgendamentosControllerTest < ActionDispatch::IntegrationTest
      setup do
        Agendamento.delete_all

        @agendamento = Agendamento.create!(
          nome: "Cliente Teste",
          email: "cliente@example.com",
          data: Date.current,
          horario: "10:00",
          servico_id: "servico-1",
          status: "CONFIRMADO"
        )

        @agendamento_atendido = Agendamento.create!(
          nome: "Cliente Atendido",
          email: "atendido@example.com",
          data: Date.current + 1,
          horario: "11:00",
          servico_id: "servico-2",
          status: "ATENDIDO"
        )

        @agendamento_ausente = Agendamento.create!(
          nome: "Cliente Ausente",
          email: "ausente@example.com",
          data: Date.current + 2,
          horario: "12:00",
          servico_id: "servico-3",
          status: "AUSENTE"
        )
      end

      test "lista todos os agendamentos quando filtro for TODOS na rota dedicada" do
        get "/api/v1/agendamentos/status/TODOS"

        assert_response :success

        body = JSON.parse(response.body)
        assert_equal 3, body.size
      end

      test "lista apenas agendamentos pendentes na rota dedicada" do
        get "/api/v1/agendamentos/status/PENDENTES"

        assert_response :success

        body = JSON.parse(response.body)
        assert_equal 1, body.size
        assert_equal @agendamento.id.to_s, body.first["id"].to_s
        assert_equal "CONFIRMADO", body.first["status"]
      end

      test "lista apenas agendamentos atendidos pela query string" do
        get api_v1_agendamentos_url(status: "ATENDIDOS")

        assert_response :success

        body = JSON.parse(response.body)
        assert_equal 1, body.size
        assert_equal @agendamento_atendido.id.to_s, body.first["id"].to_s
        assert_equal "ATENDIDO", body.first["status"]
      end

      test "lista apenas agendamentos ausentes na rota dedicada" do
        get "/api/v1/agendamentos/status/AUSENTES"

        assert_response :success

        body = JSON.parse(response.body)
        assert_equal 1, body.size
        assert_equal @agendamento_ausente.id.to_s, body.first["id"].to_s
        assert_equal "AUSENTE", body.first["status"]
      end

      test "retorna erro para filtro invalido" do
        get "/api/v1/agendamentos/status/CANCELADOS"

        assert_response :unprocessable_entity

        body = JSON.parse(response.body)
        assert_includes body["errors"].first, "Filtro de status inválido"
      end

      test "atualiza status para ATENDIDO" do
        patch api_v1_agendamento_url(@agendamento), params: {
          agendamento: { status: "ATENDIDO" }
        }, as: :json

        assert_response :success
        assert_equal "ATENDIDO", @agendamento.reload.status
      end

      test "atualiza status para AUSENTE" do
        patch api_v1_agendamento_url(@agendamento), params: {
          agendamento: { status: "AUSENTE" }
        }, as: :json

        assert_response :success
        assert_equal "AUSENTE", @agendamento.reload.status
      end

      test "rejeita status invalido" do
        patch api_v1_agendamento_url(@agendamento), params: {
          agendamento: { status: "CANCELADO" }
        }, as: :json

        assert_response :unprocessable_entity
        assert_equal "CONFIRMADO", @agendamento.reload.status
      end
    end
  end
end
