### Langkah 1: Instal Docker

#### 1. Perbarui Repositori Paket
Perbarui daftar paket di sistem Anda untuk memastikan Anda mendapatkan versi terbaru dari paket-paket yang diperlukan.

```bash
sudo apt-get update
```

#### 2. Instal Dependensi yang Diperlukan
Instal beberapa paket pendukung yang diperlukan oleh Docker.

```bash
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

#### 3. Tambahkan GPG Key Resmi Docker
Buat direktori untuk menyimpan kunci GPG dan tambahkan kunci GPG resmi Docker.

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

#### 4. Tambahkan Docker APT Repository
Tambahkan repository Docker ke sumber APT Anda.

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

#### 5. Perbarui Kembali Repositori Paket
Perbarui kembali daftar paket setelah menambahkan repository Docker.

```bash
sudo apt-get update
```

#### 6. Instal Docker Engine
Instal Docker Engine, containerd, dan Docker Compose.

```bash
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Langkah 2: Deploy Aplikasi dengan Docker

#### 1. Buat Dockerfile
Buat file bernama `Dockerfile` di direktori proyek Anda jika belum ada. Isi file tersebut dengan instruksi untuk membangun image Docker Anda.

Contoh `Dockerfile` untuk aplikasi Express.js:
```Dockerfile
FROM node:14

# Set working directory
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["node", "server.js"]
```

#### 2. Bangun Image Docker
Bangun image Docker Anda dengan nama `tanahku` dan tag `latest`.

```bash
docker build -t tanahku:latest .
```

#### 3. Jalankan Kontainer Docker
Jalankan kontainer dari image yang baru saja Anda bangun. Mappkan port 80 di host ke port 3000 di kontainer. Berikan nama `tanahku` pada kontainer untuk mempermudah pengelolaan.

```bash
docker run -dp 80:3000 --name tanahku tanahku:latest
```

### Keterangan Tambahan
- `sudo apt-get update`: Memperbarui daftar paket di sistem.
- `sudo apt-get install -y ...`: Menginstal paket-paket yang diperlukan.
- `sudo mkdir -p /etc/apt/keyrings`: Membuat direktori untuk menyimpan kunci GPG.
- `curl -fsSL ... | sudo gpg --dearmor -o ...`: Mengunduh dan menyimpan kunci GPG Docker.
- `echo "deb [arch=$(dpkg --print-architecture) ... | sudo tee ...`: Menambahkan repository Docker ke sumber APT.
- `docker build -t tanahku:latest .`: Membuat image Docker dari `Dockerfile`.
- `docker run -dp 80:3000 --name tanahku tanahku:latest`: Menjalankan kontainer dari image yang dibuat, memetakan port 80 di host ke port 3000 di kontainer, dan memberikan nama `tanahku` pada kontainer.

Dengan mengikuti langkah-langkah ini, Anda akan memiliki Docker terinstal dan aplikasi Anda dideploy menggunakan Docker di VPS Linux Anda.
