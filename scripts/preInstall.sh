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

sysctl -w vm.max_map_count=262144
docker-compose -f generate-indexer-certs.yml run --rm generator