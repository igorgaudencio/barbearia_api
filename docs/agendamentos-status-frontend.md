# Filtro de agendamentos por status

## Objetivo

Permitir que o frontend liste agendamentos filtrando por quatro opções de interface:

- `PENDENTES`
- `TODOS`
- `ATENDIDOS`
- `AUSENTES`

## Regra de mapeamento

O backend persiste os seguintes status no banco:

- `CONFIRMADO`
- `ATENDIDO`
- `AUSENTE`

Mapeamento entre filtro da UI e valor real no banco:

| Filtro enviado pelo frontend | Status consultado no banco |
| --- | --- |
| `PENDENTES` | `CONFIRMADO` |
| `TODOS` | sem filtro |
| `ATENDIDOS` | `ATENDIDO` |
| `AUSENTES` | `AUSENTE` |

## Endpoints disponíveis

### 1. Listagem geral

`GET /api/v1/agendamentos`

Retorna todos os agendamentos ordenados por `data` ascendente e `horario` ascendente.

### 2. Listagem geral com query param opcional

`GET /api/v1/agendamentos?status=PENDENTES`

Aceita os valores:

- `PENDENTES`
- `TODOS`
- `ATENDIDOS`
- `AUSENTES`

### 3. Rota dedicada para filtro por status

`GET /api/v1/agendamentos/status/:status`

Exemplos:

- `GET /api/v1/agendamentos/status/PENDENTES`
- `GET /api/v1/agendamentos/status/TODOS`
- `GET /api/v1/agendamentos/status/ATENDIDOS`
- `GET /api/v1/agendamentos/status/AUSENTES`

## Resposta de sucesso

Status HTTP: `200 OK`

Exemplo:

```json
[
  {
    "id": "6846d10e4f7e1f0f0b000001",
    "nome": "Cliente Teste",
    "email": "cliente@example.com",
    "data": "2026-06-09",
    "horario": "10:00",
    "status": "CONFIRMADO",
    "servico_id": "servico-1",
    "servico_nome": "Corte",
    "servico_preco": 35.0,
    "created_at": "2026-06-09T12:00:00.000Z",
    "updated_at": "2026-06-09T12:00:00.000Z"
  }
]
```

## Resposta para filtro inválido

Status HTTP: `422 Unprocessable Entity`

Exemplo:

```json
{
  "errors": [
    "Filtro de status inválido. Use: PENDENTES, TODOS, ATENDIDOS, AUSENTES"
  ]
}
```

## Contrato recomendado para o frontend

### Estado do filtro

O frontend deve trabalhar com estes quatro valores exatos:

```ts
type FiltroAgendamento = "PENDENTES" | "TODOS" | "ATENDIDOS" | "AUSENTES";
```

### Requisição recomendada

Opção preferida:

```ts
GET /api/v1/agendamentos/status/${filtro}
```

Opção alternativa compatível:

```ts
GET /api/v1/agendamentos?status=${filtro}
```

### Regra de exibição

- Quando o filtro selecionado for `PENDENTES`, o backend responderá com itens cujo `status` continuará vindo como `CONFIRMADO`.
- O frontend não deve converter `CONFIRMADO` para outro valor antes de enviar atualizações.
- Para exibição ao usuário, é aceitável mostrar `CONFIRMADO` como "Pendente" apenas na camada visual.

### Atualização de status

O endpoint de atualização não mudou:

`PATCH /api/v1/agendamentos/:id`

Payload aceito:

```json
{
  "agendamento": {
    "status": "ATENDIDO"
  }
}
```

Ou:

```json
{
  "agendamento": {
    "status": "AUSENTE"
  }
}
```

### Fluxo sugerido para o frontend

1. Carregar a tela com filtro inicial `PENDENTES`.
2. Buscar dados em `GET /api/v1/agendamentos/status/PENDENTES`.
3. Ao trocar a aba ou select de filtro, refazer a consulta com o novo valor.
4. Ao marcar um agendamento como `ATENDIDO` ou `AUSENTE`, chamar o `PATCH`.
5. Após o `PATCH`, recarregar a lista usando o filtro atualmente selecionado.
