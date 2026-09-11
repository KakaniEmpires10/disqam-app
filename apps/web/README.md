# DISQAM Web / API

Nuxt 4 + Nuxt UI untuk web, Nitro sebagai backend bersama mobile, Drizzle ORM dan Neon PostgreSQL. UI web masih scaffold; endpoint diary belum aktif. Backend auth admin tersedia; lihat [setup auth dan pembuatan admin](../../docs/admin-auth.md).

Backend registrasi peserta, session peserta, progres belajar enam sesi, dan monitoring admin juga tersedia. Kontrak API, push schema tambahan, batas recovery, dan langkah integrasi UI: [registrasi dan tracking](../../docs/participant-tracking.md).

## Development

```sh
pnpm install
pnpm dev
```

## Database

Salin .env.example ke .env dan isi DATABASE_URL development. Jalankan dari apps/web:

```sh
pnpm run db:push
pnpm run db:test
```

db:push hanya diizinkan jika DATABASE_ENV=development dan NODE_ENV bukan production. Tidak menggunakan --force. Tidak ada migration atau seed yang dibuat pada tahap inisialisasi.

Saat schema sudah stabil, sebelum produksi:

```sh
pnpm run db:generate
pnpm run db:migrate
```

Generate membuat migration dari schema di kode. Migrate menerapkan file yang sudah dibuat; tidak menghasilkan migration sendiri. Baseline awal sebaiknya diterapkan pada database produksi kosong, bukan langsung pada database berisi tabel hasil push.

Lihat [schema, field, keamanan dan workflow](../../docs/database-setup.md), [scope minimal](../../docs/next-implementation-plan.md), dan [pertanyaan kalkulator untuk klien](../../docs/calculator-client-questions.md).

## Verifikasi

```sh
pnpm run db:test
pnpm run typecheck
pnpm run lint
pnpm run build
```

db:test memeriksa struktur schema dan guard CLI tanpa database. Verifikasi DDL/constraint terhadap Neon memerlukan DATABASE_URL dan dilakukan setelah URL tersedia. Jangan menjalankan push atau migrate otomatis saat build.

## Struktur

- server/db/schema.ts: tabel identitas, sesi akses, diary, admin, dan pembatas login; relasi serta constraint.
- server/db/index.ts: koneksi Neon HTTP yang dibuat hanya ketika dibutuhkan.
- server/db/environment.ts: validasi URL dengan pesan yang tidak membocorkan kredensial.
- drizzle.config.ts: konfigurasi Drizzle Kit.
- scripts/db.ts: guard push/generate/migrate.

Materi statis tetap lokal. Tidak ada kredensial di public runtime config. Riwayat berasal dari tabel sleep_diaries, bukan tabel duplikat. Buat akun admin dengan `pnpm run admin:create` melalui prompt interaktif, tanpa password bawaan atau seed peserta palsu.
