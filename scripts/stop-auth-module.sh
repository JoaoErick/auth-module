#!/bin/bash

echo "Finalizando todos os módulos de autenticação"

# Obtém o número atual de containers em execução com o nome base "aca-py"
counter=$(docker ps -a --filter "name=aca-py" --format '{{.Names}}' | wc -l)

sed -i "s/LABEL=.*/LABEL=Agent-0/" ./.env
sed -i "s/WALLET_NAME=.*/WALLET_NAME=Wallet-0/" ./.env
sed -i "s/ACAPY_ENDPOINT_PORT=.*/ACAPY_ENDPOINT_PORT=7020/" ./.env
sed -i "s/ACAPY_ADMIN_PORT=.*/ACAPY_ADMIN_PORT=7021/" ./.env
sed -i "s/POSTGRES_PORT=.*/POSTGRES_PORT=5433/" ./.env
sed -i "s/ACAPY_CONTAINER_NAME=.*/ACAPY_CONTAINER_NAME=aca-py-0/" ./.env
sed -i "s/WALLET_CONTAINER_NAME=.*/WALLET_CONTAINER_NAME=wallet-db-0/" ./.env

# Itera pela quantidade de módulos de autenticação para finalizá-los.
for ((index = 1; index <= $counter; index++)); do
    docker-compose -p auth-module-$index down
    echo "auth-module-$index interrompido!"
done