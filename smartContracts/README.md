# Panduan Menambahkan Jaringan Kustom ke MetaMask dan Deploy Smart Contract di Remix

## Menginstal MetaMask
Unduh dan Instal MetaMask:

Kunjungi situs resmi [MetaMask](https://metamask.io/) dan pilih Download.
Pilih browser Anda (Chrome, Firefox, Brave, Edge) dan ikuti petunjuk untuk menginstal ekstensi MetaMask.
Buat Wallet Baru:

Klik ikon MetaMask di toolbar browser Anda untuk membuka ekstensi.
Klik Get Started.
Pilih Create a Wallet.
Buat kata sandi yang kuat dan ikuti petunjuk untuk menyimpan frasa pemulihan (seed phrase) Anda. Penting: Simpan frasa pemulihan di tempat yang aman dan jangan bagikan kepada siapapun.

## Langkah 1: Menambahkan Jaringan Testnet Kustom ke MetaMask

1. **Buka MetaMask**:
   - Klik ikon MetaMask di toolbar browser.

2. **Tambahkan Jaringan Kustom**:
   - Klik ikon jaringan di bagian atas (misalnya, `Ethereum Mainnet`).
   - Pilih `Add Network`.

3. **Isi Detail Jaringan Kustom**:
   - Isi informasi jaringan kustom:
     - **Network Name**: Nama jaringan Anda
     - **New RPC URL**: URL RPC jaringan Anda
     - **Chain ID**: Chain ID jaringan Anda
     - **Currency Symbol**: Simbol mata uang jaringan Anda
     - **Block Explorer URL**: URL block explorer jaringan Anda (opsional)
   - Klik `Save`.

## Langkah 2: Menghubungkan MetaMask ke Jaringan Kustom

1. **Pilih Jaringan Kustom**:
   - Pilih jaringan kustom yang telah Anda tambahkan dari menu jaringan di MetaMask.

## Langkah 3: Menulis dan Mendeploy Smart Contract di Remix

1. **Buka Remix IDE**:
   - Kunjungi [Remix IDE](https://remix.ethereum.org/).

2. **Buat File Smart Contract**:
   - Klik ikon `+` untuk membuat file baru.
   - Beri nama file, misalnya `CertificateRegistry.so`.

3. **Tulis Smart Contract**:

4. **Kompilasi Smart Contract**:
   - Klik ikon `Solidity Compiler`.
   - Pilih versi compiler yang sesuai (misalnya `0.8.0`).
   - Klik `Compile CertificateRegistry.so`.

5. **Deploy Smart Contract**:
   - Klik ikon `Deploy & Run Transactions`.
   - Pilih `Injected Web3` sebagai `Environment`.
   - MetaMask akan meminta izin untuk terhubung ke Remix. Klik `Connect`.
   - Pilih kontrak yang akan dideploy dari dropdown `Contract`.
   - Masukkan parameter konstruktor jika ada.
   - Klik `Deploy` dan konfirmasi transaksi di MetaMask.

## Langkah 4: Interaksi dengan Smart Contract

1. **Interaksi dengan Kontrak**:
   - Kontrak yang telah dideploy akan muncul di bawah `Deployed Contracts`.
   - Anda dapat mengakses dan menjalankan fungsi-fungsi kontrak melalui UI Remix.


