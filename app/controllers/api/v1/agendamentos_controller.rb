module Api
  module V1
    class AgendamentosController < ApplicationController

      def index
        agendamentos = agendamentos_por_status
        render json: agendamentos
      rescue ArgumentError => e
        render json: { errors: [e.message] }, status: :unprocessable_entity
      end

      def by_status
        agendamentos = Agendamento.filtrar_por_status(params[:status])
        render json: agendamentos
      rescue ArgumentError => e
        render json: { errors: [e.message] }, status: :unprocessable_entity
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

      def update
        agendamento = Agendamento.find(params[:id])

        if agendamento.update(status_params)
          render json: agendamento
        else
          render json: { errors: agendamento.errors.full_messages }, status: :unprocessable_entity
        end
      rescue Mongoid::Errors::DocumentNotFound
        render json: { errors: ["Agendamento não encontrado"] }, status: :not_found
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

      def status_params
        params.require(:agendamento).permit(:status)
      end

      def agendamentos_por_status
        return Agendamento.ordenados if params[:status].blank?

        Agendamento.filtrar_por_status(params[:status])
      end
    end
  end
end
