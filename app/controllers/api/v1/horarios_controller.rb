module Api
  module V1
    class HorariosController < ApplicationController
      before_action :authenticate_barbeiro!, only: [:create, :destroy]

      def index
        if params[:data].present?
          data       = Date.parse(params[:data])
          dia_semana = data.strftime("%A").downcase
          config     = HorarioConfig.find_by(dia_semana: dia_semana, ativo: true)

          return render json: { horarios: [], ocupados: [], disponiveis: [] } unless config

          ocupados    = Agendamento.where(data: data).pluck(:horario)
          hoje        = Date.today
          agora       = Time.now.strftime("%H:%M")

          disponiveis = config.horarios.reject do |h|
            ocupados.include?(h) ||
            (data == hoje && h <= agora)
          end

          render json: {
            dia_semana:  dia_semana,
            horarios:    config.horarios,
            ocupados:    ocupados,
            disponiveis: disponiveis
          }
        else
          configs = HorarioConfig.all
          render json: configs
        end
      end

      def create
        config = HorarioConfig.find_or_initialize_by(dia_semana: params[:dia_semana])
        config.horarios = params[:horarios] || []
        config.ativo    = params[:ativo].nil? ? true : params[:ativo]

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