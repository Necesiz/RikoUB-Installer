#!/bin/bash

# --- RƏNGLƏR ---
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

clear
echo -e "${PURPLE}"
echo "  _____  _ _            _    _ ____  "
echo " |  __ \(_) |          | |  | |  _ \ "
echo " | |__) |_| | _____    | |  | | |_) |"
echo " |  _  /| | |/ / _ \   | |  | |  _ < "
echo " | | \ \| |   < (_) |  | |__| | |_) |"
echo " |_|  \_\_|_|\_\___/    \____/|____/ "
echo -e "${NC}"
echo -e "${CYAN}=======================================${NC}"
echo -e "${GREEN}    🛰  RIKO UB GLOBAL PUBLIC SYSTEM    ${NC}"
echo -e "${CYAN}        Developed by @REHIM_OFFICIALL   ${NC}"
echo -e "${CYAN}=======================================${NC}"

# 1. PAKETLƏRİN QURULMASI
echo -e "${YELLOW}📦 Sistem hazırlanır (Python və Git)...${NC}"
pkg update -y && pkg upgrade -y
pkg install python git -y

# 2. REPONU KLONLAYIRIQ (ARTIQ TOKENSİZ!)
echo -e "${YELLOW}📂 Fayllar GitHub-dan endirilir...${NC}"
rm -rf RikoUB
git clone https://github.com/REHIM_OFFICIALL/RikoUB.git
cd RikoUB

# 3. KİTABXANALAR
echo -e "${YELLOW}📚 Lazım olan modullar quraşdırılır...${NC}"
pip install -r requirements.txt
pip install telethon # Zəmanət üçün

# 4. MƏLUMATLARIN ALINMASI
clear
echo -e "${CYAN}---------------------------------------${NC}"
echo -e "${GREEN}🔐 Telegram API Məlumatlarını Daxil Et:${NC}"
read -p "🆔 API_ID: " api_id
read -p "🔑 API_HASH: " api_hash
echo -e "${CYAN}---------------------------------------${NC}"

# 5. STRİNG SESSİON SEÇİMİ
echo -e "${YELLOW}❓ String Session əməliyyatı:${NC}"
echo -e "1) Məndə String var (Yapışdıracam)"
echo -e "2) Yeni String yarat (İndi giriş et)"
read -p "Seçim (1/2): " choice

if [ "$choice" == "2" ]; then
    echo -e "${CYAN}🔄 Giriş paneli açılır...${NC}"
    # Müvəqqəti Python generatoru
    cat <<EOF > gen.py
from telethon.sync import TelegramClient
from telethon.sessions import StringSession
import os

try:
    with TelegramClient(StringSession(), int("$api_id"), "$api_hash") as client:
        session = client.session.save()
        print("\n" + "="*30)
        print("✅ SƏNİN STRİNG SESSİON-UN:")
        print(session)
        print("="*30 + "\n")
        with open("temp_session.txt", "w") as f:
            f.write(session)
except Exception as e:
    print(f"❌ Xəta: {e}")
EOF
    python3 gen.py
    session=$(cat temp_session.txt)
    rm gen.py temp_session.txt
else
    read -p "⚡ STRING_SESSION-u bura yapışdır: " session
fi

# 6. CONFIG.PY YARADILMASI
cat <<EOF > config.py
API_ID = $api_id
API_HASH = '$api_hash'
STRING_SESSION = '$session'
EOF

# 7. TAMAMLANMA VƏ START
clear
echo -e "${GREEN}✅ Quraşdırma uğurla bitdi!${NC}"
echo -e "${CYAN}🚀 RikoUB indi aktivləşdirilir...${NC}"
echo ""
python3 main.py
