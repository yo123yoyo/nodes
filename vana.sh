channel_logo() {
  echo -e '\033[0;31m'
  echo -e '┌┐ ┌─┐┌─┐┌─┐┌┬┐┬┬ ┬  ┌─┐┬ ┬┌┐ ┬┬  '
  echo -e '├┴┐│ ││ ┬├─┤ │ │└┬┘  └─┐└┬┘├┴┐││  '
  echo -e '└─┘└─┘└─┘┴ ┴ ┴ ┴ ┴   └─┘ ┴ └─┘┴┴─┘'
  echo -e '\e[0m'
  echo -e "\n\nПодпишись на самый 4ekHyTbIu* канал в крипте @bogatiy_sybil [💸]"
}

download_node() {
  echo 'Начинаю установку ноды...'

  sleep 1

  sudo apt update && sudo apt upgrade -y
  sudo apt-get install git -y
  sudo apt install unzip
  sudo apt install nano

  sudo apt-get install screen -y
  sudo apt-get install git -y

  sudo apt install software-properties-common -y
  sudo add-apt-repository ppa:deadsnakes/ppa

  sudo apt update -y
  sudo apt install -y python3.12

  sudo apt install python3.12-venv
  python3.12 -m venv env
  source env/bin/activate

  cd /home/config/docker/docker-compose/go
  git clone https://github.com/vana-com/vana-dlp-chatgpt.git
  cd vana-dlp-chatgpt
  cp .env.example .env

  sudo apt install gcc
  sudo apt install build-essential
  python -m pip install python-dotenv

  sudo apt update -y
  sudo apt install python3-dev - y
  sudo apt install libpython3.12-dev -y
  sudo apt install python3-devel -y
  sudo apt-get install libevent-dev
  sudo apt update -y
  pip wheel --no-cache-dir --use-pep517 "lru-dict (==1.2.0)"

  pip install poetry==1.8.2
  poetry install

  pip install vana

  echo 'Придумайте пароль для двух кошельков который у вас сейчас будут на экране'
  echo 'Сохраните пароль в надежном месте, как и сид фразы, отмеченные желтым текстом'
  echo '!!! ЭТО ВАЖНО !!!'

  read -p "Как прочтете, введите что-нибудь: " inputsmth

  vanacli wallet create --wallet.name default --wallet.hotkey default

  sleep 1

  vanacli wallet export_private_key

  echo 'Повторяете еще раз, но уже с другими данными (смотрите гайд)'

  sleep 5

  vanacli wallet export_private_key

  sleep 1

  echo 'Следуйте дальше инструкции по гайду'
}

create_keys() {
  source env/bin/activate

  cd vana-dlp-chatgpt
  ./keygen.sh
}

deploy_dlp() {
  source env/bin/activate

  cd /home/config/docker/docker-compose/go
  git clone https://github.com/Josephtran102/vana-dlp-smart-contracts
  cd vana-dlp-smart-contracts
  
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  apt-get install nodejs -y
  
  npm install -g yarn
  yarn install
  cp .env.example .env
  nano .env

  sleep 1

  npx hardhat deploy --network moksha --tags DLPDeploy
}

download_validator() {
  source env/bin/activate

  echo -e 'Сохраните данный приватный ключ в надежном месте\n\n'
  cat /home/config/docker/docker-compose/go/vana-dlp-chatgpt/private_key_base64.asc
  
  read -p "Как сохраните, введите что-нибудь: " inputsmthhh
  
  cd /home/config/docker/docker-compose/go
  cd vana-dlp-chatgpt
  nano .env

  sleep 2

  pip install vana

  read -p "Введите ваш hotkey адрес из MetaMask (0x...): " validator_address

  ./vanacli dlp register_validator --stake_amount 10

  sleep 1
  
  ./vanacli dlp approve_validator --validator_address=$validator_address

  sleep 1

  screen -S vananode

  cd
  source env/bin/activate
  cd /home/config/docker/docker-compose/go/vana-dlp-chatgpt

  sleep 1

  poetry run python -m chatgpt.nodes.validator
}

service_start() {
  source env/bin/activate

  poetry_path=$(which poetry)

  sudo tee /etc/systemd/system/vana.service << EOF
[Unit]
Description=Vana Validator Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/home/config/docker/docker-compose/go/vana-dlp-chatgpt
ExecStart=$poetry_path run python -m chatgpt.nodes.validator
Restart=on-failure
RestartSec=10
Environment=PATH=/root/.local/bin:/usr/local/bin:/usr/bin:/bin:/root/vana-dlp-chatgpt/myenv/bin//home/config/docker/docker-compose/go
Environment=PYTHONPATH=/root/vana-dlp-chatgpt

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl daemon-reload && \
  sudo systemctl enable vana.service && \
  sudo systemctl start vana.service && \
  sudo systemctl status vana.service
}

check_logs() {
  source env/bin/activate

  sudo journalctl -u vana.service -f
}

exit_from_script() {
  exit 0
}

while true; do
    channel_logo
    sleep 2
    echo -e "\n\nМеню:"
    echo "1. Начать установку ноды"
    echo '2. Создать ключи для DLP'
    echo '3. Установка DLP'
    echo '4. Установка валидатора'
    echo '5. Установить фоновый сервис'
    echo '6. Проверить логи'
    echo -e "7. Выйти из скрипта\n"
    read -p "Выберите пункт меню: " choice

    case $choice in
      1)
        download_node
        ;;
      2)
        create_keys
        ;;
      3)
        deploy_dlp
        ;;
      4)
        download_validator
        ;;
      5)
        service_start
        ;;
      6)
        check_logs
        ;;
      7)
        exit_from_script
        ;;
      *)
        echo "Неверный пункт. Пожалуйста, выберите правильную цифру в меню."
        ;;
    esac
  done
