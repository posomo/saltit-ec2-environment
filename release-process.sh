sudo docker exec backend-nginx nginx -s reload
sudo docker-compose up --force-recreate --build -d web1 web2