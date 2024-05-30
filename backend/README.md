# REST API TANAHKU

REST-API TANAHKU terintegrasi dengan smart contracts, dapat digunakan di blokchain EVM.

## Daftar Isi

- [Environment Variables](#environment-variables)
- [API Endpoints](#api-endpoints)
- [Deployment](#deployment)
- [Lisensi](#license)

## Environment Variables

Untuk menjalankan proyek ini, Anda perlu mengatur variabel lingkungan. Buat file `.env` di direktori root proyek Anda dan tambahkan variabel-variabel berikut:

| Variable    | Value                                  |
|-------------|----------------------------------------|
| PINATA_JWT  | [pinata](https://www.pinata.cloud/)    |
| JWT_SECRET  | risqiganteng                           |
| PRIVATE_KEY | [MetaMask](https://metamask.io/)       |
| HOST        | -                                      |
| PORT        | -                                      |

## API Endpoints

### `/login`

**Method:** POST

**Request:**
```json
{
    "username": "nailynafa",
    "password": "admin123"
}
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

### `/data/:id`

**Method:** GET

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
        "message": "Error add data"
    }
    ```
    or
    ```json
    {
        "status": false,
        "message": "Internal server error",
        "error": "error"
    }
    ```

### `/add`

**Method:** POST

**Request:**
```json
{
    "name": "naily nafa",
    "description": "tanah 1 hektar dekat gor bojonegoro",
    "image": fileImages,
    "urlLocation": "Desa NgumpakDalem 14/03",
}
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
        "message": "Error add data"
    }
    ```
    or
    ```json
    {
        "status": false,
        "message": "Internal server error",
        "error": "error"
    }
    ```

### `/update/:id`

**Method:** POST

**Request:**
```json
{
    "name": "naily nafa",
    "description": "tanah 2 hektar dekat gor bojonegoro",
    "image": fileImages,
    "urlLocation": "Desa NgumpakDalem 014/003",
}
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
        "message": "Error add data"
    }
    ```
    or
    ```json
    {
        "status": false,
        "message": "Internal server error",
        "error": "error"
    }
    ```

## Deployment

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
FROM node:18

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

## LICENSE


```plaintext
MIT License

Hak Cipta (c) [2024] [M. Khoirul Risqi]

Dengan ini, diizinkan secara cuma-cuma kepada siapa pun yang memperoleh salinan dari perangkat lunak ini dan file dokumentasinya (Perangkat Lunak), untuk berurusan dengan Perangkat Lunak tanpa batasan, termasuk hak tanpa batas untuk menggunakan, menyalin, mengubah, menggabungkan, menerbitkan, mendistribusikan, melisensikan ulang, dan/atau menjual salinan perangkat lunak, dan untuk mengizinkan orang-orang yang kepada siapa perangkat lunak ini disediakan untuk itu, tunduk pada ketentuan-ketentuan berikut:

Pernyataan hak cipta di atas dan pemberitahuan izin ini harus dimasukkan dalam semua salinan atau bagian penting dari Perangkat Lunak.

PERANGKAT LUNAK INI DISEDIAKAN "SEBAGAIMANA ADANYA", TANPA JAMINAN APA PUN, BAIK TERSURAT MAUPUN TERSIRAT, TERMASUK NAMUN TIDAK TERBATAS PADA JAMINAN DAGANG, KESESUAIAN UNTUK TUJUAN TERTENTU, DAN TANPA PELANGGARAN. DALAM HAL APA PUN, PENULIS ATAU PEMEGANG HAK CIPTA TIDAK BERTANGGUNG JAWAB ATAS KLAIM, KERUSAKAN, ATAU KEWAJIBAN LAINNYA, BAIK DALAM TINDAKAN KONTRAK, KERUGIAN, ATAU HAL LAINNYA, YANG TIMBUL DARI, KELUAR DARI, ATAU DALAM HUBUNGAN DENGAN PERANGKAT LUNAK ATAU PENGGUNAAN ATAU HUBUNGAN LAIN DALAM PERANGKAT LUNAK.
