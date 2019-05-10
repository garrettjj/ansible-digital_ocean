#!/bin/bash

server_domain=$1
server_hostname=$2
ip_address=$3
do_api_token=$4

printf "Creating domain entry..."

generate_domain_data()
{
  cat <<EOF
{"name": "$server_domain"}
EOF
}

curl -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $do_api_token" \
  "https://api.digitalocean.com/v2/domains" \
  -d "$(generate_domain_data)" | jq

printf "Creating A record for new Droplet..."

generate_record_data()
{
  cat <<EOF
{"type": "A","name": "$server_hostname","data": "$ip_address"}
EOF
}

curl -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $do_api_token" \
  "https://api.digitalocean.com/v2/domains/$server_domain/records" \
  -d "$(generate_record_data)" | jq