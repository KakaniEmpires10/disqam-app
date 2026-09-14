import 'models.dart';

const sleepProblemTable = ReadingTable(
  title: 'Tabel 4.3 · Latihan Kenali Masalah Tidur Saya',
  headers: ['Pertanyaan', 'Ya/Tidak', 'Catatan'],
  rows: [
    ['Sulit mulai tidur?', '', ''],
    ['Sering terbangun?', '', ''],
    ['Sulit tidur kembali?', '', ''],
    ['Bangun terlalu dini?', '', ''],
    ['Merasa tidak segar?', '', ''],
    ['Khawatir berlebihan tentang tidur?', '', ''],
  ],
);

const sleepHygieneTable = ReadingTable(
  title: 'Tabel 4.4 · Daftar Periksa Kebiasaan Saya',
  headers: ['Kebiasaan', 'Sudah', 'Akan diperbaiki'],
  rows: [
    ['Waktu bangun relatif tetap', '', ''],
    ['Cahaya pagi', '', ''],
    ['Aktif pada siang hari', '', ''],
    ['Tidur siang terkendali', '', ''],
    ['Kafein dibatasi', '', ''],
    ['Kamar nyaman dan aman', '', ''],
    ['Rutinitas sebelum tidur', '', ''],
  ],
);

const sleepPlanExampleTable = ReadingTable(
  title: 'Tabel 4.5 · Contoh Pengaturan Waktu Tidur',
  headers: ['Contoh', 'Nilai'],
  rows: [
    ['Masuk tempat tidur', '22.00'],
    ['Bangun akhir', '06.00'],
    ['TIB', '8 jam'],
    ['Perkiraan TST', '6 jam'],
    ['SE', '75%'],
  ],
);

const sleepPlanTable = ReadingTable(
  title: 'Tabel 4.6 · Contoh Lembar Rencana Tidur',
  headers: ['Komponen', 'Rencana'],
  rows: [
    ['Rata-rata TST minggu lalu', ''],
    ['Waktu bangun target', ''],
    ['Waktu masuk tempat tidur target', ''],
    ['SE rata-rata', ''],
    ['Keluhan siang hari', ''],
    ['Keputusan minggu berikutnya', ''],
  ],
);

const sleepTermTable = ReadingTable(
  title: 'Tabel 4.8 · Keterangan SOL, WASO, TST, TIB, dan SE',
  headers: ['Singkatan', 'Kepanjangan Bahasa Inggris', 'Keterangan'],
  rows: [
    [
      'SOL',
      'Sleep Onset Latency',
      'Waktu sejak mulai berusaha tidur sampai benar-benar tertidur.',
    ],
    [
      'WASO',
      'Wake After Sleep Onset',
      'Total waktu terjaga setelah pertama tertidur hingga bangun untuk memulai aktivitas.',
    ],
    [
      'TST',
      'Total Sleep Time',
      'Total waktu tidur sebenarnya selama periode tidur.',
    ],
    ['TIB', 'Time In Bed', 'Total waktu yang dihabiskan di tempat tidur.'],
    [
      'SE',
      'Sleep Efficiency',
      'Persentase waktu di tempat tidur yang benar-benar digunakan untuk tidur.',
    ],
  ],
);

const sleepDiaryTable = ReadingTable(
  exportable: true,
  title: 'Tabel 4.9 · Buku Harian Tidur',
  headers: [
    'Hari',
    'Masuk tempat tidur',
    'Mulai tidur',
    'Bangun malam',
    'Total lama terjaga',
    'Bangun akhir',
    'Keluar tempat tidur',
    'Tidur siang',
  ],
  rows: [
    ['Senin', '', '', '', '', '', '', ''],
    ['Selasa', '', '', '', '', '', '', ''],
    ['Rabu', '', '', '', '', '', '', ''],
    ['Kamis', '', '', '', '', '', '', ''],
    ['Jumat', '', '', '', '', '', '', ''],
    ['Sabtu', '', '', '', '', '', '', ''],
    ['Minggu', '', '', '', '', '', '', ''],
  ],
);

const adherenceTable = ReadingTable(
  title: 'Tabel 4.10 · Daftar Periksa Komponen Intervensi DISQAM',
  headers: ['Komponen', 'Ya', 'Tidak'],
  rows: [
    ['Mengisi sleep diary', '', ''],
    ['Melaksanakan sleep hygiene', '', ''],
    ['Mengikuti stimulus control', '', ''],
    ['Mengikuti jadwal tidur', '', ''],
    ['Melakukan latihan relaksasi', '', ''],
    ['Melakukan latihan restrukturisasi kognitif', '', ''],
    ['Menghindari aktivitas yang mengganggu tidur', '', ''],
  ],
);

const weeklyEfficiencyWorksheet = ReadingTable(
  exportable: true,
  title: 'Lampiran 2 · Rekap Efisiensi Tidur Mingguan',
  headers: ['Hari', 'TST', 'TIB', 'SE (%)', 'Kantuk siang', 'Catatan'],
  rows: [
    ['1', '', '', '', '', ''],
    ['2', '', '', '', '', ''],
    ['3', '', '', '', '', ''],
    ['4', '', '', '', '', ''],
    ['5', '', '', '', '', ''],
    ['6', '', '', '', '', ''],
    ['7', '', '', '', '', ''],
    ['Rata-rata', '', '', '', '', ''],
  ],
);

const sleepHygieneWorksheet = ReadingTable(
  exportable: true,
  title: 'Lampiran 3 · Daftar Periksa Sleep Hygiene',
  headers: ['Pernyataan', 'Ya', 'Belum'],
  rows: [
    ['Saya bangun pada waktu yang relatif sama.', '', ''],
    ['Saya mendapatkan cahaya pagi bila memungkinkan.', '', ''],
    ['Saya tetap aktif sesuai kemampuan.', '', ''],
    ['Saya membatasi tidur siang berlebihan.', '', ''],
    ['Saya membatasi kafein menjelang malam.', '', ''],
    ['Kamar saya aman dan nyaman.', '', ''],
    ['Saya memiliki rutinitas menjelang tidur.', '', ''],
  ],
);

const stimulusControlWorksheet = ReadingTable(
  exportable: true,
  title: 'Lampiran 4 · Lembar Stimulus Control',
  headers: [
    'Hari',
    'Pergi tidur saat mengantuk',
    'Bangun bila terjaga lama',
    'Kembali saat mengantuk',
    'Bangun pagi konsisten',
    'Catatan',
  ],
  rows: [
    ['1', '', '', '', '', ''],
    ['2', '', '', '', '', ''],
    ['3', '', '', '', '', ''],
    ['4', '', '', '', '', ''],
    ['5', '', '', '', '', ''],
    ['6', '', '', '', '', ''],
    ['7', '', '', '', '', ''],
  ],
);

const thoughtWorksheet = ReadingTable(
  exportable: true,
  title: 'Lampiran 5 · Lembar Kenali · Periksa · Ganti',
  headers: [
    'Situasi',
    'Pikiran otomatis',
    'Perasaan/tubuh',
    'Bukti yang seimbang',
    'Pikiran baru',
  ],
  rows: [
    ['', '', '', '', ''],
    ['', '', '', '', ''],
    ['', '', '', '', ''],
    ['', '', '', '', ''],
    ['', '', '', '', ''],
  ],
);

const programGroup = ContentGroup(
  id: 'program',
  title: 'Program DISQAM',
  asset: 'assets/images/program.webp',
  summary: 'Enam sesi yang dipelajari dan dilatih secara bertahap bersama fasilitator.',
  articles: [
    Article(
      id: 'session-1',
      title: 'Sesi I · Kenali Masalah Tidur dan Kebiasaan Tidur Sehat',
      summary: 'Kenali pola tidur dan mulai perubahan kecil yang realistis.',
      source: 'Materi Program Aplikasi DISQAM, Sesi I; Tabel 4.3–4.4.',
      sections: [
        ReadingSection(
          'Tujuan sesi',
          paragraphs: [
            'Memahami perubahan tidur pada lansia, membedakan lelah dengan mengantuk, dan mulai mengisi buku harian tidur setiap pagi sebagai dasar rencana tidur pribadi.',
          ],
        ),
        ReadingSection(
          'Kenali masalah tidur',
          paragraphs: [
            'Langkah pertama DISQAM adalah mengenali apa yang benar-benar terjadi pada tidur, bukan hanya apa yang dirasakan saat mengalami malam yang buruk.',
          ],
          tables: [sleepProblemTable],
        ),
        ReadingSection(
          'Tugas',
          points: [
            'Isi buku harian tidur setiap pagi, bukan malam hari.',
            'Tidak perlu memperkirakan hingga menit yang sangat tepat. Gunakan perkiraan yang konsisten.',
            'Catat tidur siang dan penggunaan obat tidur sesuai protokol penelitian.',
          ],
          note: '“Saya tidak perlu menebak-nebak tidur saya. Saya akan mencatat pola tidur untuk mengenalnya dengan lebih baik.”',
        ),
        ReadingSection(
          'Kebiasaan tidur sehat',
          paragraphs: [
            'Langkah kedua adalah membangun kebiasaan yang mendukung pola tidur, tanpa menjadikan kebiasaan tidur sehat sebagai satu-satunya terapi.',
          ],
          points: [
            'Bangun pada waktu yang relatif konsisten setiap hari.',
            'Dapatkan paparan cahaya pagi bila memungkinkan.',
            'Pertahankan aktivitas fisik sesuai kemampuan dan anjuran kesehatan.',
            'Batasi tidur siang yang terlalu lama atau terlalu dekat dengan waktu tidur malam.',
            'Kurangi kafein, terutama menjelang sore atau malam.',
            'Hindari alkohol sebagai “obat tidur”.',
            'Ciptakan kamar yang aman, tenang, cukup gelap, dan nyaman.',
            'Bangun rutinitas menjelang tidur yang menenangkan.',
            'Kelola nyeri, sering buang air kecil pada malam hari, dan gejala penyakit kronis bersama tenaga kesehatan.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/sleep-hygiene.png',
              alt: 'Sembilan kebiasaan tidur sehat untuk lansia.',
              caption: 'Kebiasaan tidur sehat untuk lansia',
            ),
          ],
        ),
        ReadingSection(
          'Edukasi kebiasaan tidur',
          points: [
            'Aspek tidur yang normal dan yang menunjukkan adanya gangguan.',
            'Pengaruh kafein dan konsumsi cairan menjelang tidur.',
            'Potensi dampak merugikan penggunaan obat dalam jangka panjang.',
            'Dampak negatif tidur siang.',
            'Pentingnya mempertahankan jadwal tidur dan bangun yang konsisten, termasuk memasang alarm pada waktu yang sama setiap hari selama tujuh hari dalam seminggu.',
            'Lingkungan tidur, seperti suhu, kebisingan, pencahayaan, kenyamanan, dan tingkat kekerasan kasur.',
          ],
          tables: [sleepHygieneTable, sleepHygieneWorksheet],
          note: '“Pilih perubahan kecil yang realistis. Tidak perlu mengubah semua kebiasaan sekaligus.”',
        ),
      ],
    ),
    Article(
      id: 'session-2',
      title: 'Sesi II · Stimulus Control',
      summary: 'Membiasakan tempat tidur sebagai isyarat untuk tidur.',
      source: 'Materi Program Aplikasi DISQAM, Sesi II.',
      sections: [
        ReadingSection(
          'Tujuan sesi',
          paragraphs: [
            'Sesi ini bertujuan mengembalikan hubungan antara tempat tidur dan tidur serta membuat tidur lebih menyatu dan tidak mudah terputus.',
            'Sebagai contoh, jika seseorang berada di tempat tidur selama 8 jam tetapi hanya tidur 4,5 jam, waktu di tempat tidur dapat disesuaikan mendekati waktu yang benar-benar digunakan untuk tidur. Penyesuaian untuk lansia harus dilakukan bertahap dan bersama tenaga kesehatan.',
            'Stimulus control adalah rencana tindakan untuk memperkuat hubungan tempat tidur dan kamar tidur dengan isyarat tidur. Tindakan ini membantu seseorang mengikuti rasa kantuk, bukan hanya berpatokan pada jam tertentu.',
          ],
        ),
        ReadingSection(
          'Tindakan stimulus control',
          points: [
            'Pergi ke tempat tidur ketika mulai mengantuk, bukan hanya karena jam menunjukkan waktu tertentu.',
            'Gunakan tempat tidur terutama untuk tidur. Aktivitas santai lain sebaiknya dilakukan di kursi atau ruang lain bila aman.',
            'Jika belum tertidur dalam 30 menit atau kembali terjaga cukup lama, bangun perlahan dan lakukan kegiatan tenang dengan pencahayaan aman.',
            'Kembali ke tempat tidur ketika rasa mengantuk muncul.',
            'Bangun pada waktu yang relatif tetap setiap pagi.',
            'Batasi tidur siang.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/stimulus-control.png',
              alt: 'Enam langkah membiasakan tempat tidur untuk tidur.',
              caption: 'Membiasakan tempat tidur untuk tidur',
            ),
          ],
        ),
        ReadingSection(
          'Penyesuaian dan keselamatan untuk lansia',
          paragraphs: [
            'Dalam DISQAM, peserta lansia diberi waktu hingga sekitar 30 menit sebelum meninggalkan tempat tidur, bukan aturan dewasa 15–20 menit, agar penyesuaian lebih nyaman.',
            'Jangan berjalan dalam gelap. Gunakan lampu malam dan alat bantu jalan bila digunakan sehari-hari. Pendamping dapat membantu jika ada risiko jatuh. Hindari televisi atau lampu terlalu terang; lakukan kegiatan tenang hingga mengantuk kembali.',
            'Pada awal latihan, kantuk pada siang hari dapat meningkat. Ketika latihan mulai membantu, tidur dapat menjadi lebih efisien. Penambahan waktu di tempat tidur dilakukan bertahap setiap minggu bersama fasilitator.',
          ],
          tables: [stimulusControlWorksheet],
          note: '“Tempat tidur adalah isyarat untuk tidur. Saya tidak perlu berjuang melawan tidur di tempat tidur.”',
        ),
      ],
    ),
    Article(
      id: 'session-3',
      title: 'Sesi III · Pengaturan Waktu Tidur',
      summary:
          'Mengurangi waktu terjaga di tempat tidur secara bertahap dan aman.',
      source: 'Materi Program Aplikasi DISQAM, Sesi III; Tabel 4.5–4.6.',
      sections: [
        ReadingSection(
          'Tujuan sesi',
          paragraphs: [
            'Mengurangi waktu terjaga di tempat tidur agar tidur lebih menyatu, nyenyak, dan tidak sering terputus. Dalam DISQAM digunakan istilah pengaturan waktu tidur atau sleep compression agar tidak dipahami sebagai mengurangi kebutuhan tidur secara ekstrem.',
          ],
        ),
        ReadingSection(
          'Prinsip keselamatan DISQAM',
          points: [
            'Jadwal didasarkan pada buku harian beberapa hari, bukan satu malam yang buruk.',
            'Waktu bangun dipertahankan relatif konsisten.',
            'Pengurangan TIB dilakukan bertahap dan tidak ekstrem.',
            'Pantau kantuk siang, keseimbangan, jatuh, kebingungan, dan perubahan kondisi medis.',
            'Hentikan pengetatan jadwal dan konsultasikan jika terjadi efek yang mengkhawatirkan.',
            'Jangan mengemudi atau melakukan kegiatan berbahaya saat mengantuk.',
          ],
        ),
        ReadingSection(
          'Sleep compression',
          paragraphs: [
            'Sleep restriction konvensional memangkas waktu di tempat tidur lebih cepat. Sleep compression menguranginya secara perlahan dan fleksibel sehingga dapat lebih nyaman bagi lansia. Pelaksanaannya tetap mempertimbangkan kantuk pada siang hari, risiko jatuh, kondisi kesehatan, dan arahan tenaga kesehatan.',
            'Contoh: jika lansia berada di tempat tidur selama 9 jam, waktu tersebut dapat dikurangi 15–30 menit setiap minggu sesuai kondisi dan hasil pemantauan.',
            'Sleep Efficiency (SE) = Total Sleep Time (TST) ÷ Time in Bed (TIB) × 100%.',
          ],
          tables: [
            sleepPlanExampleTable,
            sleepPlanTable,
            weeklyEfficiencyWorksheet,
          ],
          note: '“Tujuannya adalah mengurangi waktu terjaga di tempat tidur dan membuat tidur lebih menyatu, bukan tidur lebih sedikit.”',
        ),
      ],
    ),
    Article(
      id: 'session-4',
      title: 'Sesi IV · Restrukturisasi Kognitif',
      summary: 'Kenali, periksa, dan ganti pikiran yang tidak membantu tidur.',
      source: 'Materi Program Aplikasi DISQAM, Sesi IV; Lampiran 5.',
      sections: [
        ReadingSection(
          'Pengertian',
          paragraphs: [
            'Restrukturisasi kognitif membantu seseorang mengenali, menilai, dan mengubah pikiran, keyakinan, serta penafsiran yang tidak realistis mengenai tidur. Pada lansia, latihan dilakukan secara sederhana, bertahap, konkret, dan menggunakan bahasa yang mudah dipahami.',
          ],
        ),
        ReadingSection(
          'Keyakinan yang sering muncul',
          points: [
            'Menganggap dampak kekurangan tidur akan sangat buruk atau membawa bencana.',
            'Menilai kualitas tidur malam secara keliru.',
            'Menganggap tidur sepenuhnya berada di luar kendali diri.',
            'Memiliki keyakinan yang keliru mengenai perilaku yang mendukung tidur.',
          ],
        ),
        ReadingSection(
          'Kenali · Periksa · Ganti',
          paragraphs: [
            'Pikiran seperti “Saya harus tidur delapan jam”, “Kalau malam ini gagal tidur, besok semuanya akan kacau”, atau “Saya harus memaksa diri tidur sekarang” dapat membuat tubuh dan pikiran semakin tegang.',
          ],
          points: [
            'KENALI pikiran otomatis yang muncul ketika sulit tidur.',
            'PERIKSA apakah pikiran tersebut selalu benar, terlalu mutlak, atau memperbesar ancaman.',
            'GANTI dengan kalimat yang lebih realistis, lembut, dan berdasarkan pengalaman.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/kenali-periksa-ganti.png',
              alt: 'Tiga langkah Kenali, Periksa, dan Ganti.',
              caption: 'Restrukturisasi kognitif: Kenali · Periksa · Ganti',
            ),
          ],
          tables: [thoughtWorksheet],
        ),
        ReadingSection(
          'Kurangi usaha memaksa tidur',
          points: [
            'Hindari terus-menerus memeriksa apakah sudah mengantuk.',
            'Hindari melihat jam berulang kali.',
            'Jangan menilai malam sebagai berhasil atau gagal setiap beberapa menit.',
            'Fokus pada kondisi rileks, bukan memaksa tidur.',
            'Gunakan napas atau kegiatan tenang sebagai peralihan.',
          ],
          note: '“Tidur adalah proses yang muncul ketika kondisi mendukung. Semakin saya memaksa, tubuh dapat menjadi semakin waspada.”',
        ),
      ],
    ),
    Article(
      id: 'session-5',
      title: 'Sesi V · Relaksasi',
      summary:
          'Mengurangi ketegangan tubuh dan pikiran dengan latihan sederhana.',
      source: 'Materi Program Aplikasi DISQAM, Sesi V; Gambar 4.3–4.5.',
      sections: [
        ReadingSection(
          'Tujuan relaksasi',
          paragraphs: [
            'Latihan relaksasi bertujuan mengurangi ketegangan tubuh dan pikiran, bukan membuat tidur secara paksa. Relaksasi pasif membantu lansia mengenali dan melepaskan ketegangan fisik sambil menggunakan imajinasi terbimbing. Relaksasi juga dapat digunakan sebagai pengganti tidur siang untuk membantu efisiensi tidur malam.',
          ],
        ),
        ReadingSection(
          'Latihan pernapasan sederhana',
          points: [
            'Duduk atau berbaring dalam posisi yang nyaman dan aman.',
            'Perhatikan napas tanpa berusaha terlalu banyak mengubahnya.',
            'Tarik napas perlahan melalui hidung.',
            'Rasakan perut atau dada bergerak dengan lembut.',
            'Hembuskan napas perlahan.',
            'Ulangi beberapa menit. Hentikan jika pusing atau tidak nyaman.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/breathing-exercise.jpeg',
              alt: 'Langkah latihan pernapasan sederhana.',
              caption: 'Gambar 4.3 · Latihan relaksasi napas dalam',
            ),
          ],
        ),
        ReadingSection(
          'Relaksasi otot progresif sederhana',
          paragraphs: [
            'Kencangkan kelompok otot dengan ringan selama beberapa detik lalu lepaskan. Hindari area yang nyeri, cedera, atau terbatas. Urutan dapat dimulai dari tangan, bahu, wajah, tungkai, kemudian seluruh tubuh.',
          ],
          media: [
            ReadingMedia(
              asset:
                  'assets/images/materials/progressive-muscle-relaxation.jpeg',
              alt: 'Langkah relaksasi otot progresif sederhana.',
              caption: 'Gambar 4.4 · Relaksasi otot progresif sederhana',
            ),
          ],
        ),
        ReadingSection(
          'Pijat mata untuk lansia',
          paragraphs: [
            'Pijat ringan di sekitar alis dan pelipis dapat memberi rasa nyaman sebelum tidur. Jangan menekan atau menggosok bola mata. Jika memiliki glaukoma, baru menjalani operasi mata, atau sedang mengalami keluhan mata, konsultasikan terlebih dahulu dengan dokter mata.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/eye-massage.jpeg',
              alt: 'Langkah pijat ringan di sekitar mata.',
              caption: 'Gambar 4.5 · Latihan pijat mata untuk lansia',
            ),
          ],
        ),
        ReadingSection(
          'Pencegahan kekambuhan',
          points: [
            'Beberapa malam buruk tidak berarti program gagal.',
            'Kembali ke buku harian jika pola tidur mulai memburuk.',
            'Periksa waktu bangun, tidur siang, kegiatan, kafein, dan stimulus control.',
            'Gunakan latihan kognitif ketika muncul pikiran “saya kembali gagal”.',
            'Gunakan relaksasi untuk menurunkan ketegangan.',
            'Hubungi tenaga kesehatan jika muncul tanda bahaya atau keluhan menetap.',
          ],
          note: '“Tujuan akhir DISQAM adalah kemandirian: peserta mengetahui keterampilan yang perlu digunakan ketika tidur kembali terganggu.”',
        ),
      ],
    ),
    Article(
      id: 'session-6',
      title: 'Sesi VI · Buku Harian Tidur dan Pemantauan',
      summary:
          'Mencatat pola tidur dan melihat perubahan dari minggu ke minggu.',
      source: 'Materi Program Aplikasi DISQAM, Sesi VI; Tabel 4.8–4.10.',
      sections: [
        ReadingSection(
          'Buku harian tidur',
          paragraphs: [
            'Buku harian tidur adalah catatan harian yang mendokumentasikan pola tidur dan bangun secara sistematis. Catatan meliputi waktu masuk tempat tidur, perkiraan mulai tidur, jumlah dan durasi terbangun, waktu bangun, waktu keluar dari tempat tidur, tidur siang, serta obat atau zat yang dapat memengaruhi tidur.',
            'Dalam DISQAM, buku harian menjadi alat pemantauan mandiri. Lansia belajar mengenali pola tidur berdasarkan kebiasaan dan pengalaman sehari-hari, bukan hanya menilai tidurnya “baik” atau “buruk”.',
          ],
        ),
        ReadingSection('Istilah dalam catatan tidur', tables: [sleepTermTable]),
        ReadingSection(
          'Rumus yang digunakan',
          paragraphs: [
            'TIB = waktu bangun − waktu masuk tempat tidur.',
            'TST = TIB − SOL − WASO. Jika ada waktu terjaga lainnya, waktu tersebut ikut dikurangkan.',
            'SE (%) = TST ÷ TIB × 100.',
          ],
        ),
        ReadingSection(
          'Tujuan buku harian dalam DISQAM',
          points: [
            'Mengenali pola tidur dan bangun lansia.',
            'Mengenali kebiasaan yang dapat mengganggu tidur.',
            'Memantau perubahan pola tidur selama intervensi.',
            'Mengenali waktu tidur, waktu bangun, dan terjaga pada malam hari.',
            'Menghitung efisiensi tidur.',
            'Membantu memahami hubungan kebiasaan sehari-hari dan kualitas tidur.',
            'Memberikan umpan balik terhadap perkembangan intervensi.',
            'Membantu fasilitator menilai kepatuhan terhadap program.',
            'Menjadi dasar diskusi pada sesi pemantauan.',
            'Mendukung evaluasi perubahan tidur dari minggu ke minggu.',
          ],
          tables: [sleepDiaryTable, weeklyEfficiencyWorksheet],
          note: '“Buku harian tidur bukan ujian. Tidak ada jawaban benar atau salah. Bapak/Ibu cukup mencatat apa yang benar-benar terjadi.”',
        ),
        ReadingSection(
          'Pemantauan',
          points: [
            'Pemantauan mandiri: lansia mengisi buku harian setiap pagi.',
            'Pemantauan fasilitator: fasilitator menilai buku harian secara berkala.',
            'Pemantauan pendamping: bila perlu, pendamping membantu mengingat atau mencatat informasi.',
          ],
          paragraphs: [
            'Selain pola tidur, DISQAM memantau kepatuhan terhadap intervensi. Perubahan kualitas tidur dipengaruhi oleh efektivitas materi dan sejauh mana peserta menjalankan komponen program.',
          ],
          tables: [adherenceTable],
        ),
      ],
    ),
  ],
);
