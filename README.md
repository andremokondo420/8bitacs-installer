# 🚀 8bitACS — Auto Installer & Full Configuration Backup

**8bitACS**) adalah paket instalasi otomatis (all-in-one installer) dan sistem pemulihan penuh (full configuration backup) untuk **GenieACS** yang dirancang khusus untuk kebutuhan operasional ISP / RT-RW Net modern.

---

## ✨ Fitur & Modul Unggulan

- ⚡ **One-Click Auto Deployment (`install.sh`)**: Menginstal seluruh kebutuhan sistem secara otomatis di Ubuntu Server baru (Node.js 20.x, MongoDB 7.0, Python 3, GenieACS Core, hingga registrasi systemd services).
- 🔌 **Multi-Vendor ONT & OLT Ready**: Dilengkapi Virtual Parameters, Provisions, dan Presets siap pakai untuk pembacaan redaman (RX/TX Power), suhu perangkat, mode PON, PPPoE username/password, MAC address, uptime, hingga daftar perangkat aktif lintas vendor (ZTE, Huawei, FiberHome, C-Data, HSGQ, DBCOM, dll.).
- 📡 **Custom Collector & Extension Scripts (`/opt/genieacs/ext`)**: Terintegrasi langsung dengan skrip pengumpul data OLT **HSGQ**) (`hsgq-collector.py`, `hsgq.js`) dan **BDCOM**) (`bdcom-wifi.js`, `bdcom-presence.js`, `wifi-cache.js`) lengkap dengan sistem caching agar dashboard tetap ringan dan responsif.
- 🎨 **Custom Branding & Dashboard UI**: Dilengkapi kustomisasi tema, tampilan Overview, logo, dan tata letak antarmuka Web UI GenieACS untuk operasional harian NOC.
- 🔒 **Enkripsi Keamanan AES-256-CBC**: Seluruh aset konfigurasi dan database dikemas dalam arsip terenkiipsi (`8bitacs-full.enc`) untuk melindungi kredensial, parameter jaringan, dan skrip internal Anda.

---

## 🛠 Prasyarat Sistem

- **Sistem Operasi:** Ubuntu Server 20.04 LTS, 22.04 LTS, atau 24.04 LTS (64-bit)
- **Akses:** Hak akses `root` atau `sudo`
- **Koneksi Internet:** Diperlukan selama proses instalasi

---

## 💻 Panduan Instalasi

```bash
git clone https://github.com/andremokondo420/8bitacs-installer.git && cd 8bitacs-installer && sudo bash install.sh
```

Masukkan **Password Instalasi** saat diminta, lalu buka browser di `http://IP-SERVER:3000` (tekan `Ctrl + Shift + R` untuk hard refresh).

---

## 🔑 Informasi Password & Bantuan Teknis

- **WhatsApp:** `0822-6242-0020`
- **Email:** `andremokondo420@gmail.com`
- **Instagram:** `@andremokondo420`
