#!/bin/bash

# ============================================================
# Safrochain Mainnet Setup Script
# Prepared by: OshVanK
# Chain: safrochain-1 | Version: v0.2.2 | Go: 1.25.8
# ============================================================

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# ASCII Art
print_logo() {
    echo -e "${CYAN}"
    echo " _______  _______                    _______  _        _       "
    echo "(  ___  )(  ____ \|\     /||\     /|(  ___  )( (    /|| \    /\ "
    echo "| (   ) || (    \/| )   ( || )   ( || (   ) ||  \  ( ||  \  / / "
    echo "| |   | || (_____ | (___) || |   | || (___) ||   \ | ||  (_/ /  "
    echo "| |   | |(_____  )|  ___  |( (   ) )|  ___  || (\ \) ||   _ (   "
    echo "| |   | |      ) || (   ) | \ \_/ / | (   ) || | \   ||  ( \ \  "
    echo "| (___) |/\____) || )   ( |  \   /  | )   ( || )  \  ||  /  \ \ "
    echo "(_______)\_______)|/     \|   \_/   |/     \||/    )_)|_/    \_\\"
    echo -e "${NC}"
    echo
    echo -e "${YELLOW}============================================================${NC}"
    echo -e "${WHITE}         Safrochain Mainnet Setup Script${NC}"
    echo -e "${WHITE}              Prepared by: OshVanK${NC}"
    echo -e "${YELLOW}============================================================${NC}"
    echo
}

# Dil seçimi
select_language() {
    clear
    print_logo
    echo -e "${YELLOW}Select Language / Dil Seçin:${NC}"
    echo
    echo -e "${CYAN}1)${NC} English"
    echo -e "${CYAN}2)${NC} Türkçe"
    echo
    read -p "$(echo -e ${GREEN}Your choice / Seçiminiz: ${NC})" lang_choice

    case $lang_choice in
        1) LANG="EN" ;;
        2) LANG="TR" ;;
        *) echo -e "${RED}Invalid choice!${NC}"; sleep 2; select_language ;;
    esac
}

# Dil bazlı metinler
get_text() {
    local key=$1
    if [ "$LANG" = "EN" ]; then
        case $key in
            "main_menu")           echo "MAIN MENU" ;;
            "installation")        echo "Installation" ;;
            "logs")                echo "View Logs" ;;
            "create_wallet")       echo "Create Wallet" ;;
            "recover_wallet")      echo "Recover Wallet" ;;
            "list_wallets")        echo "List Wallets" ;;
            "create_validator")    echo "Create Validator" ;;
            "delegate")            echo "Delegate Tokens" ;;
            "withdraw_rewards")    echo "Withdraw Rewards" ;;
            "send_tokens")         echo "Send Tokens" ;;
            "sync_check")          echo "Sync Status Check" ;;
            "delete_node")         echo "Delete Node" ;;
            "exit")                echo "Exit" ;;
            "enter_choice")        echo "Enter your choice" ;;
            "press_enter")         echo "Press ENTER to continue" ;;
            "success")             echo "SUCCESS" ;;
            "error")               echo "ERROR" ;;
            "checking_go")         echo "Checking Go version..." ;;
            "installing_go")       echo "Installing Go 1.25.8..." ;;
            "go_ok")               echo "Go 1.25.8 is already installed." ;;
            "go_updated")          echo "Go updated to 1.25.8. Existing node binaries (lumerad, gnoland, etc.) are NOT affected — they are pre-compiled and do not require Go at runtime." ;;
            "go_old_warn")         echo "WARNING: Detected older Go version. Updating /usr/local/go only. Your existing compiled binaries remain untouched." ;;
            "node_name")           echo "Enter your node name (MONIKER)" ;;
            "port_prefix")         echo "Enter port prefix (10-65, default: 26)" ;;
            "wallet_name")         echo "Enter wallet name (default: wallet)" ;;
            "installation_complete") echo "Installation completed successfully!" ;;
            "wallet_created")      echo "Wallet created! SAVE YOUR MNEMONIC PHRASE!" ;;
            "enter_seed")          echo "Enter your seed phrase" ;;
            "wallet_recovered")    echo "Wallet recovered successfully!" ;;
            "validator_created")   echo "Validator creation TX sent!" ;;
            "tokens_delegated")    echo "Delegation TX sent!" ;;
            "rewards_withdrawn")   echo "Withdraw TX sent!" ;;
            "tokens_sent")         echo "Send TX sent!" ;;
            "exit_ctrl_c")         echo "Press CTRL+C to exit and return to menu" ;;
            "confirm_delete")      echo "WARNING: This will completely remove the node. Type 'YES' to confirm" ;;
            "node_deleted")        echo "Node deleted successfully." ;;
            "delete_cancelled")    echo "Deletion cancelled." ;;
            "amount_usaf")         echo "Amount (in usaf, e.g. 1000000)" ;;
            "receiver_addr")       echo "Receiver address" ;;
        esac
    else
        case $key in
            "main_menu")           echo "ANA MENÜ" ;;
            "installation")        echo "Kurulum" ;;
            "logs")                echo "Logları Görüntüle" ;;
            "create_wallet")       echo "Cüzdan Oluştur" ;;
            "recover_wallet")      echo "Cüzdan Kurtar" ;;
            "list_wallets")        echo "Cüzdanları Listele" ;;
            "create_validator")    echo "Validator Oluştur" ;;
            "delegate")            echo "Token Stake Et" ;;
            "withdraw_rewards")    echo "Ödülleri Çek" ;;
            "send_tokens")         echo "Token Gönder" ;;
            "sync_check")          echo "Senkronizasyon Kontrolü" ;;
            "delete_node")         echo "Node'u Sil" ;;
            "exit")                echo "Çıkış" ;;
            "enter_choice")        echo "Seçiminizi girin" ;;
            "press_enter")         echo "Devam etmek için ENTER'a basın" ;;
            "success")             echo "BAŞARILI" ;;
            "error")               echo "HATA" ;;
            "checking_go")         echo "Go versiyonu kontrol ediliyor..." ;;
            "installing_go")       echo "Go 1.25.8 yükleniyor..." ;;
            "go_ok")               echo "Go 1.25.8 zaten yüklü." ;;
            "go_updated")          echo "Go 1.25.8'e güncellendi. Sunucudaki mevcut node binary'leri (lumerad, gnoland vb.) etkilenmez — bunlar önceden derlenmiş dosyalardır, çalışmak için Go gerektirmezler." ;;
            "go_old_warn")         echo "UYARI: Eski Go versiyonu tespit edildi. Yalnızca /usr/local/go güncelleniyor. Mevcut derlenmiş binary'leriniz değiştirilmiyor." ;;
            "node_name")           echo "Node adınızı girin (MONIKER)" ;;
            "port_prefix")         echo "Port prefix'i girin (10-65, varsayılan: 26)" ;;
            "wallet_name")         echo "Cüzdan adını girin (varsayılan: wallet)" ;;
            "installation_complete") echo "Kurulum başarıyla tamamlandı!" ;;
            "wallet_created")      echo "Cüzdan oluşturuldu! MNEMONIC PHRASE'İNİZİ KAYDEDIN!" ;;
            "enter_seed")          echo "Seed phrase'inizi girin" ;;
            "wallet_recovered")    echo "Cüzdan başarıyla kurtarıldı!" ;;
            "validator_created")   echo "Validator oluşturma TX gönderildi!" ;;
            "tokens_delegated")    echo "Stake TX gönderildi!" ;;
            "rewards_withdrawn")   echo "Çekme TX gönderildi!" ;;
            "tokens_sent")         echo "Gönderme TX gönderildi!" ;;
            "exit_ctrl_c")         echo "Çıkmak ve menüye dönmek için CTRL+C'ye basın" ;;
            "confirm_delete")      echo "UYARI: Bu işlem node'u tamamen kaldıracak. Onaylamak için 'YES' yazın" ;;
            "node_deleted")        echo "Node başarıyla silindi." ;;
            "delete_cancelled")    echo "Silme işlemi iptal edildi." ;;
            "amount_usaf")         echo "Miktar (usaf cinsinden, örn: 1000000)" ;;
            "receiver_addr")       echo "Alıcı adresi" ;;
        esac
    fi
}

# ─────────────────────────────────────────────
# Go Versiyon Kontrolü
# Sadece /usr/local/go güncellenir.
# ~/go/bin içindeki mevcut binary'ler (lumerad, gnoland, gnokey, cosmovisor, atomoned vb.)
# önceden derlenmiş statik binary'lerdir — Go runtime gerektirmezler, etkilenmezler.
# ─────────────────────────────────────────────
check_and_install_go() {
    echo -e "${YELLOW}$(get_text 'checking_go')${NC}"

    REQUIRED="1.25.8"

    if command -v go &>/dev/null; then
        CURRENT=$(go version | awk '{print $3}' | sed 's/go//')
        if [ "$CURRENT" = "$REQUIRED" ]; then
            echo -e "${GREEN}$(get_text 'go_ok')${NC}"
            return
        else
            echo -e "${YELLOW}$(get_text 'go_old_warn')${NC}"
            echo -e "${CYAN}  Mevcut / Current: $CURRENT  →  Hedef / Target: $REQUIRED${NC}"
        fi
    else
        echo -e "${YELLOW}$(get_text 'installing_go')${NC}"
    fi

    # Sadece /usr/local/go değiştiriliyor
    cd $HOME
    wget -q --show-progress "https://go.dev/dl/go${REQUIRED}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go${REQUIRED}.linux-amd64.tar.gz"
    rm "go${REQUIRED}.linux-amd64.tar.gz"

    # PATH zaten ~/.bashrc'de varsa tekrar ekleme
    if ! grep -q '/usr/local/go/bin' ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
    fi
    source ~/.bashrc

    echo -e "${GREEN}$(get_text 'go_updated')${NC}"
}

# ─────────────────────────────────────────────
# KURULUM
# ─────────────────────────────────────────────
installation() {
    clear
    print_logo
    echo -e "${CYAN}=== $(get_text 'installation') ===${NC}"
    echo

    # Kullanıcı girdileri
    read -p "$(echo -e ${GREEN}$(get_text 'node_name'): ${NC})" MONIKER
    read -p "$(echo -e ${GREEN}$(get_text 'port_prefix') [26]: ${NC})" PORT_PREFIX
    PORT_PREFIX=${PORT_PREFIX:-26}
    read -p "$(echo -e ${GREEN}$(get_text 'wallet_name') [wallet]: ${NC})" WALLET_NAME
    WALLET_NAME=${WALLET_NAME:-wallet}

    # Değişkenleri kaydet
    export MONIKER="$MONIKER"
    export PORT_PREFIX="$PORT_PREFIX"
    export WALLET_NAME="$WALLET_NAME"

    sed -i '/^export MONIKER=/d;/^export WALLET_NAME=/d;/^export PORT_PREFIX=/d;/^export SAFROCHAIN_PORT=/d' ~/.bashrc
    {
        echo "export MONIKER=\"$MONIKER\""
        echo "export WALLET_NAME=\"$WALLET_NAME\""
        echo "export PORT_PREFIX=\"$PORT_PREFIX\""
        echo "export SAFROCHAIN_PORT=\"$PORT_PREFIX\""
    } >> ~/.bashrc
    source ~/.bashrc

    # Go kontrolü
    check_and_install_go
    source ~/.bashrc

    # Sistem bağımlılıkları
    echo -e "${YELLOW}Installing system dependencies...${NC}"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y curl git wget htop tmux build-essential jq make lz4 gcc unzip snapd

    # Kaynak kodu klonla ve derle
    echo -e "${YELLOW}Cloning and building safrochaind v0.2.2...${NC}"
    cd $HOME
    rm -rf safrochain-node
    git clone https://github.com/Safrochain-Org/safrochain-node ~/safrochain-node
    cd ~/safrochain-node
    git fetch --tags
    git checkout v0.2.2
    make install

    # Versiyon doğrulama
    echo -e "${YELLOW}Verifying binary...${NC}"
    safrochaind version
    if [ $? -ne 0 ]; then
        echo -e "${RED}$(get_text 'error'): safrochaind binary not found in PATH. Check make install output.${NC}"
        read -p "$(echo -e ${YELLOW}$(get_text 'press_enter')${NC})"
        return
    fi

    # Cosmovisor kurulumu
    echo -e "${YELLOW}Installing Cosmovisor...${NC}"
    go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@latest
    mkdir -p $HOME/.safrochain/cosmovisor/genesis/bin
    mkdir -p $HOME/.safrochain/cosmovisor/upgrades
    cp $(which safrochaind) $HOME/.safrochain/cosmovisor/genesis/bin/safrochaind
    sudo ln -sfn $HOME/.safrochain/cosmovisor/genesis $HOME/.safrochain/cosmovisor/current

    # Initialize
    echo -e "${YELLOW}Initializing node...${NC}"
    safrochaind init "$MONIKER" --chain-id safrochain-1 --home ~/.safrochain

    # client.toml
    mkdir -p $HOME/.safrochain/config
    cat > $HOME/.safrochain/config/client.toml << EOF
chain-id = "safrochain-1"
keyring-backend = "file"
output = "json"
node = "tcp://localhost:${PORT_PREFIX}657"
broadcast-mode = "sync"
EOF

    # Port ayarları (config.toml)
    sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT_PREFIX}658\"%" \
           -e "s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT_PREFIX}657\"%" \
           -e "s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT_PREFIX}060\"%" \
           -e "s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT_PREFIX}656\"%" \
           -e "s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT_PREFIX}660\"%" \
           $HOME/.safrochain/config/config.toml

    # Port ayarları (app.toml)
    sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${PORT_PREFIX}317\"%" \
           -e "s%^address = \":8080\"%address = \":${PORT_PREFIX}080\"%" \
           -e "s%^address = \"localhost:9090\"%address = \"localhost:${PORT_PREFIX}090\"%" \
           -e "s%^address = \"localhost:9091\"%address = \"localhost:${PORT_PREFIX}091\"%" \
           $HOME/.safrochain/config/app.toml

    # Genesis indir ve doğrula
    echo -e "${YELLOW}Downloading and verifying genesis...${NC}"
    curl -L https://raw.githubusercontent.com/Safrochain-Org/mainnet-genesis/main/genesis.json \
        -o ~/.safrochain/config/genesis.json

    EXPECTED_HASH="c05ac5aec1918df9edb257e8e0eea184d73edc51370eb4aa9f0b4f0aad615c4d"
    ACTUAL_HASH=$(sha256sum ~/.safrochain/config/genesis.json | awk '{print $1}')

    if [ "$ACTUAL_HASH" = "$EXPECTED_HASH" ]; then
        echo -e "${GREEN}Genesis hash verified OK${NC}"
    else
        echo -e "${RED}Genesis hash MISMATCH! Expected: $EXPECTED_HASH | Got: $ACTUAL_HASH${NC}"
        echo -e "${RED}Aborting installation for safety.${NC}"
        read -p "$(echo -e ${YELLOW}$(get_text 'press_enter')${NC})"
        return
    fi

    # Seeds ve config ayarları
    SEEDS="bc772fdc9749e6dfd200a9428f07d86fe4fd34ec@seed.safrochain.network:26666,d323d296ba55e89fb6ce1a724f8da1740bd8cbb0@seed2.safrochain.network:26670"
    sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" \
           -e "s|^addr_book_strict *=.*|addr_book_strict = true|" \
           -e "s|^pex *=.*|pex = true|" \
           $HOME/.safrochain/config/config.toml

    sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.05usaf\"|" \
           -e "s|^pruning *=.*|pruning = \"default\"|" \
           -e "s|^pruning-keep-recent *=.*|pruning-keep-recent = \"100\"|" \
           -e "s|^pruning-interval *=.*|pruning-interval = \"10\"|" \
           $HOME/.safrochain/config/app.toml

    # Systemd service
    sudo tee /etc/systemd/system/safrochaind.service > /dev/null << EOF
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

    echo
    echo -e "${GREEN}$(get_text 'installation_complete')${NC}"
    echo -e "${CYAN}Chain: safrochain-1 | Version: v0.2.2${NC}"
    echo
    read -p "$(echo -e ${YELLOW}$(get_text 'press_enter')${NC})"
}

# ─────────────────────────────────────────────
# LOGLAR
# ─────────────────────────────────────────────
view_logs() {
    clear
    print_logo
    echo -e "${CYAN}=== $(get_text 'logs') ===${NC}"
    echo -e "${YELLOW}$(get_text 'exit_ctrl_c')${NC}"
    echo
    sleep 1
    sudo journalctl -fu safrochaind -o cat
}

# ─────────────────────────────────────────────
# CÜZDAN OLUŞTUR
# ─────────────────────────────────────────────
create_wallet() {
    clear
    print_logo
    echo -e "${CYAN}=== $(get_text 'create_wallet') ===${NC}"
    echo
    source ~/.bashrc
    safrochaind keys add "$WALLET_NAME" --home ~/.safrochain
    echo
    echo -e "${GREEN}$(get_text 'wallet_created')${NC}"
    echo
    read -p "$(echo -e ${YELLOW}$(get_text 'press_enter')${NC})"
}

# ─────────────────────────────────────────────
# CÜZDAN KURTAR
# ─────────────────────────────────────────────
recover_wallet() {
    clear
    print_logo
    echo -e "${CYAN}=== $(get_text 'recover_wallet') ===${NC}"
    echo
    source ~/.bashrc
    safrochaind keys add "$WALLET_NAME" --recover --home ~/.safrochain
    echo
    echo -e "${GREEN}$(get_text 'wallet_recovered')${NC}"
    echo
    read -p "$(echo -e ${YELLOW}$(get_text 'press_enter')${NC})"
}

# ─────────────────────────────────────────────
# CÜZDANLARI LİSTELE
# ─────────────────────────────────────────────
list_wallets() {
    clear
    print_logo
    echo -e "${CYAN}=== $(get_text 'list_wallets') ===${NC}"
    echo
    safrochaind keys list --home ~/.safrochain
    echo
    read -p "$(echo -e ${YELLOW}$(get_text 'press_enter')${NC})"
}

# ─────────────────────────────────────────────
# VALİDATOR OLUŞTUR
# ─────────────────────────────────────────────
create_validator() {
    clear
    print_logo
    echo -e "${CYAN}=== $(get_text 'create_validator') ===${NC}"
    echo
    source ~/.bashrc

    VAL_PUBKEY=$(safrochaind tendermint show-validator --home ~/.safrochain)

    cat > $HOME/.safrochain/validator.json << EOF
{
  "pubkey": $VAL_PUBKEY,
  "amount": "1000000usaf",
  "moniker": "$MONIKER",
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

    safrochaind tx staking create-validator $HOME/.safrochain/validator.json \
        --from="$WALLET_NAME" \
        --chain-id=safrochain-1 \
        --gas=auto \
        --gas-adjustment=1.4 \
        --fees=300usaf \
        --home ~/.safrochain \
        -y

    echo
    echo -e "${GREEN}$(get_text 'validator_created')${NC}"
    echo
    read -p "$(echo -e ${YELLOW}$(get_text 'press_enter')${NC})"
}

# ─────────────────────────────────────────────
# DELEGATE
# ─────────────────────────────────────────────
delegate_tokens() {
    clear
    print_logo
    echo -e "${CYAN}=== $(get_text 'delegate') ===${NC}"
    echo
    source ~/.bashrc

    read -p "$(echo -e ${GREEN}$(get_text 'amount_usaf'): ${NC})" AMOUNT

    VAL_ADDR=$(safrochaind keys show "$WALLET_NAME" --bech val -a --home ~/.safrochain)

    safrochaind tx staking delegate "$VAL_ADDR" "${AMOUNT}usaf" \
        --chain-id safrochain-1 \
        --from "$WALLET_NAME" \
        --gas auto \
        --gas-adjustment 1.5 \
        --gas-prices 0.05usaf \
        --home ~/.safrochain \
        -y

    echo
    echo -e "${GREEN}$(get_text 'tokens_delegated')${NC}"
    echo
    read -p "$(echo -e ${YELLOW}$(get_text 'press_enter')${NC})"
}

# ─────────────────────────────────────────────
# ÖDÜL ÇEK
# ─────────────────────────────────────────────
withdraw_rewards() {
    clear
    print_logo
    echo -e "${CYAN}=== $(get_text 'withdraw_rewards') ===${NC}"
    echo
    source ~/.bashrc

    VAL_ADDR=$(safrochaind keys show "$WALLET_NAME" --bech val -a --home ~/.safrochain)

    safrochaind tx distribution withdraw-rewards "$VAL_ADDR" \
        --commission \
        --chain-id safrochain-1 \
        --from "$WALLET_NAME" \
        --gas auto \
        --gas-adjustment 1.5 \
        --gas-prices 0.05usaf \
        --home ~/.safrochain \
        -y

    echo
    echo -e "${GREEN}$(get_text 'rewards_withdrawn')${NC}"
    echo
    read -p "$(echo -e ${YELLOW}$(get_text 'press_enter')${NC})"
}

# ─────────────────────────────────────────────
# TOKEN GÖNDER
# ─────────────────────────────────────────────
send_tokens() {
    clear
    print_logo
    echo -e "${CYAN}=== $(get_text 'send_tokens') ===${NC}"
    echo
    source ~/.bashrc

    read -p "$(echo -e ${GREEN}$(get_text 'receiver_addr'): ${NC})" RECEIVER
    read -p "$(echo -e ${GREEN}$(get_text 'amount_usaf'): ${NC})" AMOUNT

    SENDER=$(safrochaind keys show "$WALLET_NAME" -a --home ~/.safrochain)

    safrochaind tx bank send "$SENDER" "$RECEIVER" "${AMOUNT}usaf" \
        --chain-id safrochain-1 \
        --gas auto \
        --gas-adjustment 1.5 \
        --gas-prices 0.05usaf \
        --home ~/.safrochain \
        -y

    echo
    echo -e "${GREEN}$(get_text 'tokens_sent')${NC}"
    echo
    read -p "$(echo -e ${YELLOW}$(get_text 'press_enter')${NC})"
}

# ─────────────────────────────────────────────
# SYNC KONTROLÜ
# ─────────────────────────────────────────────
sync_check() {
    clear
    print_logo
    echo -e "${CYAN}=== $(get_text 'sync_check') ===${NC}"
    echo -e "${YELLOW}$(get_text 'exit_ctrl_c')${NC}"
    echo
    sleep 1

    source ~/.bashrc
    RPC_PORT="${PORT_PREFIX}657"

    while true; do
        LOCAL_HEIGHT=$(curl -s "localhost:$RPC_PORT/status" 2>/dev/null | jq -r '.result.sync_info.latest_block_height')
        NETWORK_HEIGHT=$(curl -s "https://rpc.safrochain.network/status" 2>/dev/null | jq -r '.result.sync_info.latest_block_height')

        if ! [[ "$LOCAL_HEIGHT" =~ ^[0-9]+$ ]] || ! [[ "$NETWORK_HEIGHT" =~ ^[0-9]+$ ]]; then
            echo -e "${RED}Waiting for node to respond... (RPC port: $RPC_PORT)${NC}"
            sleep 5
            continue
        fi

        BLOCKS_LEFT=$((NETWORK_HEIGHT - LOCAL_HEIGHT))
        CATCHING_UP=$(curl -s "localhost:$RPC_PORT/status" 2>/dev/null | jq -r '.result.sync_info.catching_up')

        if [ "$CATCHING_UP" = "false" ]; then
            SYNC_STATUS="${GREEN}SYNCED ✓${NC}"
        else
            SYNC_STATUS="${YELLOW}SYNCING...${NC}"
        fi

        echo -e "${YELLOW}Local:${BLUE} $LOCAL_HEIGHT${NC} | ${YELLOW}Network:${CYAN} $NETWORK_HEIGHT${NC} | ${YELLOW}Behind:${RED} $BLOCKS_LEFT blocks${NC} | $SYNC_STATUS"
        sleep 5
    done
}

# ─────────────────────────────────────────────
# NODE SİL
# ─────────────────────────────────────────────
delete_node() {
    clear
    print_logo
    echo -e "${RED}=== $(get_text 'delete_node') ===${NC}"
    echo
    echo -e "${RED}$(get_text 'confirm_delete'):${NC}"
    read -p "" CONFIRM

    if [ "$CONFIRM" = "YES" ]; then
        sudo systemctl stop safrochaind
        sudo systemctl disable safrochaind
        sudo rm -f /etc/systemd/system/safrochaind.service
        sudo systemctl daemon-reload
        rm -rf $HOME/.safrochain
        rm -rf $HOME/safrochain-node
        sed -i '/^export MONIKER=/d;/^export WALLET_NAME=/d;/^export PORT_PREFIX=/d;/^export SAFROCHAIN_PORT=/d' ~/.bashrc
        echo
        echo -e "${GREEN}$(get_text 'node_deleted')${NC}"
    else
        echo -e "${YELLOW}$(get_text 'delete_cancelled')${NC}"
    fi

    echo
    read -p "$(echo -e ${YELLOW}$(get_text 'press_enter')${NC})"
}

# ─────────────────────────────────────────────
# ANA MENÜ
# ─────────────────────────────────────────────
main_menu() {
    while true; do
        clear
        print_logo
        echo -e "${YELLOW}=== $(get_text 'main_menu') ===${NC}"
        echo -e "${PURPLE}  Chain: safrochain-1 | v0.2.2 | Go 1.25.8${NC}"
        echo
        echo -e "${CYAN} 1)${NC} $(get_text 'installation')"
        echo -e "${CYAN} 2)${NC} $(get_text 'logs')"
        echo -e "${CYAN} 3)${NC} $(get_text 'create_wallet')"
        echo -e "${CYAN} 4)${NC} $(get_text 'recover_wallet')"
        echo -e "${CYAN} 5)${NC} $(get_text 'list_wallets')"
        echo -e "${CYAN} 6)${NC} $(get_text 'create_validator')"
        echo -e "${CYAN} 7)${NC} $(get_text 'delegate')"
        echo -e "${CYAN} 8)${NC} $(get_text 'withdraw_rewards')"
        echo -e "${CYAN} 9)${NC} $(get_text 'send_tokens')"
        echo -e "${CYAN}10)${NC} $(get_text 'sync_check')"
        echo -e "${RED}11)${NC} $(get_text 'delete_node')"
        echo -e "${CYAN} 0)${NC} $(get_text 'exit')"
        echo
        read -p "$(echo -e ${GREEN}$(get_text 'enter_choice'): ${NC})" choice

        case $choice in
            1)  installation ;;
            2)  view_logs ;;
            3)  create_wallet ;;
            4)  recover_wallet ;;
            5)  list_wallets ;;
            6)  create_validator ;;
            7)  delegate_tokens ;;
            8)  withdraw_rewards ;;
            9)  send_tokens ;;
            10) sync_check ;;
            11) delete_node ;;
            0)  echo -e "${GREEN}Goodbye! / Hoşça kal!${NC}"; exit 0 ;;
            *)  echo -e "${RED}Invalid choice!${NC}"; sleep 2 ;;
        esac
    done
}

# ─────────────────────────────────────────────
# Başlangıç
# ─────────────────────────────────────────────
select_language
main_menu
