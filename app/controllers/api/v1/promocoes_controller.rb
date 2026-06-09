module Api
  module V1
    class PromocoesController < ApplicationController

      # GET /api/v1/promocoes?data=2025-06-10
      # Retorna se aquela data tem desconto
      def show_by_data
        data     = Date.parse(params[:data])
        desconto = PromocaoService.desconto_para(data)

        render json: {
          data:     data.iso8601,
          desconto: desconto,
          ativo:    desconto > 0
        }
      end

      # POST /api/v1/promocoes/calcular (protegido, barbeiro dispara manualmente)
      def calcular
        authenticate_barbeiro!
        PromocaoService.calcular_e_salvar
        render json: { message: "Promoções calculadas com sucesso!" }
      end

      # GET /api/v1/promocoes (lista promoções ativas)
      def index
        promocoes = Promocao.where(ativo: true, :data.gte => Date.today).order_by(data: :asc)
        render json: promocoes
      end
    end
  end
end
