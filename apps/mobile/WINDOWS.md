# DISQAM untuk Windows

Aplikasi Flutter ini juga dapat dijalankan sebagai aplikasi Windows x64. Materi dan kalkulator tersedia tanpa internet; login, buku harian, monitoring, serta ekspor data tetap membutuhkan koneksi ke API DISQAM.

## Menyiapkan mesin build

1. Gunakan Windows dengan Flutter dan Visual Studio 2022. Di Visual Studio Installer, aktifkan **Desktop development with C++**. Plugin penyimpanan aman mungkin juga memerlukan komponen **C++ ATL**.
2. Aktifkan **Developer Mode** melalui **Settings → System → For developers** agar Flutter dapat membuat symlink plugin.
3. Dari folder `apps/mobile`, jalankan `flutter doctor -v` dan pastikan bagian Windows serta Visual Studio tidak memiliki masalah.

## Build release

Jalankan dari folder `apps/mobile`:

```powershell
flutter pub get
flutter analyze
flutter test
flutter build windows --release --dart-define=DISQAM_API_URL=https://disqam.netlify.app --dart-define=DISQAM_WEB_URL=https://disqam.netlify.app
```

Ganti kedua URL HTTPS jika domain produksi berubah. `DISQAM_API_URL` menunjuk ke server Nuxt/Nitro dan `DISQAM_WEB_URL` ke halaman monitoring web. Nilai ini disisipkan saat build; jika URL berubah, buat build baru. Jangan memasukkan kredensial database atau rahasia admin ke `--dart-define`.

Hasilnya berada di `build/windows/x64/runner/Release/disqam.exe`.

## Membagikan kepada klien

Jangan kirim `disqam.exe` saja. Kirim **seluruh folder `Release`**, termasuk `data`, semua DLL, dan executable. Misalnya, dari folder `apps/mobile`:

```powershell
Compress-Archive -LiteralPath 'build/windows/x64/runner/Release' -DestinationPath 'build/windows/x64/runner/DISQAM-Windows-x64.zip'
```

Klien mengekstrak ZIP, membuka folder `Release`, lalu menjalankan `disqam.exe`. Komputer tujuan mungkin perlu **Microsoft Visual C++ Redistributable** yang sesuai. Arsip ini belum merupakan installer dan executable belum ditandatangani; Windows dapat menampilkan peringatan untuk aplikasi yang belum dikenal. Untuk distribusi publik, siapkan installer dan penandatanganan kode.

Jangan menjalankan aplikasi langsung dari dalam ZIP. Untuk menguji hasil distribusi, ekstrak arsip di komputer Windows lain dan coba materi offline, login, buku harian, serta ekspor.

Rujukan: [panduan build dan distribusi Flutter Windows](https://docs.flutter.dev/platform-integration/windows/building), [penyiapan Windows](https://docs.flutter.dev/platform-integration/windows/setup).
