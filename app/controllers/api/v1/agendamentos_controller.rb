module Api
  module V1
    class AgendamentosController < ApplicationController

      def index
        agendamentos = Agendamento.all.order_by(data: :asc)
        render json: agendamentos
      end

      def create
        agendamento = Agendamento.new(agendamento_params)
        if agendamento.save
          render json: agendamento, status: :created
        else
          render json: { errors: agendamento.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        agendamento = Agendamento.find(params[:id])
        agendamento.destroy
        render json: { message: "Agendamento cancelado" }
      end

      private

      def agendamento_params
        params.require(:agendamento).permit(:nome, :email, :data, :horario)
      end
    end
  end
end

