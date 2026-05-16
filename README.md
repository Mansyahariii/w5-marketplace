# 🏠 UTS Home Living — Marketplace App

Aplikasi mobile marketplace **Home Living** berbasis Flutter dengan autentikasi Firebase dan backend API integration.

## 👤 Identitas

| | |
|---|---|
| **Nama** | Arif Irmansyah |
| **NIM** | 1123150127 |
| **Mata Kuliah** | Mobile Apps |

## 🎬 Video Demo

[![Video Demo](https://img.shields.io/badge/YouTube-Video%20Demo-red?style=for-the-badge&logo=youtube)](https://youtu.be/_7hZ14lF9fc)

> 🔗 **Link:** [https://youtu.be/_7hZ14lF9fc](https://youtu.be/_7hZ14lF9fc)

## 📱 Fitur Utama

### 🔐 Autentikasi
- **Login** dengan Email & Password
- **Login** dengan Google Sign-In (Mobile & Web)
- **Register** akun baru dengan validasi form
- **Verifikasi Email** otomatis via Firebase dengan polling setiap 5 detik
- **Lupa Password** — reset password via email
- **Auto-logout** saat token expired (401 Unauthorized)

### 🛍️ Katalog Produk (Dashboard)
- Tampilan grid 2 kolom dengan gambar, nama, harga, dan kategori
- Format harga Rupiah (Rp) dengan separator ribuan
- Badge kategori produk
- Pull-to-refresh untuk memuat ulang produk
- State handling: loading, error, dan retry

### 🛒 Keranjang Belanja
- Tambah produk ke keranjang dari halaman katalog
- Kontrol jumlah (+ / −) langsung di card produk
- Badge jumlah item di ikon keranjang pada app bar
- Halaman keranjang terpisah

### 💳 Checkout
- Halaman checkout untuk menyelesaikan pesanan

## 🏗️ Arsitektur & Struktur Project

Project ini menggunakan arsitektur **Feature-First (Clean Architecture)** dengan state management **Provider**.

```
lib/
├── main.dart                          # Entry point & MultiProvider setup
├── firebase_options.dart              # Firebase configuration (auto-generated)
│
├── core/                              # Shared / cross-feature
│   ├── constants/
│   │   ├── api_constants.dart         # Base URL, endpoints, timeout
│   │   ├── app_colors.dart            # Color palette
│   │   └── app_strings.dart           # String constants
│   ├── routes/
│   │   ├── app_router.dart            # Named routes definition
│   │   └── auth_guard.dart            # Route protection middleware
│   ├── services/
│   │   ├── dio_client.dart            # HTTP client with interceptors
│   │   └── secure_storage.dart        # Encrypted token storage
│   └── theme/
│       └── app_theme.dart             # Material theme configuration
│
├── features/
│   ├── auth/                          # 🔐 Authentication feature
│   │   ├── data/                      # Data layer
│   │   ├── domain/                    # Domain models
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── register_page.dart
│   │       │   └── verify_email_page.dart
│   │       ├── providers/
│   │       │   └── auth_provider.dart # Auth state management
│   │       └── widgets/
│   │           ├── auth_header.dart
│   │           ├── custom_button.dart
│   │           ├── custom_text_field.dart
│   │           ├── divider_with_text.dart
│   │           ├── google_sign_in_button.dart
│   │           └── loading_overlay.dart
│   │
│   ├── dashboard/                     # 🛍️ Product catalog feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── dashboard_page.dart
│   │       └── providers/
│   │           └── product_provider.dart
│   │
│   ├── cart/                          # 🛒 Shopping cart feature
│   │   ├── data/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── cart_page.dart
│   │       └── providers/
│   │           └── cart_provider.dart
│   │
│   ├── checkout/                      # 💳 Checkout feature
│   │   ├── data/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── checkout_page.dart
│   │       └── providers/
│   │           └── checkout_provider.dart
│   │
│   └── splash/                        # 🚀 Splash screen
│       └── presentation/
│           └── pages/
│               └── splash_page.dart
```

## 🛠️ Tech Stack

| Kategori | Teknologi |
|----------|-----------|
| **Framework** | Flutter (Dart ^3.11.0) |
| **State Management** | Provider |
| **Authentication** | Firebase Auth + Google Sign-In |
| **HTTP Client** | Dio (with interceptors) |
| **Secure Storage** | flutter_secure_storage |
| **Form Validation** | email_validator |
| **Typography** | Google Fonts |
| **SVG Rendering** | flutter_svg |

## 🔄 Alur Autentikasi

```
┌─────────────┐     ┌──────────────┐     ┌───────────────────┐
│  Splash     │────▶│  Login       │────▶│  Dashboard        │
│  Screen     │     │  Page        │     │  (Authenticated)  │
└─────────────┘     └──────┬───────┘     └───────────────────┘
                           │                       ▲
                    ┌──────▼───────┐                │
                    │  Register    │                │
                    │  Page        │                │
                    └──────┬───────┘                │
                           │                        │
                    ┌──────▼───────┐                │
                    │  Verify      │   (polling)    │
                    │  Email Page  │────────────────┘
                    └──────────────┘
```

1. **Register** → Firebase buat akun → kirim email verifikasi
2. **Verify Email** → polling setiap 5 detik → cek apakah email sudah diklik
3. **Login** → Firebase auth → ambil Firebase ID Token → kirim ke backend
4. **Backend** → validasi token → return JWT → simpan di Secure Storage
5. **API Calls** → Dio interceptor auto-inject Bearer token dari storage

## ⚙️ Cara Menjalankan

### Prerequisites
- Flutter SDK ≥ 3.38.4
- Dart SDK ≥ 3.11.0
- Android Studio / VS Code
- Firebase project yang sudah dikonfigurasi

### Setup

```bash
# 1. Clone repository
git clone https://github.com/Mansyahariii/uts-homeliving.git
cd uts-homeliving

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

### Catatan untuk Android Emulator
- Base URL API menggunakan `10.0.2.2:8080` (alias localhost komputer host)
- Jika menggunakan perangkat fisik, ganti ke IP jaringan lokal di `lib/core/constants/api_constants.dart`

## 📝 Navigasi Halaman

| Route | Halaman | Auth Required |
|-------|---------|:---:|
| `/` | Splash Screen | ❌ |
| `/login` | Login Page | ❌ |
| `/register` | Register Page | ❌ |
| `/verify-email` | Verify Email Page | ❌ |
| `/dashboard` | Dashboard / Katalog | ✅ |
| `/cart` | Keranjang Belanja | ✅ |
| `/checkout` | Checkout | ✅ |
