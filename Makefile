init:
	@echo "Развертывание проекта InterCom"
	@echo "Клонирование проектов..."
	@sudo rm -rf ./apps/parser
	@make clone.interCom
	@echo "Поднятие контейнеров..."
	sudo docker-compose build
	sudo docker-compose run parser-app bash -c 'cd /var/www/parser; composer install; cp .env.example .env; composer dumpautoload; php artisan migrate; php artisan db:seed'
	@echo ""
	@echo "Добавление хостов..."
	@sudo make hosts
	@echo ""
	@make up
	@echo "Проект InterCom установлен."

hosts:
	echo "100.91.22.12 inter-com-parser.local" >> /etc/hosts

clone.interCom:
	git clone git@github.com:DShpachenko/InterCom-Parser.git apps/parser

up:
	@make down
	docker-compose up -d parser-nginx

down:
	docker-compose stop

exec.parser:
	docker-compose exec parser-app bash