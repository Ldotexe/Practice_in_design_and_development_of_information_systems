#!/bin/bash
set -e

DOCKER_USER="ldotexe"
TAG="latest"

docker login -u ldotexe

echo "--- 1. Сборка и отправка BACKEND ---"
docker build -t $DOCKER_USER/messenger-backend:$TAG ./backend
docker push $DOCKER_USER/messenger-backend:$TAG

echo "--- 2. Сборка и отправка FRONTEND ---"
docker build -t $DOCKER_USER/messenger-frontend:$TAG ./frontend
docker push $DOCKER_USER/messenger-frontend:$TAG

echo "--- 3. Сборка и отправка NGINX ---"
docker build -t $DOCKER_USER/messenger-nginx:$TAG ./nginx
docker push $DOCKER_USER/messenger-nginx:$TAG

echo "--- Готово! Все компоненты в облаке ---"