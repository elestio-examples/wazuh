set env vars
set -o allexport; source .env; set +o allexport;


mkdir -p ./wazuh-indexer-data
mkdir -p ./wazuh-dashboard-config
mkdir -p ./wazuh-dashboard-custom

chown -R 777 ./wazuh-indexer-data
chown -R 777 ./wazuh-dashboard-config
chown -R 777 ./wazuh-dashboard-custom

chmod o+r ./wazuh-indexer-data
chmod o+r ./wazuh-dashboard-config
chmod o+r ./wazuh-dashboard-custom

chmod +x ./generate-password.sh

sysctl -w vm.max_map_count=262144
docker-compose -f generate-indexer-certs.yml run --rm generator

bcrypt_hash=$(htpasswd -bnBC 10 "" "$ADMIN_PASSWORD" | tr -d ':\n')

sed -i "s~ADMIN_PASSWORD~${bcrypt_hash}~g" ./config/wazuh_indexer/internal_users.yml
sed -i "s~ADMIN_PASSWORD~${ADMIN_PASSWORD}~g" ./config/wazuh_dashboard/wazuh.yml

cat << EOT >> ./.env

BCRYPT_HASH=${bcrypt_hash}
EOT