#!/bin/bash

echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/doubletop.sh | bash
echo "-----------------------------------------------------------------------------"

echo "-----------------------------------------------------------------------------"
echo "Обновление Allora Worker - Huggingface Walkthrough"
echo "-----------------------------------------------------------------------------"

source /home/config/docker/docker-compose/go/.profile

if [ -z "$ALLORA_SEED_PHRASE" ]; then
    echo "Введите сид фразу от кошелька, который будет использоваться для воркера"
    read ALLORA_SEED_PHRASE
    echo "export ALLORA_SEED_PHRASE='$ALLORA_SEED_PHRASE'" >> /home/config/docker/docker-compose/go/.profile
fi

if [ -z "$COIN_GECKO_API_KEY" ]; then
    echo "Введите COINGECKO API KEY"
    read COIN_GECKO_API_KEY
    echo "export COIN_GECKO_API_KEY='$COIN_GECKO_API_KEY'" >> /home/config/docker/docker-compose/go/.profile
fi

docker-compose -f /home/config/docker/docker-compose/go/basic-coin-prediction-node/docker-compose.yml down -v &>/dev/null
docker-compose -f /home/config/docker/docker-compose/go/allora-huggingface-walkthrough/docker-compose.yaml down -v  &>/dev/null
docker-compose -f /home/config/docker/docker-compose/go/allora-worker-x-reputer/allora-node/docker-compose.yaml down -v &>/dev/null

cd /home/config/docker/docker-compose/go
rm -rf allora-huggingface-walkthrough

git clone https://github.com/allora-network/allora-huggingface-walkthrough
cd allora-huggingface-walkthrough
mkdir -p worker-data
chmod -R 777 worker-data

wget https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/allora/config.json
sed -i "s|SeedPhrase|$ALLORA_SEED_PHRASE|" /home/config/docker/docker-compose/go/allora-huggingface-walkthrough/config.json
sed -i "s|<Your Coingecko API key>|$COIN_GECKO_API_KEY|" /home/config/docker/docker-compose/go/allora-huggingface-walkthrough/app.py
ip_address=$(hostname -I | awk '{print $1}') >/dev/null
sed -i "s|inference:|$ip_address:|" /home/config/docker/docker-compose/go/allora-huggingface-walkthrough/config.json

chmod +x init.config
./init.config

sed -i "s|\"8000:8000\"|\"18000:8000\"|" /home/config/docker/docker-compose/go/allora-huggingface-walkthrough/docker-compose.yaml
sed -i "s|alloranetwork/allora-offchain-node:.*|alloranetwork/allora-offchain-node:v0.7.0|" /home/config/docker/docker-compose/go/allora-huggingface-walkthrough/docker-compose.yaml

docker compose up -d --build

echo "-----------------------------------------------------------------------------"
echo "Wish lifechange case with DOUBLETOP"
echo "-----------------------------------------------------------------------------"
