#!/bin/bash

COMPOSE_PROJECT_NAME=$(grep COMPOSE_PROJECT_NAME .env | cut -d '=' -f2)
PROJECT_DOMAIN=$(grep PROJECT_DOMAIN .env | cut -d '=' -f2)
CODE_PATH=$(grep CODE_PATH .env | cut -d '=' -f2)

MYSQL_DATABASE=$(grep MYSQL_DATABASE .env | cut -d '=' -f2)
MYSQL_USER=$(grep MYSQL_USER .env | cut -d '=' -f2)
MYSQL_PASSWORD=$(grep MYSQL_PASSWORD .env | cut -d '=' -f2)
MAGENTO_VERSION=$(grep MAGENTO_VERSION .env | cut -d '=' -f2)


docker-compose exec php-fpm php -d memory_limit=-1 /usr/local/bin/composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition="${MAGENTO_VERSION}" .

docker-compose exec php-fpm php -d memory_limit=-1 bin/magento setup:install \
--base-url=http://"${PROJECT_DOMAIN}" \
--use-secure=0 \
--use-secure-admin=1 \
--backend-frontname=admin \
--db-host="mysql.${PROJECT_DOMAIN}" \
--db-name="${MYSQL_DATABASE}" \
--db-user="${MYSQL_USER}" \
--db-password="${MYSQL_PASSWORD}" \
--admin-firstname=admin \
--admin-lastname=admin \
--admin-email=admin@example.com \
--admin-user=admin \
--admin-password=alfar0me0 \
--language=en_US \
--currency=USD \
--timezone=Europe/Kiev \
--admin-use-security-key=1 \
--session-save=files \
--cleanup-database \
--search-engine=elasticsearch7 \
--elasticsearch-host="elasticsearch.${PROJECT_DOMAIN}" \
--elasticsearch-port=9200 \
--elasticsearch-index-prefix="${COMPOSE_PROJECT_NAME}"

docker-compose exec php-fpm mkdir -p /var/www/public/var/composer_home
docker-compose exec php-fpm cp /var/www/.composer/auth.json /var/www/public/var/composer_home/auth.json
docker-compose exec php-fpm php -d memory_limit=-1 bin/magento sampledata:deploy

docker-compose exec php-fpm php -d memory_limit=-1 bin/magento module:disable Magento_TwoFactorAuth


docker-compose exec php-fpm php -d memory_limit=-1 bin/magento setup:upgrade
docker-compose exec php-fpm php -d memory_limit=-1 bin/magento setup:di:compile


