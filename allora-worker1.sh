#!/bin/bash

echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/doubletop.sh | bash
echo "-----------------------------------------------------------------------------"

echo "-----------------------------------------------------------------------------"
echo "Установка Allora Worker - Basic Coin Prediction Node"
echo "-----------------------------------------------------------------------------"

source /home/config/docker/docker-compose/go/.profile

if [ -z "$ALLORA_SEED_PHRASE" ]; then
    echo "Введите сид фразу от кошелька, который будет использоваться для воркера"
    read ALLORA_SEED_PHRASE
    echo "export ALLORA_SEED_PHRASE='$ALLORA_SEED_PHRASE'" >> /home/config/docker/docker-compose/go/.profile
fi

cd /home/config/docker/docker-compose/go
git clone https://github.com/allora-network/basic-coin-prediction-node
cd basic-coin-prediction-node
rm -rf config.json

wget https://raw.githubusercontent.com/DOUBLE-TOP/guides/main/allora/config.json
sed -i "s|SeedPhrase|$ALLORA_SEED_PHRASE|" /home/config/docker/docker-compose/go/basic-coin-prediction-node/config.json

chmod +x init.config
./init.config

sed -i "s|\"8000:8000|\"18000:8000|" /home/config/docker/docker-compose/go/basic-coin-prediction-node/docker-compose.yml
sed -i "s|intervals = [\"1d\"]|intervals = [\"10m\", \"20m\", \"1h\", \"1d\"]|" /home/config/docker/docker-compose/go/basic-coin-prediction-node/model.py

sudo tee /home/config/docker/docker-compose/go/basic-coin-prediction-node/.env > /dev/null <<EOF
TOKEN=ETH
TRAINING_DAYS=30
TIMEFRAME=4h
MODEL=LinearRegression
REGION=EU
DATA_PROVIDER=Binance
CG_API_KEY=
EOF

sleep 5

docker compose up -d --build

echo "-----------------------------------------------------------------------------"
echo "Wish lifechange case with DOUBLETOP"
echo "-----------------------------------------------------------------------------"
