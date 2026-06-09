module Api
  module V1
    class AuthController < ApplicationController

      def login
        barbeiro = Barbeiro.where(email: params[:email]).first

        if barbeiro&.authenticate(params[:password])
          token = JWT.encode(
            { barbeiro_id: barbeiro.id.to_s, exp: 24.hours.from_now.to_i },
            Rails.application.secret_key_base
          )
          render json: { token: token, email: barbeiro.email }
        else
          render json: { error: "E-mail ou senha inválidos" }, status: :unauthorized
        end
      end

      def cadastro
        barbeiro = Barbeiro.new(email: params[:email])
        barbeiro.password = params[:password]

        if params[:password] != params[:password_confirmation]
          return render json: { error: "As senhas não coincidem" }, status: :unprocessable_entity
        end

        if barbeiro.save
          token = JWT.encode(
            { barbeiro_id: barbeiro.id.to_s, exp: 24.hours.from_now.to_i },
            Rails.application.secret_key_base
          )
          render json: { token: token, email: barbeiro.email }, status: :created
        else
          render json: { error: barbeiro.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

    end
  end
end
