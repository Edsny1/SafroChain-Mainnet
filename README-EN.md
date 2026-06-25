# Safrochain Mainnet Node Guide

> **Prepared by:** OshVanK  
> **Chain:** `safrochain-1` | **Version:** `v0.2.2` | **Go:** `1.25.8`  
> **Genesis time:** `2026-06-25T10:00:00Z`

---

## Table of Contents

1. [Quick Start — Automated Installation](#1-quick-start--automated-installation)
2. [Manual Installation](#2-manual-installation)
3. [Wallet Operations](#3-wallet-operations)
4. [Validator Operations](#4-validator-operations)
5. [Sync Status Check](#5-sync-status-check)
6. [Useful Commands](#6-useful-commands)
7. [Delete Node](#7-delete-node)
8. [Network Info](#8-network-info)

---

## 1. Quick Start — Automated Installation

Download and run the setup script:

```bash
wget -O safrochain_mainnet.sh https://raw.githubusercontent.com/YOUR_REPO/safrochain_mainnet.sh
chmod +x safrochain_mainnet.sh
./safrochain_mainnet.sh
```

The script will ask for:
- **MONIKER** — your node name
- **Port prefix** — default `26` (change if you have other nodes using default ports)
- **Wallet name** — default `wallet`

> **About Go on shared servers:** If your server already has other nodes (lumerad, gnoland, atomoned, etc.), the script only updates `/usr/local/go`. Pre-compiled binaries in `~/go/bin` are unaffected — they do not require Go at runtime.

---

## 2. Manual Installation

### 2.1 System Dependencies

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git wget htop tmux build-essential jq make lz4 gcc unzip
```

### 2.2 Install Go 1.25.8

```bash
cd $HOME
wget https://go.dev/dl/go1.25.8.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.25.8.linux-amd64.tar.gz
rm go1.25.8.linux-amd64.tar.gz

echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc

go version
# Expected: go version go1.25.8 linux/amd64
```

### 2.3 Build safrochaind v0.2.2

```bash
cd $HOME
git clone https://github.com/Safrochain-Org/safrochain-node ~/safrochain-node
cd ~/safrochain-node
git fetch --tags
git checkout v0.2.2
make install

safrochaind version
# Expected: safrochaind v0.2.2
```

### 2.4 Install Cosmovisor

```bash
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@latest

mkdir -p $HOME/.safrochain/cosmovisor/genesis/bin
mkdir -p $HOME/.safrochain/cosmovisor/upgrades
cp $(which safrochaind) $HOME/.safrochain/cosmovisor/genesis/bin/safrochaind
sudo ln -sfn $HOME/.safrochain/cosmovisor/genesis $HOME/.safrochain/cosmovisor/current
```

### 2.5 Initialize Node

```bash
safrochaind init "YOUR_MONIKER" --chain-id safrochain-1 --home ~/.safrochain
```

### 2.6 Download & Verify Genesis

```bash
curl -L https://raw.githubusercontent.com/Safrochain-Org/mainnet-genesis/main/genesis.json \
    -o ~/.safrochain/config/genesis.json

# Verify SHA-256 hash
sha256sum ~/.safrochain/config/genesis.json
# Expected: c05ac5aec1918df9edb257e8e0eea184d73edc51370eb4aa9f0b4f0aad615c4d
```

### 2.7 Configure Peers (config.toml)

```bash
SEEDS="bc772fdc9749e6dfd200a9428f07d86fe4fd34ec@seed.safrochain.network:26666,d323d296ba55e89fb6ce1a724f8da1740bd8cbb0@seed2.safrochain.network:26670"

sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" ~/.safrochain/config/config.toml
```

### 2.8 Configure app.toml

```bash
sed -i \
    -e 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.05usaf"|' \
    -e 's|^pruning *=.*|pruning = "default"|' \
    ~/.safrochain/config/app.toml
```

### 2.9 Create Systemd Service

```bash
sudo tee /etc/systemd/system/safrochaind.service > /dev/null << 'EOF'
[Unit]
Description=Safrochain Mainnet Node (Cosmovisor)
After=network-online.target

[Service]
Type=simple
User=root
ExecStart=/root/go/bin/cosmovisor run start --home /root/.safrochain
Restart=on-failure
RestartSec=5s
LimitNOFILE=1048576
TimeoutStopSec=30s
Environment="DAEMON_HOME=/root/.safrochain"
Environment="DAEMON_NAME=safrochaind"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable safrochaind
sudo systemctl start safrochaind
```

---

## 3. Wallet Operations

### Create Wallet

```bash
safrochaind keys add wallet --home ~/.safrochain
```

> **IMPORTANT:** Save your mnemonic phrase in a safe place. It cannot be recovered if lost.

### Recover Wallet

```bash
safrochaind keys add wallet --recover --home ~/.safrochain
# Enter your 24-word mnemonic when prompted
```

### List Wallets

```bash
safrochaind keys list --home ~/.safrochain
```

### Show Wallet Address

```bash
safrochaind keys show wallet -a --home ~/.safrochain
```

### Check Wallet Balance

```bash
safrochaind query bank balances $(safrochaind keys show wallet -a --home ~/.safrochain) \
    --node https://rpc.safrochain.network:443
```

---

## 4. Validator Operations

### Create Validator

Wait until your node is fully synced before creating a validator.

```bash
# Check validator pubkey
safrochaind tendermint show-validator --home ~/.safrochain

# Create validator.json
cat > $HOME/.safrochain/validator.json << EOF
{
  "pubkey": $(safrochaind tendermint show-validator --home ~/.safrochain),
  "amount": "1000000usaf",
  "moniker": "YOUR_MONIKER",
  "identity": "",
  "website": "",
  "security": "",
  "details": "Safrochain Mainnet Validator",
  "commission-rate": "0.10",
  "commission-max-rate": "0.20",
  "commission-max-change-rate": "0.01",
  "min-self-delegation": "1"
}
EOF

# Submit create-validator TX
safrochaind tx staking create-validator $HOME/.safrochain/validator.json \
    --from wallet \
    --chain-id safrochain-1 \
    --gas auto \
    --gas-adjustment 1.4 \
    --fees 300usaf \
    --home ~/.safrochain \
    -y
```

### Delegate Tokens

```bash
# Get your validator address
VAL_ADDR=$(safrochaind keys show wallet --bech val -a --home ~/.safrochain)

safrochaind tx staking delegate "$VAL_ADDR" 1000000usaf \
    --from wallet \
    --chain-id safrochain-1 \
    --gas auto \
    --gas-adjustment 1.5 \
    --gas-prices 0.05usaf \
    --home ~/.safrochain \
    -y
```

### Withdraw Rewards

```bash
VAL_ADDR=$(safrochaind keys show wallet --bech val -a --home ~/.safrochain)

safrochaind tx distribution withdraw-rewards "$VAL_ADDR" \
    --commission \
    --from wallet \
    --chain-id safrochain-1 \
    --gas auto \
    --gas-adjustment 1.5 \
    --gas-prices 0.05usaf \
    --home ~/.safrochain \
    -y
```

### Send Tokens

```bash
safrochaind tx bank send \
    $(safrochaind keys show wallet -a --home ~/.safrochain) \
    RECEIVER_ADDRESS \
    1000000usaf \
    --chain-id safrochain-1 \
    --gas auto \
    --gas-adjustment 1.5 \
    --gas-prices 0.05usaf \
    --home ~/.safrochain \
    -y
```

### Check Validator Status

```bash
# Your validator address
safrochaind keys show wallet --bech val -a --home ~/.safrochain

# Validator info
safrochaind query staking validator \
    $(safrochaind keys show wallet --bech val -a --home ~/.safrochain) \
    --node https://rpc.safrochain.network:443
```

---

## 5. Sync Status Check

```bash
# One-time check
curl -s http://localhost:26657/status | jq '.result.sync_info | {latest_block_height, catching_up}'

# Compare with network
LOCAL=$(curl -s http://localhost:26657/status | jq -r '.result.sync_info.latest_block_height')
NETWORK=$(curl -s https://rpc.safrochain.network/status | jq -r '.result.sync_info.latest_block_height')
echo "Local: $LOCAL | Network: $NETWORK | Behind: $((NETWORK - LOCAL)) blocks"
```

> If you used a custom port prefix during installation (e.g. `53`), replace `26657` with `53657`.

---

## 6. Useful Commands

### Service Management

```bash
# Start / stop / restart
sudo systemctl start safrochaind
sudo systemctl stop safrochaind
sudo systemctl restart safrochaind

# View status
sudo systemctl status safrochaind

# Live logs
sudo journalctl -fu safrochaind -o cat
```

### Node Info

```bash
# Node ID (share with others to connect)
safrochaind tendermint show-node-id --home ~/.safrochain

# Current block height
safrochaind status --home ~/.safrochain | jq '.SyncInfo.latest_block_height'

# Peers connected
curl -s localhost:26657/net_info | jq '.result.n_peers'
```

### Unjail Validator

```bash
safrochaind tx slashing unjail \
    --from wallet \
    --chain-id safrochain-1 \
    --gas auto \
    --gas-adjustment 1.5 \
    --gas-prices 0.05usaf \
    --home ~/.safrochain \
    -y
```

---

## 7. Delete Node

> **Warning:** This action is irreversible. Back up your key files first.

```bash
# Back up your keys
cp -r $HOME/.safrochain/keyring-file $HOME/safrochain_keyring_backup

# Stop and disable service
sudo systemctl stop safrochaind
sudo systemctl disable safrochaind
sudo rm -f /etc/systemd/system/safrochaind.service
sudo systemctl daemon-reload

# Remove node data and source
rm -rf $HOME/.safrochain
rm -rf $HOME/safrochain-node
```

---

## 8. Network Info

| Parameter | Value |
|-----------|-------|
| Chain ID | `safrochain-1` |
| Binary version | `v0.2.2` |
| Go version | `1.25.8` |
| Denom | `usaf` (1 SAF = 1,000,000 usaf) |
| Min gas price | `0.05usaf` |
| Genesis time | `2026-06-25T10:00:00Z` |
| RPC | `https://rpc.safrochain.network` |
| REST (API) | `https://api.safrochain.network` |
| gRPC | `https://grpc.safrochain.network` |
| Status | `https://status.safrochain.network` |
| Seed 1 | `bc772fdc9749e6dfd200a9428f07d86fe4fd34ec@seed.safrochain.network:26666` |
| Seed 2 | `d323d296ba55e89fb6ce1a724f8da1740bd8cbb0@seed2.safrochain.network:26670` |
| Genesis hash | `c05ac5aec1918df9edb257e8e0eea184d73edc51370eb4aa9f0b4f0aad615c4d` |

---

*Prepared by OshVanK*
