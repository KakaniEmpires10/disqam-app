import 'models.dart';

const programGroup = ContentGroup(
  id: 'program',
  title: 'Program DISQAM',
  asset: 'assets/images/program.webp',
  summary: 'Enam sesi untuk dipelajari dan dilatih secara bertahap bersama fasilitator.',
  articles: [
    Article(
      id: 'session-1',
      title: 'Sesi I · Kenali Masalah Tidur',
      summary: 'Mulai mengenali pola tidur dan kebiasaan sehat.',
      source: 'Modul DISQAM, Sesi I; Tabel 4.3–4.4; Lampiran 3.',
      sections: [
        ReadingSection(
          'Tujuan sesi',
          paragraphs: [
            'Memahami perubahan tidur pada lansia, membedakan lelah dengan mengantuk, dan mulai mengenali pola tidur melalui buku harian.',
          ],
        ),
        ReadingSection(
          'Kenali keluhan tidur Anda',
          points: [
            'Apakah sulit mulai tidur?',
            'Apakah sering terbangun?',
            'Apakah sulit tidur kembali?',
            'Apakah bangun terlalu dini?',
            'Apakah merasa tidak segar?',
            'Apakah khawatir berlebihan tentang tidur?',
          ],
          note: 'Ceritakan pengalaman dan catatan Anda kepada fasilitator. Ini latihan mengenali keluhan, bukan penentuan diagnosis.',
        ),
        ReadingSection(
          'Bedakan lelah dan mengantuk',
          paragraphs: [
            'Lelah berarti tubuh terasa kurang tenaga. Mengantuk berarti ada dorongan untuk tidur, misalnya mata terasa berat, sering menguap, atau sulit tetap terjaga.',
            'Anda dapat merasa lelah tanpa mengantuk. Saat akan tidur, perhatikan rasa mengantuk, bukan hanya rasa lelah.',
          ],
          note: 'Jika rasa lelah atau mengantuk sangat berat dan mengganggu kegiatan sehari-hari, sampaikan kepada fasilitator atau tenaga kesehatan.',
        ),
        ReadingSection(
          'Mulai buku harian sejak awal',
          paragraphs: [
            'Buku harian dimulai sejak sesi I dan diisi setiap pagi selama intervensi. Gunakan perkiraan yang konsisten; tidak perlu menebak hingga menit yang sangat tepat.',
            'Catat waktu masuk tempat tidur, perkiraan mulai tidur, terbangun malam, waktu terjaga, bangun terakhir, keluar dari tempat tidur, dan tidur siang.',
          ],
          note: 'Isi melalui menu Buku Harian Tidur di beranda. Jika fasilitator meminta catatan obat tidur, ikuti petunjuk penelitian yang diberikan.',
        ),
        ReadingSection(
          'Kebiasaan yang mendukung tidur',
          points: [
            'Bangun pada waktu relatif sama setiap hari.',
            'Dapatkan cahaya pagi bila memungkinkan.',
            'Tetap aktif sesuai kemampuan dan anjuran kesehatan.',
            'Batasi tidur siang terlalu lama atau terlalu dekat malam.',
            'Kurangi kafein terutama sore atau malam; jangan gunakan alkohol sebagai obat tidur.',
            'Buat kamar aman, tidak bising, cukup gelap, dan nyaman.',
            'Lakukan rutinitas sederhana sebelum tidur.',
          ],
        ),
        ReadingSection(
          'Tugas minggu pertama',
          paragraphs: [
            'Pilih 2–3 kebiasaan yang ingin diperbaiki. Mulai dari perubahan kecil yang realistis dan bahas hambatannya dengan fasilitator.',
            'Bicarakan penanganan nyeri, sering buang air kecil pada malam hari, dan gejala penyakit menahun dengan tenaga kesehatan.',
          ],
          note: 'Tidak perlu mengubah semua kebiasaan sekaligus.',
        ),
      ],
    ),
    Article(
      id: 'session-2',
      title: 'Sesi II · Stimulus Control',
      summary: 'Mengaitkan kembali tempat tidur dengan tidur.',
      source: 'Modul DISQAM, Sesi II; Lampiran 4. Mengikuti adaptasi khusus DISQAM untuk lansia.',
      sections: [
        ReadingSection(
          'Tujuan sesi',
          paragraphs: [
            'Membantu tempat tidur kembali menjadi isyarat untuk tidur, serta mengurangi kaitannya dengan khawatir, melihat jam, atau terjaga lama.',
          ],
        ),
        ReadingSection(
          'Gunakan tempat tidur untuk tidur',
          points: [
            'Pergi ke tempat tidur ketika mulai mengantuk.',
            'Gunakan tempat tidur terutama untuk tidur.',
            'Jika belum tertidur sekitar 30 menit atau terjaga cukup lama, bangun perlahan dan lakukan kegiatan ringan yang tidak membuat tubuh semakin aktif, bila aman.',
            'Kembali ke tempat tidur ketika mengantuk.',
            'Bangun pada waktu yang relatif tetap setiap pagi.',
          ],
          note: 'Aturan sekitar 30 menit ini adalah adaptasi DISQAM untuk lansia. Jangan terus-menerus memantau jam.',
        ),
        ReadingSection(
          'Utamakan keamanan ketika bangun',
          points: [
            'Jangan berjalan dalam keadaan gelap; gunakan pencahayaan malam yang aman.',
            'Gunakan alat bantu jalan jika biasa digunakan.',
            'Minta bantuan pendamping bila ada risiko jatuh.',
            'Hindari kegiatan yang membuat semakin aktif, seperti menonton televisi atau menyalakan lampu terlalu terang.',
          ],
          note: 'Jika sulit bergerak dengan aman, diskusikan penyesuaian dengan fasilitator atau tenaga kesehatan.',
        ),
        ReadingSection(
          'Latihan minggu ini',
          paragraphs: [
            'Cobalah langkah yang sudah dibahas bersama fasilitator. Pada lembar latihan, catat saat pergi tidur karena mengantuk, saat bangun karena terjaga lama, saat kembali ke tempat tidur, dan waktu bangun pagi.',
            'Sampaikan kepada fasilitator jika muncul kantuk pada siang hari atau kesulitan selama latihan. Gunakan lembar latihan yang diberikan fasilitator.',
          ],
        ),
      ],
    ),
    Article(
      id: 'session-3',
      title: 'Sesi III · Pengaturan Waktu Tidur',
      summary: 'Mengurangi waktu terjaga di tempat tidur secara bertahap.',
      source: 'Modul DISQAM, Sesi III; Tabel 4.5–4.6; Lampiran 2.',
      sections: [
        ReadingSection(
          'Tujuan sesi',
          paragraphs: [
            'Pengaturan waktu tidur membantu mengurangi waktu terjaga di tempat tidur. Pada lansia, waktu di tempat tidur disesuaikan sedikit demi sedikit sesuai kondisi.',
          ],
          note: 'Tujuannya bukan mengurangi kebutuhan tidur secara ekstrem. Jadwal pribadi perlu arahan tenaga kesehatan.',
        ),
        ReadingSection(
          'Rencana berdasarkan beberapa hari',
          points: [
            'Gunakan buku harian beberapa hari, bukan satu malam buruk.',
            'Pertahankan waktu bangun relatif konsisten.',
            'Sesuaikan waktu di tempat tidur secara bertahap sesuai kondisi.',
            'Ikuti jadwal yang disepakati dan evaluasi keluhan siang hari.',
          ],
        ),
        ReadingSection(
          'Memahami efisiensi tidur',
          paragraphs: [
            'TST adalah total waktu benar-benar tidur. TIB adalah total waktu di tempat tidur. Efisiensi Tidur atau Sleep Efficiency (SE) adalah persentase waktu di tempat tidur yang benar-benar digunakan untuk tidur.',
            'SE = TST ÷ TIB × 100%. Contoh dalam modul: TST 6 jam dan TIB 8 jam menghasilkan SE 75%.',
          ],
          note: 'Contoh ini bukan target semua peserta. Perhitungan dari buku harian tidur dan keputusan penyesuaian dibahas bersama fasilitator.',
        ),
        ReadingSection(
          'Catatan rencana tidur',
          points: [
            'Rata-rata waktu tidur minggu lalu.',
            'Target waktu bangun dan masuk tempat tidur.',
            'Rata-rata efisiensi tidur.',
            'Keluhan siang hari.',
            'Keputusan untuk minggu berikutnya.',
          ],
          note: 'Kalkulator aplikasi membantu menghitung TIB, TST, dan efisiensi tidur. Jadwal terapi tetap harus disusun bersama fasilitator atau tenaga kesehatan.',
        ),
        ReadingSection(
          'Kapan penyesuaian jadwal perlu dihentikan?',
          paragraphs: [
            'Perhatikan kantuk pada siang hari, gangguan keseimbangan, jatuh, kebingungan, dan perubahan kondisi kesehatan. Jangan memperpendek waktu di tempat tidur dan segera berkonsultasi jika muncul keluhan yang mengkhawatirkan.',
          ],
          note: 'Jangan mengemudi atau melakukan aktivitas berbahaya ketika mengantuk.',
        ),
      ],
    ),
    Article(
      id: 'session-4',
      title: 'Sesi IV · Tenangkan Pikiran',
      summary: 'Mengenali dan memeriksa pikiran tentang tidur.',
      source: 'Modul DISQAM, Sesi IV; Tabel 4.7; Lampiran 5.',
      sections: [
        ReadingSection(
          'Tujuan sesi',
          paragraphs: [
            'Mengenali pikiran yang terlalu negatif atau mutlak tentang tidur, lalu menggantinya dengan pikiran lebih realistis dan seimbang.',
            'Latihan ini bukan memaksa berpikir positif. Lakukan perlahan dengan bahasa yang mudah dipahami.',
          ],
        ),
        ReadingSection(
          'KENALI · PERIKSA · GANTI',
          points: [
            'KENALI pikiran yang muncul ketika sulit tidur.',
            'PERIKSA: apakah selalu benar? Apa bukti yang mendukung dan tidak mendukung?',
            'GANTI dengan kalimat yang masuk akal dan sesuai pengalaman.',
          ],
        ),
        ReadingSection(
          'Contoh pikiran yang lebih membantu',
          paragraphs: [
            'Pikiran lama: “Saya harus tidur sekarang.”',
            'Pikiran baru: “Saya tidak perlu memaksa tidur; saya akan membuat tubuh rileks dan membiarkan kantuk datang.”',
            'Satu malam buruk tidak selalu menentukan seluruh hari. Anda dapat menyesuaikan aktivitas sesuai kondisi.',
          ],
        ),
        ReadingSection(
          'Kurangi usaha memaksa tidur',
          points: [
            'Hindari terus-menerus memeriksa apakah sudah mengantuk.',
            'Hindari melihat jam berulang kali.',
            'Tidak perlu menilai malam sebagai berhasil atau gagal setiap beberapa menit.',
            'Fokus untuk mengurangi ketegangan; atur napas atau lakukan kegiatan ringan sambil menunggu rasa mengantuk.',
          ],
        ),
        ReadingSection(
          'Latihan minggu ini',
          paragraphs: [
            'Gunakan lembar Kenali-Periksa-Ganti dari fasilitator: catat situasi, pikiran otomatis, perasaan atau sensasi tubuh, bukti yang seimbang, dan pikiran baru.',
            'Lakukan pencatatan pada lembar latihan dari fasilitator. Anda dapat membaca kembali panduan ini kapan pun dibutuhkan.',
          ],
        ),
      ],
    ),
    Article(
      id: 'session-5',
      title: 'Sesi V · Relaksasi',
      summary: 'Mengurangi ketegangan tubuh dan menjaga kebiasaan tidur.',
      source: 'Modul DISQAM, Sesi V; Gambar 4.3–4.5; Tabel 4.2.',
      sections: [
        ReadingSection(
          'Tujuan sesi',
          paragraphs: [
            'Relaksasi membantu mengurangi ketegangan tubuh dan pikiran, bukan membuat tidur secara paksa. Pilih latihan sesuai kondisi dan arahan tenaga kesehatan.',
          ],
        ),
        ReadingSection(
          'Latihan napas sederhana',
          points: [
            'Duduk atau berbaring dalam posisi aman dan nyaman.',
            'Lemaskan bahu, perhatikan napas tanpa memaksakannya.',
            'Tarik napas perlahan melalui hidung; biarkan perut atau dada bergerak secara alami.',
            'Hembuskan napas perlahan.',
            'Ulangi beberapa menit sesuai kemampuan. Contoh latihan dalam modul berlangsung 3–5 menit tanpa menahan napas.',
          ],
          note: 'Jika pusing atau tidak nyaman, hentikan latihan dan bernapas seperti biasa.',
        ),
        ReadingSection(
          'Relaksasi otot dan alternatif pasif',
          paragraphs: [
            'Kencangkan kelompok otot dengan ringan selama beberapa detik, kemudian lepaskan. Modul memberi contoh urutan dari tangan, bahu, wajah, tungkai, lalu seluruh tubuh.',
            'Pada lansia dengan radang sendi atau gangguan nyeri, latihan otot progresif dapat memperburuk keluhan. Relaksasi pasif dan imajinasi terbimbing menjadi alternatif: kenali ketegangan, lalu rilekskan tubuh sambil membayangkan suasana menenangkan.',
          ],
          note: 'Hindari area yang nyeri, cedera, atau terbatas. Jangan memaksakan gerakan; sesuaikan dengan arahan tenaga kesehatan.',
        ),
        ReadingSection(
          'Relaksasi di sekitar mata',
          paragraphs: [
            'Modul memuat pijatan ringan di sekitar alis dan pelipis untuk membantu tubuh lebih rileks sebelum tidur. Jangan memijat bola mata.',
          ],
          note: 'Jangan menekan atau menggosok bola mata. Konsultasikan dahulu dengan dokter mata jika ada glaukoma, baru operasi mata, atau keluhan mata. Hentikan jika nyeri, kemerahan, atau gangguan mata.',
        ),
        ReadingSection(
          'Jika tidur kembali terganggu',
          points: [
            'Beberapa malam buruk tidak berarti program gagal.',
            'Kembali ke buku harian tidur jika pola mulai memburuk.',
            'Periksa kembali waktu bangun, tidur siang, kegiatan, konsumsi kafein, dan cara menggunakan tempat tidur untuk tidur.',
            'Gunakan latihan pikiran dan relaksasi yang sudah dipelajari.',
            'Hubungi tenaga kesehatan bila keluhan menetap atau ada tanda bahaya.',
          ],
        ),
        ReadingSection(
          'Rencana pemeliharaan pribadi',
          paragraphs: [
            'Diskusikan kebiasaan yang ingin dipertahankan dan latihan yang membantu Anda. Gunakan keterampilan tersebut ketika tidur kembali terganggu.',
            'Diskusikan pelaksanaan latihan relaksasi bersama fasilitator sebagai bagian dari pemantauan kepatuhan. Gunakan lembar pemantauan yang diberikan fasilitator.',
          ],
        ),
      ],
    ),
    Article(
      id: 'session-6',
      title: 'Sesi VI · Buku Harian & Pemantauan',
      summary: 'Melihat pola, perubahan, dan pelaksanaan latihan.',
      source: 'Modul DISQAM, Sesi VI; Tabel 4.8–4.10; Lampiran 1–2.',
      sections: [
        ReadingSection(
          'Melihat pola dari hari ke hari',
          paragraphs: [
            'Buku harian membantu mengenali pola tidur, kebiasaan yang memengaruhi tidur, dan perubahan selama program. Pencatatan sudah dimulai sejak sesi I.',
            'Catatan beberapa hari menjadi bahan diskusi dan umpan balik bersama fasilitator.',
          ],
          note: 'Buku harian bukan ujian. Cukup catat apa yang benar-benar dialami dengan perkiraan yang konsisten.',
        ),
        ReadingSection(
          'Apa yang dicatat setiap pagi?',
          points: [
            'Waktu masuk tempat tidur dan perkiraan mulai tidur.',
            'Jumlah terbangun malam dan total lama terjaga.',
            'Waktu bangun terakhir dan waktu keluar tempat tidur.',
            'Tidur siang.',
            'Catatan obat tidur hanya jika diminta dalam petunjuk penelitian.',
          ],
          note: 'Isi melalui menu Buku Harian Tidur di beranda. Catatan pada tanggal yang sama dapat diperbarui jika ada data yang perlu diperbaiki.',
        ),
        ReadingSection(
          'Istilah pada ringkasan tidur',
          points: [
            'SOL: waktu sejak mulai berusaha tidur sampai tertidur.',
            'WASO: waktu terjaga setelah mulai tertidur, dengan pencatatan sesuai arahan fasilitator.',
            'TST: total waktu benar-benar tidur.',
            'TIB: total waktu di tempat tidur.',
            'SE: persentase waktu di tempat tidur yang digunakan untuk tidur.',
          ],
          note: 'Bangun terakhir dan keluar tempat tidur adalah dua waktu berbeda. Catat keduanya sesuai pengalaman.',
        ),
        ReadingSection(
          'Siapa yang membantu pemantauan?',
          points: [
            'Peserta: mengisi buku harian tidur setiap pagi.',
            'Fasilitator: meninjau catatan secara berkala.',
            'Pendamping: membantu mengingat dan mencatat bila diperlukan.',
          ],
        ),
        ReadingSection(
          'Periksa latihan yang sudah dilakukan',
          points: [
            'Mengisi buku harian tidur.',
            'Melaksanakan kebiasaan tidur sehat.',
            'Menggunakan tempat tidur terutama untuk tidur.',
            'Mengikuti jadwal tidur yang disepakati.',
            'Melakukan relaksasi.',
            'Melakukan latihan Kenali–Periksa–Ganti.',
            'Menghindari aktivitas yang mengganggu tidur.',
          ],
          note: 'Membaca materi tidak sama dengan menjalankan latihan. Catatan kepatuhan dibahas bersama fasilitator.',
        ),
      ],
    ),
  ],
);
