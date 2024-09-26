#!/bin/bash

echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/doubletop.sh | bash
echo "-----------------------------------------------------------------------------"

echo "-----------------------------------------------------------------------------"
echo "Установка Allora Worker - Reputer Node"
echo "-----------------------------------------------------------------------------"

source /home/config/docker/docker-compose/go/.profile

if [ -z "$ALLORA_SEED_PHRASE" ]; then
    echo "Введите сид фразу от кошелька, который будет использоваться для воркера"
    read ALLORA_SEED_PHRASE
    echo "export ALLORA_SEED_PHRASE='$ALLORA_SEED_PHRASE'" >> /home/config/docker/docker-compose/go/.profile
fi

if [ -z "$COIN_GECKO_API_KEY" ]; then
    echo "Введите Coin Gecko API key"
    read COIN_GECKO_API_KEY
    echo "export COIN_GECKO_API_KEY='$COIN_GECKO_API_KEY'" >> /home/config/docker/docker-compose/go/.profile
fi

docker-compose -f /home/config/docker/docker-compose/go/basic-coin-prediction-node/docker-compose.yml down &>/dev/null
docker-compose -f /home/config/docker/docker-compose/go/allora-huggingface-walkthrough/docker-compose.yaml down &>/dev/null

cd /home/config/docker/docker-compose/go
git clone https://github.com/0xtnpxsgt/allora-worker-x-reputer.git
cd allora-worker-x-reputer
chmod +x init.sh
bash init.sh

cd allora-node
chmod +x ./init.config.sh
bash init.config.sh "testkey" "$ALLORA_SEED_PHRASE" "$COIN_GECKO_API_KEY"

rm -rf /home/config/docker/docker-compose/go/allora-worker-x-reputer/allora-node/docker-compose.yaml
wget https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/allora/docker-compose.yaml

docker compose pull
docker compose up --build -d 


echo "-----------------------------------------------------------------------------"
echo "Wish lifechange case with DOUBLETOP"
echo "-----------------------------------------------------------------------------"
