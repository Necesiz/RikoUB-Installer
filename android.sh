        #!/bin/bash

# Rənglər
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear
echo -e "${CYAN}=======================================${NC}"
echo -e "${GREEN}    🚀 RikoUB GLOBAL QURAŞDIRICI      ${NC}"
echo -e "${CYAN}        Developed by @Necesiz          ${NC}"
echo -e "${CYAN}=======================================${NC}"

# 1. Paketlərin qurulması
echo -e "${YELLOW}📦 Sistem paketləri hazırlanır...${NC}"
pkg update -y && pkg upgrade -y
pkg install python git -y

# 2. REPONU YÜKLƏYİRİK (Düzgün Linklə)
echo -e "${YELLOW}📂 Fayllar GitHub-dan endirilir...${NC}"
rm -rf RikoUB
# Sənin yeni GitHub adınla yükləyirik:
git clone https://github.com/Necesiz/RikoUB.git

# BURADA YOXLAYIRIQ: Qovluq yarandımı?
if [ ! -d "RikoUB" ]; then
    echo -e "${RED}❌ Xəta: Fayllar endirilmədi! GitHub linkini yoxla.${NC}"
    exit 1
fi

cd RikoUB

# 3. Modullar
echo -e "${YELLOW}📚 Lazım olan modullar qurulur...${NC}"
pip install -r requirements.txt
pip install telethon

# 4. Məlumatlar
echo -e "${CYAN}---------------------------------------${NC}"
read -p "🆔 API_ID: " api_id
read -p "🔑 API_HASH: " api_hash
echo -e "${CYAN}---------------------------------------${NC}"

# 5. STRİNG SESSİON YARADICI (Sənin istədiyin kimi)
echo -e "${YELLOW}❓ String Session əməliyyatı:${NC}"
echo -e "1) Məndə String var."
echo -e "2) Yeni String yarat (İndi giriş et)."
read -p "Seçim (1/2): " choice

if [ "$choice" == "2" ]; then
    echo -e "${CYAN}🔄 String Yaradıcı başladılır...${NC}"
    cat <<EOF > gen_session.py
from telethon.sync import TelegramClient
from telethon.sessions import StringSession
try:
    with TelegramClient(StringSession(), $api_id, "$api_hash") as client:
        session = client.session.save()
        print("\n\n✅ SƏNİN STRİNG SESSİON-UN:\n" + session + "\n")
        with open("session_result.txt", "w") as f: f.write(session)
except Exception as e:
    print(f"Xəta: {e}")
EOF
    python3 gen_session.py
    session=$(cat session_result.txt)
    rm gen_session.py session_result.txt
else
    read -p "⚡ STRING_SESSION-u yapışdır: " session
fi

# 6. CONFIG YARADILMASI
cat <<EOF > config.py
API_ID = $api_id
API_HASH = '$api_hash'
STRING_SESSION = '$session'
EOF

clear
echo -e "${GREEN}✅ Quraşdırma tamamlandı!${NC}"
echo -e "${YELLOW}🚀 Bot başladılır...${NC}"
python3 main.py
