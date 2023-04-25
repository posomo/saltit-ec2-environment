sudo docker exec backend-nginx nginx -s reload
sudo docker compose pull web1 web2
sudo docker compose up --force-recreate -d web1 web2