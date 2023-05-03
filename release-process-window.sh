echo "nginx가 api-server1만 가리키도록 변경"
sed -i 's/server api-server2:8080/# server api-server2:8080/g' nginx/default.conf
docker exec backend-nginx nginx -s reload > /dev/null 2>&1
sleep 3

echo "api-server2을 새로운 버젼으로 배포하고, 정상적으로 돌아가는지 확인"
docker compose pull web2 -q
docker compose up --force-recreate -d web2
curl --silent --head --fail http://localhost:8081/swagger-ui/index.html >> /dev/null
while [ $? -ne 0 ];
do 
    sleep 1
    curl --silent --head --fail http://localhost:8081/swagger-ui/index.html >> /dev/null
done
echo -e "\033[32m"api-server2 배포 성공"\033[0m" 

echo "nginx가 api-server2만 가리키도록 변경"
sed -i 's/# server api-server2:8080/server api-server2:8080/g' nginx/default.conf
sed -i 's/server api-server1:8080/# server api-server1:8080/g' nginx/default.conf
docker exec backend-nginx nginx -s reload > /dev/null 2>&1
sleep 3

echo "api-server1을 새로운 버젼으로 배포하고, 정상적으로 돌아가는지 확인"
docker compose pull web1 -q
docker compose up --force-recreate -d web1
curl --silent --head --fail http://localhost:8080/swagger-ui/index.html >> /dev/null
while [ $? -ne 0 ];
do 
    sleep 1
    curl --silent --head --fail http://localhost:8080/swagger-ui/index.html >> /dev/null
done
echo -e "\033[32m"api-server1 배포 성공"\033[0m" 

echo "nginx가 모든 컨테이너를 가리키도록 변경"
sed -i 's/# server api-server1:8080/server api-server1:8080/g' nginx/default.conf
docker exec backend-nginx nginx -s reload > /dev/null 2>&1
echo -e "\033[32m"배포 성공!"\033[0m" 