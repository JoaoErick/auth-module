#!/bin/bash

multiplier=5

# Obtém o número atual de containers em execução com o nome base "aca-py"
counter=$(docker ps -a --filter "name=aca-py" --format '{{.Names}}' | wc -l)

echo "Número de módulos de autenticação em execução: $counter"

# Calcula o valor do acumulador para a alteração das portas
accumulator=$(($counter * $multiplier))

# Atualiza as variáveis de ambiente
seed=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 32)

sed -i "s/AGENT_WALLET_SEED=.*/AGENT_WALLET_SEED=$seed/" ./.env
sed -i "s/LABEL=.*/LABEL=Agent-$counter/" ./.env
sed -i "s/WALLET_NAME=.*/WALLET_NAME=Wallet-$counter/" ./.env
sed -i "s/ACAPY_ENDPOINT_PORT=.*/ACAPY_ENDPOINT_PORT=$((7020 + $accumulator))/" ./.env
sed -i "s/ACAPY_ADMIN_PORT=.*/ACAPY_ADMIN_PORT=$((7021 + $accumulator))/" ./.env
sed -i "s/NGROK_PORT_OUT=.*/NGROK_PORT_OUT=$((3040 + $accumulator))/" ./.env
sed -i "s/NGROK_PORT_IN=.*/NGROK_PORT_IN=$((3041 + $accumulator))/" ./.env
sed -i "s/POSTGRES_PORT=.*/POSTGRES_PORT=$((5433 + $accumulator))/" ./.env

# Atualiza o nome dos containers no arquivo docker-compose.yml
sed -i "s/container_name: ngrok-$counter/container_name: ngrok-$(($counter + 1))/" ./docker-compose.yml
sed -i "s/container_name: aca-py-$counter/container_name: aca-py-$(($counter + 1))/" ./docker-compose.yml
sed -i "s/container_name: wallet-db-$counter/container_name: wallet-db-$(($counter + 1))/" ./docker-compose.yml

docker-compose --project-name auth-module-$(($counter + 1)) up -d