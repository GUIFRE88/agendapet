# Variáveis
COMPOSE=docker compose
SERVICE_WEB=web

# Alvos padrão
.PHONY: help build up down start stop restart logs bash rails db-create db-migrate db-setup db-reset assets-precompile

help:
	@echo "Comandos disponíveis:"
	@echo "  make build              - builda as imagens"
	@echo "  make up                 - sobe os containers em background"
	@echo "  make down               - derruba os containers"
	@echo "  make start              - sobe os containers e inicia o Rails server"
	@echo "  make stop               - para os containers"
	@echo "  make restart            - reinicia os containers"
	@echo "  make logs               - segue os logs do web"
	@echo "  make bash               - abre um bash no container web"
	@echo "  make rails CMD=...      - roda um comando rails (ex: CMD=about)"
	@echo "  make db-create          - cria os bancos"
	@echo "  make db-migrate         - executa migrações"
	@echo "  make db-setup           - setup completo do banco (create, migrate, seed)"
	@echo "  make db-reset           - reseta o banco (drop, create, migrate, seed)"
	@echo "  make assets-precompile  - pré-compila assets"

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

start: up
	$(COMPOSE) exec $(SERVICE_WEB) rails server -b 0.0.0.0 -p 3000

stop:
	$(COMPOSE) stop

restart: down up

logs:
	$(COMPOSE) logs -f $(SERVICE_WEB)

bash:
	$(COMPOSE) exec $(SERVICE_WEB) bash

rails:
	$(COMPOSE) exec $(SERVICE_WEB) rails $(CMD)

db-create:
	$(COMPOSE) exec $(SERVICE_WEB) rails db:create

db-migrate:
	$(COMPOSE) exec $(SERVICE_WEB) rails db:migrate

db-setup:
	$(COMPOSE) exec $(SERVICE_WEB) rails db:setup

db-reset:
	$(COMPOSE) exec $(SERVICE_WEB) rails db:reset

assets-precompile:
	$(COMPOSE) exec $(SERVICE_WEB) rails assets:precompile
