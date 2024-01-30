#!/bin/bash

multiplier=5

echo "Finalizando o último módulo de autenticação"

# Obtém o número atual de containers em execução com o nome base "aca-py"
counter=$(docker ps -a --filter "name=aca-py" --format '{{.Names}}' | wc -l)

# Calcula o valor do acumulador para a alteração das portas
accumulator=$(($counter * $multiplier))

sed -i "s/LABEL=.*/LABEL=Agent-$(($counter - 1))/" ./.env
sed -i "s/WALLET_NAME=.*/WALLET_NAME=Wallet-$(($counter - 1))/" ./.env
sed -i "s/ACAPY_ENDPOINT_PORT=.*/ACAPY_ENDPOINT_PORT=$((7020 + $accumulator - $multiplier))/" ./.env
sed -i "s/ACAPY_ADMIN_PORT=.*/ACAPY_ADMIN_PORT=$((7021 + $accumulator - $multiplier))/" ./.env
sed -i "s/POSTGRES_PORT=.*/POSTGRES_PORT=$((5433 + $accumulator - $multiplier))/" ./.env
sed -i "s/ACAPY_CONTAINER_NAME=.*/ACAPY_CONTAINER_NAME=aca-py-$(($counter - 1))/" ./.env
sed -i "s/WALLET_CONTAINER_NAME=.*/WALLET_CONTAINER_NAME=wallet-db-$(($counter - 1))/" ./.env

docker-compose -p auth-module-$counter down
echo " auth-module-$counter interrompido!"