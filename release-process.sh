sudo docker exec backend-nginx nginx -s reload
sudo docker compose up --no-deps --build web1 -d
sudo docker compose up --no-deps --build web2 -d