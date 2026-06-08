module Api
  module V1
    class ServicosController < ApplicationController
      before_action :authenticate_barbeiro!, only: [:create, :update, :destroy]

      def index
        servicos = Servico.where(ativo: true)
        render json: servicos
      end

      def create
        servico = Servico.new(servico_params)
        if servico.save
          render json: servico, status: :created
        else
          render json: { errors: servico.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        servico = Servico.find(params[:id])
        if servico.update(servico_params)
          render json: servico
        else
          render json: { errors: servico.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        servico = Servico.find(params[:id])
        servico.update(ativo: false)
        render json: { message: "Serviço removido" }
      end

      private

      def servico_params
        params.require(:servico).permit(:nome, :preco, :ativo)
      end
    end
  end
end

