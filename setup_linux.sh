#!/bin/bash

# 检查是否传入了参数
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <claim_reward_address>"
    exit 1
fi

CLAIM_REWARD_ADDRESS=$1

# 创建目录
mkdir -p ~/cysic-verifier

# 下载verifier和库文件
curl -L -o ~/cysic-verifier/verifier https://github.com/cysic-labs/phase2_libs/releases/download/v1.0.0/verifier_linux
curl -L -o ~/cysic-verifier/libdarwin_verifier.so https://github.com/cysic-labs/phase2_libs/releases/download/v1.0.0/libdarwin_verifier.so

# 创建配置文件
cat <<EOF > ~/cysic-verifier/config.yaml
# Not Change
chain:
  # Not Change
  # endpoint: "node-pre.prover.xyz:80"
  endpoint: "grpc-testnet.prover.xyz:80"
  # Not Change
  chain_id: "cysicmint_9001-1"
  # Not Change
  gas_coin: "CYS"
  # Not Change
  gas_price: 10
  # Modify Here：! Your Address (EVM) submitted to claim rewards
claim_reward_address: "$CLAIM_REWARD_ADDRESS"

server:
  # don't modify this
  # cysic_endpoint: "https://api-pre.prover.xyz"
  cysic_endpoint: "https://api-testnet.prover.xyz"
EOF

# 设置执行权限并创建启动脚本
cd ~/cysic-verifier/
chmod +x verifier
cat <<EOF > ~/cysic-verifier/start.sh
#!/bin/bash
export LD_LIBRARY_PATH=.
export CHAIN_ID=534352
./verifier
EOF
chmod +x ~/cysic-verifier/start.sh

# 提示完成
echo "Setup complete. Run the verifier using: ~/cysic-verifier/start.sh"

