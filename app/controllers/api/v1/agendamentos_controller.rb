module Api
  module V1
    class AgendamentosController < ApplicationController

      def index
        status = params[:status].presence || Agendamento::STATUS_PENDENTE
        status_permitidos = [
          Agendamento::STATUS_PENDENTE,
          Agendamento::STATUS_ATENDIDO,
          Agendamento::STATUS_AUSENTE
        ]

        unless status_permitidos.include?(status)
          return render json: { errors: ["Status inválido"] }, status: :unprocessable_entity
        end

        agendamentos = Agendamento.where(status: status).order_by(data: :asc)
        render json: agendamentos
      end

      def create
        servico = Servico.find(params[:agendamento][:servico_id])
        data    = Date.parse(params[:agendamento][:data])

        desconto       = PromocaoService.desconto_para(data)
        preco_final    = servico.preco * (1 - desconto / 100.0)

        agendamento = Agendamento.new(agendamento_params)
        agendamento.servico_nome  = servico.nome
        agendamento.servico_preco = preco_final.round(2)
        agendamento.desconto      = desconto

        if agendamento.save
          render json: agendamento, status: :created
        else
          render json: { errors: agendamento.errors.full_messages }, status: :unprocessable_entity
        end
      rescue Mongoid::Errors::DocumentNotFound
        render json: { errors: ["Serviço não encontrado"] }, status: :unprocessable_entity
      end

      def destroy
        agendamento = Agendamento.find(params[:id])
        agendamento.destroy
        render json: { message: "Agendamento cancelado" }
      end

      def update
        agendamento = Agendamento.find(params[:id])

        if agendamento.update(status_params)
          render json: agendamento
        else
          render json: { errors: agendamento.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def agendamento_params
        params.require(:agendamento).permit(:nome, :email, :data, :horario, :servico_id)
      end

      def status_params
        params.require(:agendamento).permit(:status)
      end
    end
  end
end
