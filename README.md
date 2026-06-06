# Barbearia API

API Ruby on Rails com MongoDB.

## Rodando com Docker

Requisitos:

- Docker
- Docker Compose

Suba a API e o MongoDB:

```sh
docker compose up --build
```

A API ficara disponivel em:

```text
http://localhost:3000
```

Para rodar em segundo plano:

```sh
docker compose up --build -d
```

Para ver os logs:

```sh
docker compose logs -f api
```

Para parar os containers:

```sh
docker compose down
```

Para parar e remover tambem os dados do MongoDB:

```sh
docker compose down -v
```

## Comandos uteis

Executar comandos Rails dentro do container:

```sh
docker compose run --rm api ./bin/rails routes
```

Abrir um console Rails:

```sh
docker compose run --rm api ./bin/rails console
```

Rodar os testes:

```sh
docker compose run --rm -e RAILS_ENV=test -e MONGODB_DATABASE=barbearia_api_test api ./bin/rails test
```

## Configuracao do MongoDB

O `docker-compose.yml` configura automaticamente a API para acessar o MongoDB em `mongo:27017`.

As variaveis usadas pela aplicacao sao:

- `MONGODB_HOST`: host e porta do MongoDB. Padrao local: `localhost:27017`.
- `MONGODB_DATABASE`: nome do banco usado pelo Rails.
