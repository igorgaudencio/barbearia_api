module Api
  module V1
    class HorariosController < ApplicationController

      def index
        configs = HorarioConfig.all
        render json: configs
      end

      def create
        config = HorarioConfig.find_or_initialize_by(dia_semana: params[:dia_semana])
        config.horarios = params[:horarios] || []
        if config.save
          render json: config, status: :created
        else
          render json: { errors: config.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        config = HorarioConfig.find(params[:id])
        config.destroy
        render json: { message: "Configuração removida" }
      end
    end
  end
end

