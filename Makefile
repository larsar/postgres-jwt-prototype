admin_db_user=postgres
app_db_user=application

modules = "app audit com core ctrl id info short web"

up:
	docker-compose up -d

down:
	docker-compose down

psql-admin:
	docker-compose run --rm db psql -h db -U ${admin_db_user}

psql-app:
	docker-compose run --rm db psql -h db -U ${app_db_user}

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

db-reset: _db-reset migrate seed

_db-reset:
	docker-compose	stop db &&\
	docker-compose	rm -f db &&\
	docker-compose up -d db &&\
	sleep 5

