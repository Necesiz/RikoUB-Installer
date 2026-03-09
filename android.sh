#!/bin/bash

# --- RƏNGLƏR ---
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${CYAN}=======================================${NC}"
echo -e "${GREEN}    🚀 RIKO UB GLOBAL INSTALLER        ${NC}"
echo -e "${CYAN}        Main Repo: Necesiz/1s          ${NC}"
echo -e "${CYAN}=======================================${NC}"

# 1. TƏMİZLİK
rm -rf 1s RikoUB

# 2. PAKETLƏR
echo -e "${YELLOW}📦 Sistem hazırlanır...${NC}"
pkg update -y && pkg upgrade -y
pkg install python git -y

# 3. ƏSAS KODU (1s) KLONLAYIRIQ
echo -e "${YELLOW}📂 Əsas fayllar (1s) endirilir...${NC}"
git clone https://github.com/Necesiz/1s.git

# Yoxlayırıq qovluq gəldimi
if [ ! -d "1s" ]; then
    echo -e "${RED}❌ Xəta: '1s' reposu tapılmadı!${NC}"
    echo -e "${YELLOW}GitHub-da '1s' reposunun Public olduğundan əmin ol.${NC}"
    exit 1
fi

cd 1s

# 4. QURAŞDIRMA
echo -e "${YELLOW}📚 Modullar yüklənir...${NC}"
pip install -r requirements.txt
pip install telethon

# 5. MƏLUMATLAR
clear
echo -e "${CYAN}---------------------------------------${NC}"
echo -e "${GREEN}🔐 Telegram Məlumatlarını Daxil Et:${NC}"
read -p "🆔 API_ID: " api_id
read -p "🔑 API_HASH: " api_hash
echo -e "${CYAN}---------------------------------------${NC}"

# 6. STRİNG SESSİON YARADICI
echo -e "${YELLOW}❓ String Session varmı?${NC}"
echo -e "1) Bəli, yapışdıracam."
echo -e "2) Xeyr, indi yarat (Giriş et)."
read -p "Seçim (1/2): " choice

if [ "$choice" == "2" ]; then
    python3 -c "from telethon.sync import TelegramClient; from telethon.sessions import StringSession; client=TelegramClient(StringSession(), $api_id, '$api_hash'); client.start(); print('\n✅ SƏNİN STRİNGİN:\n' + client.session.save() + '\n\nBunu kopyala!'); client.disconnect()"
    read -p "Kopyaladığın Stringi bura yapışdır: " session
else
    read -p "⚡ STRING_SESSION daxil et: " session
fi

# 7. CONFIG YARADILMASI
cat <<EOF > config.py
API_ID = $api_id
API_HASH = '$api_hash'
STRING_SESSION = '$session'
EOF

clear
echo -e "${GREEN}✅ Quraşdırma bitdi!${NC}"
echo -e "${YELLOW}🚀 Bot başladılır...${NC}"
python3 main.py
