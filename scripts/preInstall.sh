set env vars
set -o allexport; source .env; set +o allexport;

# cat << EOT >> ./config/wazuh_dashboard/wazuh.yml

# hosts:
#   - 1513629884013:
#       url: "https://wazuh.manager"
#       port: 55000
#       username: admin
#       password: "${ADMIN_PASSWORD}"
#       run_as: false

# EOT

mkdir -p ./wazuh-indexer-data
mkdir -p ./wazuh-dashboard-config
mkdir -p ./wazuh-dashboard-custom

chown -R 777 ./wazuh-indexer-data
chown -R 777 ./wazuh-dashboard-config
chown -R 777 ./wazuh-dashboard-custom

chmod -R 777 ./wazuh-indexer-data
chmod -R 777 ./wazuh-dashboard-config
chmod -R 777 ./wazuh-dashboard-custom

chmod o+r ./wazuh-indexer-data
chmod o+r ./wazuh-dashboard-config
chmod o+r ./wazuh-dashboard-custom

sysctl -w vm.max_map_count=262144
docker-compose -f generate-indexer-certs.yml run --rm generator

bcrypt_hash=$(htpasswd -bnBC 10 "" "$ADMIN_PASSWORD" | tr -d ':\n')

sed -i "s~ADMIN_PASSWORD~${bcrypt_hash}~g" ./config/wazuh_indexer/internal_users.yml
sed -i "s~ADMIN_PASSWORD~${ADMIN_PASSWORD}~g" ./config/wazuh_dashboard/wazuh.yml