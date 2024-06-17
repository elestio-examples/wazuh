# set env vars
set -o allexport; source .env; set +o allexport;

echo "Waiting for software to be ready..."
sleep 120s;

sed -i "s~SecretPassword~${BCRYPT_HASH}~g" ./filebeat_etc/filebeat.yml


docker-compose down;
docker-compose up -d;

sleep 120s;