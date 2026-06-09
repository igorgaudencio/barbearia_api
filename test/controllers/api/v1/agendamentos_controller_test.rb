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
