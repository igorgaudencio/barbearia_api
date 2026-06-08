module Api
  module V1
    class AgendamentosController < ApplicationController

      def index
        agendamentos = Agendamento.all.order_by(data: :asc)
        render json: agendamentos
      end

      def create
        servico = Servico.find(params[:agendamento][:servico_id])

        agendamento = Agendamento.new(agendamento_params)
        agendamento.servico_nome  = servico.nome
        agendamento.servico_preco = servico.preco

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

      private

      def agendamento_params
        params.require(:agendamento).permit(:nome, :email, :data, :horario, :servico_id)
      end
    end
  end
end
