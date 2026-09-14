# DISQAM Mobile

Fondasi aplikasi Flutter untuk Android. Tema dan batas produk mengikuti [AGENTS.md](../../AGENTS.md); sumber konten dan keputusan penelitian ada di [product-context.md](../../docs/product-context.md).

## Menjalankan

```sh
flutter pub get
flutter run --dart-define=DISQAM_API_URL=http://10.0.2.2:3000 --dart-define=DISQAM_WEB_URL=http://localhost:3000
```

`10.0.2.2` mengarah ke server Nuxt pada komputer pengembang dari Android emulator. Build release wajib memakai URL API dan URL web HTTPS. `DISQAM_WEB_URL` dipakai oleh tombol monitoring web pada halaman Tentang.

Dikembangkan dengan Flutter 3.47.2 dan Dart 3.13.2. Android adalah target verifikasi utama.

## Tersedia

- Splash dengan identitas DISQAM dan halaman pengenalan setiap kali aplikasi dibuka.
- Beranda dengan Program DISQAM sebagai fitur utama, Buku Harian Tidur sebagai fitur sekunder, materi bergambar, dan alat bantu dalam baris ringkas.
- Registrasi peserta pseudonim saat Program pertama dibuka, login lintas perangkat memakai kode kepesertaan, serta penyimpanan kredensial melalui secure storage.
- Kode kepesertaan dapat disalin atau disimpan melalui template WhatsApp; layar mengingatkan pengguna bahwa kode harus dirahasiakan.
- Enam sesi sebagai perjalanan belajar; bacaan editorial dengan langkah bernomor, catatan, dan tracking pembukaan/penyelesaian yang tetap membebaskan peserta membuka sesi mana pun.
- Materi lokal berbahasa Indonesia, enam sesi beserta tugas/panduan dan catatan keselamatan.
- Bacaan utuh yang dapat digulir, daftar isi untuk melompat ke bagian tertentu, dan lanjutkan posisi bagian terakhir. Tidak ada tombol berikutnya/sebelumnya atau penguncian sesi.
- Kalkulator TIB, SOL, WASO, TST, dan efisiensi tidur dengan penjelasan rumus serta rujukan ilmiah.
- Tentang Aplikasi, monitoring admin di aplikasi, serta tombol untuk membuka monitoring melalui web.

Materi, ikon, dan kalkulator bekerja tanpa jaringan. `shared_preferences` hanya menyimpan status pengenalan dan id/bagian bacaan, bukan data penelitian atau token akses. Kegagalan penyimpanan tidak menghalangi membaca materi. Posisi bacaan bukan progres intervensi atau bukti kepatuhan.

## Struktur

```text
lib/
  app.dart                # startup, locale Indonesia, tema terang
  theme.dart              # warna dan ukuran sesuai AGENTS.md
  content/                # model, materi, enam sesi, rujukan modul
  domain/                 # perhitungan waktu murni
  screens/                # layar peserta dan pratinjau admin
  services/              # bookmark lokal, API peserta, dan secure participant store
  widgets/                # identitas, permukaan malam, baris menu, blok editorial
assets/images/            # hanya aset klien yang dipakai
```

Konten mengikuti `docs/source/Materi_Program _Aplikasi_Disqam.docx`, dengan rujukan pada tiap bacaan. Seluruh tabel dan lembar latihan tetap tersedia pada sesi terkait dan dikumpulkan kembali dalam menu Lampiran. Kalkulator mengikuti `docs/source/Kalkulator_Tidur_DISQAM.html` dan menggunakan 85% sebagai patokan pemantauan umum, bukan batas diagnosis.

## Aset klien

Ikon aplikasi, splash, dan simbol header menggunakan `docs/source/Icons/APP_ICON_NO_TEXT.webp`. Ilustrasi materi berasal dari dokumen rujukan terbaru dan disimpan sebagai aset lokal agar materi tetap dapat dibaca tanpa internet. Teks nama menu selalu tersedia; gambar tidak menjadi satu-satunya penanda navigasi.

Pengenalan tampil setiap kali aplikasi dimulai dan juga dapat dibuka melalui **Beranda → Tentang → Lihat pengenalan aplikasi**.

Arah redesign dan hasil pembacaan referensi SIGANA ada di [mobile-design-system.md](../../docs/mobile-design-system.md). Tidak ada aset, palet, atau komponen SIGANA yang disalin. Motif bulan digambar langsung di Flutter, tanpa dependensi baru.

## Verifikasi

```sh
flutter analyze
flutter test
flutter build apk --debug
```

Tes mencakup startup, lanjut membaca, registrasi/login peserta, retry aman, antrean progres offline, template WhatsApp, kalkulator, batas pratinjau admin, serta seluruh bagian materi pada layar 360 × 800 dengan teks 200%.

APK debug untuk emulator berada di `build/app/outputs/flutter-apk/app-debug.apk`. Untuk APK lebih kecil per arsitektur, gunakan `flutter build apk --release --split-per-abi`; ponsel Android 64-bit umumnya memakai `app-arm64-v8a-release.apk`. APK tahap ini memakai signing debug bawaan scaffold, termasuk build release, dan hanya untuk peninjauan. Identitas Android masih `com.example.disqam`; application ID final dan signing distribusi harus ditetapkan sebelum publikasi. Tidak ada perubahan pada aplikasi web dalam tahap ini.

Pratinjau gambar opsional: `flutter test test/preview_test.dart --dart-define=CAPTURE_PREVIEWS=true --dart-define=FLUTTER_SDK=<lokasi-sdk>`. Hasil ada di `build/previews/`; tes ini dilewati pada eksekusi rutin.

Splash Android 12+ memakai inset persentase, bukan ukuran child tetap, agar bitmap mengikuti bounds sebelum terkena mask sistem. Seluruh bitmap muat dalam lingkaran aman 192/288, dengan rasio asli dipertahankan. Aturan ini diuji di `native_splash_test.dart`; cold launch APK release juga diperiksa pada emulator Android. Pratinjau Flutter saja tidak menguji splash native. Referensi: [spesifikasi splash Android](https://developer.android.com/develop/ui/views/launch/splash-screen).

## Tahap berikutnya

Sleep diary dan riwayat sudah tersedia melalui Nitro API yang sama dengan web. Scope pencatatan/perhitungan tetap dibatasi pada sleep diary, riwayat, dan kalkulator kualitas tidur sesuai definisi klien. Tidak semua lampiran modul dijadikan form. Lihat [scope minimal](../../docs/next-implementation-plan.md). Kalkulator saat ini hanya menghitung waktu tidur, bukan skor kualitas tidur.

Sebelum perhitungan diary dibuat, tim penelitian perlu menetapkan definisi TIB/SOL/WASO, konvensi tanggal, agregasi mingguan, instrumen, dan kriteria penyelesaian. Kalkulator saat ini hanya menghitung waktu berdasarkan input pengguna, tanpa menetapkan durasi tidur yang dibutuhkan seseorang.
