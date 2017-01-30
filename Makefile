admin_db_user=postgres
app_db_user=app

modules = "app audit com core ctrl id info short web"

up:
	docker-compose up -d

down:
	docker-compose down

psql-admin:
	docker-compose run --rm db psql -h db -U ${admin_db_user} postgres

psql-app:
	docker-compose run --rm db psql -h db -U ${app_db_user} postgres

schema:
	docker-compose run --rm db pg_dump -s --no-owner -h db -U ${admin_db_user}

migrate:
	docker-compose run --rm db bash -c 'cat src/schema/* | psql -h db -U ${admin_db_user}'

seed:
	docker-compose run --rm db bash -c 'cat src/seed/* | psql -h db -U ${admin_db_user}'

start:
	docker-compose start

stop:
	docker-compose stop

restart:
	docker-compose restart

logs:
	docker-compose logs -f

reset: _reset migrate seed

_reset:
	docker-compose down &&\
	docker-compose up -d &&\
	sleep 5
