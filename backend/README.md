## Dokumentasi API Tanahku

### Daftar Isi

- [Penjelasan](#penjelasan)
- [Environment Variables](#environment-variables)
- [API Endpoints](#api-endpoints)
- [Deployment](#deployment)

---

## Penjelasan

API Tanahku menerima data dan gambar melalui request ke backend. Gambar diproses oleh Multer dan disimpan sementara di direktori `uploads`. Selanjutnya, gambar diunggah ke Pinata, sebuah platform untuk IPFS yang memungkinkan penyimpanan terdesentralisasi. Setelah berhasil diunggah, Pinata mengembalikan `IpfsHash` yang disimpan dalam variabel Node.js. Data dari frontend, termasuk `IpfsHash`, disimpan dalam metadata NFT di smart contract. API backend kemudian mengirimkan respons yang sesuai.

## Install Dev and Run

### Instal Dependensi
```
npm install
```

### Menjalankan Server
```
node server.js
```

## Environment Variables

Untuk menjalankan proyek ini, Anda perlu mengatur variabel lingkungan. Buat file `.env` di direktori root proyek Anda dan tambahkan variabel-variabel berikut:

| Variable    | Deskripsi                               |
|-------------|-----------------------------------------|
| PINATA_JWT  | JWT dari [Pinata](https://www.pinata.cloud/)   |
| JWT_SECRET  | Rahasia JWT (misal: `risqiganteng`)     |
| PRIVATE_KEY | Kunci pribadi dari [MetaMask](https://metamask.io/) |
| HOST        | Host aplikasi (misal: `localhost`)      |
| PORT        | Port aplikasi (misal: `3000`)           |

---

## API Endpoints

### `/login`

**Method:** POST

**Request:**
```bash
curl -X POST "http://localhost:PORT/login" -H "Content-Type: application/json" -d '{"username": "nailynafa", "password": "admin123"}'
```

**Response:**

- **Success (200)**
  ```json
  {
      "status": true,
      "token": "xxxxxxx",
      "username": "nailynafa"
  }
  ```

- **Failed (200)**
  ```json
  {
      "status": false,
      "message": "Invalid username or password."
  }
  ```

- **Error (500)**
  ```json
  {
      "status": false,
      "error": "error.message"
  }
  ```

---

### `/data/:id`

**Method:** GET

**Request:**
```bash
curl -X GET "http://localhost:PORT/data/ID" -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Response:**

- **Success (200)**
  ```json
  {
      "status": true,
      "message": {
          "tokenId": "1",
          "name": "naily nafa",
          "description": "tanah 1 hektar dekat gor bojonegoro",
          "image": "https://ipfs.io/ipfs/QmYWHNK9oPSvv2cydLzjLosYNsp2tADyPWJLKUmPa14XBN",
          "urlLocation": "Desa NgumpakDalem 14/03",
          "creator": "0x714Cb1145218871fAebD55de36dBE7053cc9C74d",
          "createdAt": "2024-05-07T11:23:48.000Z"
      }
  }
  ```

- **Error (500)**
  ```json
  {
      "status": false,
      "message": "Error retrieving data"
  }
  ```

---

### `/add`

**Method:** POST

**Request:**
```bash
curl -X POST "http://localhost:PORT/add" -H "Authorization: Bearer YOUR_JWT_TOKEN" -H "Content-Type: application/json" -d '{
    "name": "naily nafa",
    "description": "tanah 1 hektar dekat gor bojonegoro",
    "image": "path/to/image.jpg",
    "urlLocation": "Desa NgumpakDalem 14/03"
}'
```

**Response:**

- **Success (200)**
  ```json
  {
      "status": true,
      "message": {
          "tokenId": "1",
          "name": "naily nafa",
          "description": "tanah 1 hektar dekat gor bojonegoro",
          "image": "https://ipfs.io/ipfs/QmYWHNK9oPSvv2cydLzjLosYNsp2tADyPWJLKUmPa14XBN",
          "urlLocation": "Desa NgumpakDalem 14/03",
          "creator": "0x714Cb1145218871fAebD55de36dBE7053cc9C74d",
          "createdAt": "2024-05-07T11:23:48.000Z"
      }
  }
  ```

- **Error (500)**
  ```json
  {
      "status": false,
      "message": "Error adding data"
  }
  ```

---

### `/update/:id`

**Method:** POST

**Request:**
```bash
curl -X POST "http://localhost:PORT/update/ID" -H "Authorization: Bearer YOUR_JWT_TOKEN" -H "Content-Type: application/json" -d '{
    "name": "naily nafa",
    "description": "tanah 2 hektar dekat gor bojonegoro",
    "image": "path/to/image.jpg",
    "urlLocation": "Desa NgumpakDalem 014/003"
}'
```

**Response:**

- **Success (200)**
  ```json
  {
      "status": true,
      "message": {
          "tokenId": "1",
          "name": "naily nafa",
          "description": "tanah 2 hektar dekat gor bojonegoro",
          "image": "https://ipfs.io/ipfs/QmYWHNK9oPSvv2cydLzjLosYNsp2tADyPWJLKUmPa14XBN",
          "urlLocation": "Desa NgumpakDalem 014/003",
          "creator": "0x714Cb1145218871fAebD55de36dBE7053cc9C74d",
          "createdAt": "2024-05-07T11:23:48.000Z"
      }
  }
  ```

- **Error (500)**
  ```json
  {
      "status": false,
      "message": "Error updating data"
  }
  ```

---

## Deployment

### Langkah 1: Instal Docker

#### 1. Perbarui Repositori Paket
Perbarui daftar paket di sistem Anda untuk memastikan mendapatkan versi terbaru dari paket-paket yang diperlukan.
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
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy package files dan install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of aplikasi code
COPY . .

# Expose port app runs on
EXPOSE 3000

# Command to run the aplikasi
CMD ["node", "server.js"]
```

#### 2. Bangun Image Docker
Bangun image Docker Anda dengan nama `tanahku` dan tag `latest`.
```bash
docker build -t tanahku:latest .
```

#### 3. Jalankan Kontainer Docker
Jalankan kontainer dari image yang baru saja Anda bangun. Map port 80 di host ke port 3000 di kontainer. Berikan nama `tanahku` pada kontainer untuk

 mempermudah pengelolaan.
```bash
docker run -dp 80:3000 --name tanahku tanahku:latest
```

---
