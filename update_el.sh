#!/bin/bash

cd /root/conf/dock/elixir/

docker kill elixir &>/dev/null
docker rm -f elixir &>/dev/null
docker pull elixirprotocol/validator:v3 --platform linux/amd64

docker run --env-file /root/conf/dock/elixir/.env --name elixir --platform linux/amd64 --restart always -p 17690:17690 elixirprotocol/validator:v3
