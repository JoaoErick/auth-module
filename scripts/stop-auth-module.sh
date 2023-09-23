#!/bin/bash

echo "Finalizando todos os módulos de autenticação"

# Obtém o número atual de containers em execução com o nome base "aca-py"
counter=$(docker ps -a --filter "name=aca-py" --format '{{.Names}}' | wc -l)

# Atualiza o nome dos containers no arquivo docker-compose.yml
sed -i "s/container_name: ngrok.*/container_name: ngrok-0/" ./docker-compose.yml
sed -i "s/container_name: aca-py.*/container_name: aca-py-0/" ./docker-compose.yml
sed -i "s/container_name: wallet-db.*/container_name: wallet-db-0/" ./docker-compose.yml

# Itera pela quantidade de módulos de autenticação para finalizá-los.
for ((index = 1; index <= $counter; index++)); do
    docker-compose -p auth-module-$index down
    echo "auth-module-$index interrompido!"
done