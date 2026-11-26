#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

clear

echo -e "${CYAN}"
cat << "BANNER"
   ___    _       _   _                 _____    _____ 
  / _ \  | |     (_) | |       /\      / ____|  / ____|
 | (_) | | |__    _  | |_     /  \    | |      | (___  
  > _ <  | '_ \  | | | __|   / /\ \   | |       \___ \ 
 | (_) | | |_) | | | | |_   / ____ \  | |____   ____) |
  \___/  |_.__/  |_|  \__| /_/    \_\  \_____| |_____/ 
BANNER
echo -e "${NC}"

echo -e "${YELLOW}------------------------------------------------------------${NC}"
echo -e "${WHITE}untuk password bisa hubungi saya${NC}"
echo -e "${GREEN}WA    : 0822-6242-0020${NC}"
echo -e "${CYAN}email : andremokondo420@gmail.com${NC}"
echo -e "${PURPLE}IG    : @andremokondo420${NC}"
echo -e "${YELLOW}------------------------------------------------------------${NC}\n"

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[ERROR] Jalankan sebagai root (sudo bash install.sh)${NC}" 
   exit 1
fi

if [ ! -f "8bitacs-full.enc" ]; then
    echo -e "${RED}[ERROR] File 8bitacs-full.enc tidak ditemukan!${NC}"
    exit 1
fi

echo -e "${CYAN}[1/6] Mendekripsi file backup 8bitACS...${NC}"
openssl enc -d -aes-256-cbc -pbkdf2 -in 8bitacs-full.enc -out 8bitacs-full.tar.gz
if [ $? -ne 0 ]; then
    echo -e "${RED}[GAGAL] Password salah atau file rusak!${NC}"
    rm -f 8bitacs-full.tar.gz
    exit 1
fi
echo -e "${GREEN}[OK] Dekripsi berhasil!${NC}\n"
echo -e "${CYAN}[2/6] Menginstall dependencies (Node.js, MongoDB, GenieACS)...${NC}"
apt-get update -y
apt-get install -y curl gnupg software-properties-common build-essential python3

if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
fi

if ! command -v mongod &> /dev/null; then
    curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
    apt-get update -y
    apt-get install -y mongodb-org
    systemctl enable --now mongod
fi

npm install -g genieacs@1.2.13
echo -e "${GREEN}[OK] Dependencies terinstall!${NC}\n"

echo -e "${CYAN}[3/6] Menghentikan service & me-restore Tema, UI, dan Konfigurasi...${NC}"
systemctl stop genieacs-cwmp genieacs-nbi genieacs-fs genieacs-ui 2>/dev/null || true
mkdir -p restore_temp
tar -xzf 8bitacs-full.tar.gz -C restore_temp

id -u genieacs &>/dev/null || useradd --system --no-create-home --user-group genieacs

TARGET_DIR="$(npm root -g)/genieacs"
if [ -d "restore_temp/genieacs_core" ] && [ -n "$TARGET_DIR" ]; then
    rm -rf "$TARGET_DIR"
    cp -rp restore_temp/genieacs_core "$TARGET_DIR"
fi

mkdir -p /opt/genieacs /etc/genieacs /var/log/genieacs
cp -rp restore_temp/opt_genieacs/* /opt/genieacs/ 2>/dev/null || true
cp -rp restore_temp/etc_genieacs/* /etc/genieacs/ 2>/dev/null || true
cp -p restore_temp/systemd/*.service /etc/systemd/system/ 2>/dev/null || true
[ -s restore_temp/crontab.bak ] && crontab restore_temp/crontab.bak

chown -R genieacs:genieacs /opt/genieacs /etc/genieacs /var/log/genieacs
chmod 600 /etc/genieacs/genieacs.env /opt/genieacs/genieacs.env 2>/dev/null || true
echo -e "${GREEN}[OK] Tema, UI, dan konfigurasi berhasil di-restore!${NC}\n"

echo -e "${CYAN}[4/6] Melakukan restore full database MongoDB...${NC}"
systemctl restart mongod
sleep 3
mongorestore --drop --db=genieacs restore_temp/mongodump/genieacs
echo -e "${GREEN}[OK] Database MongoDB berhasil di-restore!${NC}\n"

echo -e "${CYAN}[5/6] Menjalankan seluruh service GenieACS...${NC}"
systemctl daemon-reload
systemctl enable --now genieacs-cwmp genieacs-nbi genieacs-fs genieacs-ui
systemctl restart genieacs-cwmp genieacs-nbi genieacs-fs genieacs-ui
echo -e "${GREEN}[OK] Semua service aktif!${NC}\n"

echo -e "${CYAN}[6/6] Membersihkan file sementara...${NC}"
rm -rf restore_temp 8bitacs-full.tar.gz

IP_ADDR=$(hostname -I | awk '{print $1}')
echo -e "${YELLOW}------------------------------------------------------------${NC}"
echo -e "${GREEN}INSTALASI 8bitACS SELESAI (100% IDENTIK)!${NC}"
echo -e "${WHITE}Akses Web UI : ${CYAN}http://${IP_ADDR}:3000${NC}"
echo -e "${WHITE}Port CWMP    : ${CYAN}7547${NC}"
