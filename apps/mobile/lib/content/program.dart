import 'models.dart';

const sleepProblemTable = ReadingTable(
  exportable: true,
  title: 'Latihan 1 Mengenali Masalah Tidur',
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
  exportable: true,
  title: 'Daftar Periksa Kebiasaan Tidur Sehat',
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
  exportable: true,
  title: 'Contoh Pengaturan Waktu Tidur',
  headers: ['Contoh', 'Nilai'],
  rows: [
    ['Masuk tempat tidur', '22.00'],
    ['Bangun akhir', '06.00'],
    ['Time in Bed', '8 jam'],
    ['Perkiraan Total Sleep Time', '6 jam'],
    ['Sleep Efficiency', '75%'],
  ],
);

const sleepPlanTable = ReadingTable(
  exportable: true,
  title: 'Contoh Lembar Rencana Tidur',
  headers: ['Komponen', 'Rencana'],
  rows: [
    ['Rata-rata Total Sleep Time minggu lalu', ''],
    ['Waktu bangun target', ''],
    ['Waktu masuk tempat tidur target', ''],
    ['Sleep Efficiency rata-rata', ''],
    ['Keluhan siang hari', ''],
    ['Keputusan minggu berikutnya', ''],
  ],
);

const sleepTermTable = ReadingTable(
  exportable: true,
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
  title: 'Buku Harian Tidur (Sleep Diary)',
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
  exportable: true,
  title: 'Daftar Periksa Komponen Intervensi DISQAM',
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

const programGroup = ContentGroup(
  id: 'program',
  title: 'Program DISQAM',
  asset: 'assets/images/program.webp',
  singleSectionIconAsset: 'assets/images/icons/program.webp',
  summary: 'Enam sesi yang dipelajari dan dilatih secara bertahap bersama fasilitator.',
  articles: [
    Article(
      id: 'session-1',
      title:
          'Sesi 1: Mengenali Masalah Tidur dan Sleep Hygiene (Kebiasaan Tidur Sehat)',
      summary: 'Kenali pola tidur dan mulai perubahan kecil yang realistis.',
      source: 'Materi Program Aplikasi DISQAM, Sesi 1.',
      openingParagraphs: [
        'Sesi pertama, lansia dapat melakukan melalui dua langkah, yaitu dengan langkah pertama mengenali masalah tidur dan langkah kedua dengan mengetahui kebiasaan tidur sehat.',
      ],
      sections: [
        ReadingSection(
          'Tujuan',
          paragraphs: [
            'Memahami perubahan tidur pada lansia, membedakan lelah dengan mengantuk, dan mulai mengisi sleep diary setiap pagi sebagai dasar sleep plan individual.',
          ],
        ),
        ReadingSection(
          'Langkah DISQAM',
          subsections: [
            ReadingSubsection(
              'Kenali Masalah Tidur',
              paragraphs: [
                '**Langkah pertama DISQAM:** mengenali apa yang benar-benar terjadi pada tidur, bukan hanya apa yang dirasakan saat malam buruk. Beberapa pertanyaan pada tabel dibawah ini dapat digunakan untuk mengenali masalah tidur.',
              ],
              tables: [sleepProblemTable],
            ),
            ReadingSubsection(
              'Tugas',
              paragraphs: [
                'Tugas yang perlu dilakukan pada sesi 1 langkah pertama ini yaitu:',
              ],
              points: [
                'Isi sleep diary setiap pagi, bukan malam hari.',
                'Tidak perlu memperkirakan hingga menit yang sangat tepat, gunakan perkiraan yang konsisten.',
                'Catat tidur siang dan penggunaan obat tidur sesuai protokol penelitian.',
              ],
              note:
                  '“Saya tidak perlu menebak-nebak tidur saya. Saya akan mencatat pola tidur untuk mengenalnya dengan lebih baik”.',
              noteLabel: 'Pesan',
            ),
            ReadingSubsection(
              'Kebiasaan Tidur Sehat',
              paragraphs: [
                '**Langkah kedua:** membangun Kebiasaan Tidur Sehat (Sleep Hygiene) untuk mendukung pola tidur, tanpa menjadikan sleep hygiene sebagai satu-satunya terapi.',
                'Prinsip kebiasaan tidur sehat untuk lansia diantaranya adalah sebagai berikut:',
              ],
              points: [
                'Bangun pada waktu yang relatif konsisten setiap hari.',
                'Dapatkan paparan cahaya pagi bila memungkinkan.',
                'Pertahankan aktivitas fisik sesuai kemampuan dan anjuran kesehatan.',
                'Batasi tidur siang yang terlalu lama atau terlalu dekat dengan waktu tidur malam.',
                'Kurangi kafein (kopi) terutama menjelang sore/malam.',
                "Hindari alkohol sebagai 'obat tidur'.",
                'Ciptakan kamar yang aman, tenang, cukup gelap, dan nyaman.',
                'Bangun rutinitas menjelang tidur yang menenangkan.',
                'Kelola nyeri, nokturia, dan gejala penyakit kronis bersama tenaga kesehatan.',
              ],
              media: [
                ReadingMedia(
                  asset: 'assets/images/materials/sleep-hygiene.png',
                  alt: 'Sembilan kebiasaan tidur sehat untuk lansia.',
                ),
              ],
            ),
          ],
        ),
        ReadingSection(
          'Edukasi Kebiasaan Tidur',
          paragraphs: [
            'Kebiasaan tidur sehat mengacu pada perilaku yang mendukung tidur yang baik. Lansia diberikan edukasi mengenai:',
          ],
          points: [
            'Aspek tidur yang normal dan yang menunjukkan adanya gangguan.',
            'Pengaruh kafein dan konsumsi cairan menjelang tidur.',
            'Potensi dampak merugikan penggunaan obat dalam jangka panjang.',
            'Dampak negatif tidur siang.',
            'Pentingnya mempertahankan jadwal tidur-bangun yang konsisten, termasuk memasang alarm pada waktu yang sama setiap hari, selama tujuh hari dalam seminggu.',
          ],
          afterPoints: [
            'Mengenai lingkungan tidur lansia juga dibahas, seperti suhu yang nyaman untuk tidur, tingkat kebisingan, pencahayaan, tingkat kekerasan kasur, dan sebagainya.',
          ],
          tables: [sleepHygieneTable],
          note:
              '“Pilih perubahan kecil yang realistis. Tidak perlu mengubah semua kebiasaan sekaligus”.',
          noteLabel: 'Pesan',
        ),
      ],
    ),
    Article(
      id: 'session-2',
      title: 'Sesi 2: Stimulus Control (Kebiasaan Tidur yang Baik)',
      summary: 'Membiasakan tempat tidur sebagai isyarat untuk tidur.',
      source: 'Materi Program Aplikasi DISQAM, Sesi 2.',
      sections: [
        ReadingSection(
          'Tujuan',
          paragraphs: [
            'Tujuan sesi ini yaitu mengembalikan hubungan antara tempat tidur dan tidur, serta mengurangi hubungan tempat tidur dengan khawatir, melihat jam, atau terjaga lama.',
            'Tujuan intervensi ini adalah membuat tidur lebih menyatu dan tidak terputus-putus dengan membatasi waktu di tempat tidur berdasarkan jumlah waktu yang benar-benar digunakan seseorang untuk tidur.',
            'Sebagai contoh, jika seseorang menghabiskan 8 (delapan) jam di tempat tidur, tetapi hanya tidur selama 4 (empat) setengah jam, maka waktu di tempat tidurnya akan ditetapkan hanya 4 (empat) setengah jam.',
            'Stimulus control (kebiasaan tidur yang baik) merupakan rencana tindakan yang dirancang untuk memperkuat hubungan antara tempat tidur dan kamar tidur dengan isyarat untuk tidur. Selain itu, tindakan ini membantu seseorang mengandalkan tanda-tanda fisik berupa kelelahan dan rasa kantuk, alih-alih hanya berpatokan pada jam tidur tertentu, untuk mulai tidur.',
          ],
        ),
        ReadingSection(
          'Tindakan stimulus control',
          paragraphs: [
            'Beberapa tindakan stimulus control (kebiasaan tidur yang baik) pada program DISQAM adalah sebagai berikut:',
          ],
          points: [
            'Pergi ke tempat tidur ketika mulai mengantuk, bukan hanya karena jam menunjukkan waktu tertentu.',
            'Gunakan tempat tidur terutama untuk tidur. Aktivitas santai lain sebaiknya dilakukan di kursi atau di ruang lain bila aman.',
            'Jika belum tertidur dalam waktu 30 menit atau kembali terjaga cukup lama, bangun secara perlahan dan lakukan aktivitas tenang dengan pencahayaan aman.',
            'Kembali ke tempat tidur ketika rasa mengantuk muncul.',
            'Bangun pada waktu yang relatif tetap setiap pagi.',
            'Batasi tidur siang',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/stimulus-control.png',
              alt: 'Enam langkah membiasakan tempat tidur untuk tidur.',
            ),
          ],
        ),
        ReadingSection(
          'Penyesuaian dan keselamatan untuk lansia',
          paragraphs: [
            'Pada DISQAM, stimulus control dimodifikasi untuk kebutuhan lansia. Dibanding aturan dewasa yang sering menggunakan 15-20 menit, peserta lansia diberi ruang hingga sekitar 30 menit sebelum meninggalkan tempat tidur, agar adaptasi lebih nyaman (Kim et al., 2025). Modifikasi keselamatan dapat dilakukan dengan jangan berjalan dalam keadaan gelap, gunakan lampu malam yang aman, gunakan alat bantu jalan bila memang digunakan sehari-hari, Caregiver (pendamping atau keluarga) yang dapat membantu bila ada risiko jatuh, hindari kegiatan yang membuat tubuh dan pikiran semakin aktif, seperti menonton televisi, atau menyalakan lampu terlalu terang. Lakukan kegiatan yang tenang hingga mengantuk kembali.',
            'Pada awal penanganan, rasa kantuk pada siang hari biasanya meningkat. Namun, ketika penanganan mulai memberikan hasil, tidur menjadi lebih efisien. Pedoman penggunaan teknik ini pada lansia merekomendasikan penambahan waktu di tempat tidur yang telah ditetapkan secara bertahap setiap minggu (Laidlaw et al., 2003).',
          ],
          note:
              '“Tempat tidur adalah isyarat untuk tidur. Saya tidak perlu berjuang melawan tidur di tempat tidur”.',
          noteLabel: 'Pesan',
        ),
      ],
    ),
    Article(
      id: 'session-3',
      title: 'Sesi 3: Pengaturan Waktu Tidur',
      summary:
          'Mengurangi waktu terjaga di tempat tidur secara bertahap dan aman.',
      source: 'Materi Program Aplikasi DISQAM, Sesi 3.',
      sections: [
        ReadingSection(
          'Tujuan',
          paragraphs: [
            'Tujuan sesi ini mengurangi waktu terjaga di tempat tidur dan tidur yang lebih menyatu, nyenyak, dan tidak sering terputus karena terbangun. Dalam DISQAM, istilah yang digunakan untuk lansia adalah “**pengaturan waktu tidur**” atau “**sleep compression**” agar tidak dipahami sebagai upaya mengurangi kebutuhan tidur secara ekstrem.',
          ],
        ),
        ReadingSection(
          'Prinsip keselamatan DISQAM',
          points: [
            'Jadwal didasarkan pada sleep diary beberapa hari, bukan satu malam buruk.',
            'Waktu bangun dipertahankan relatif konsisten.',
            'Pengurangan Time in Bed (waktu di atas tempat tidur)  dilakukan bertahap dan tidak ekstrem.',
            'Pantau kantuk siang, keseimbangan, jatuh, kebingungan, dan perubahan kondisi medis.',
            'Hentikan pengetatan jadwal dan konsultasikan bila terjadi efek yang mengkhawatirkan.',
            'Jangan mengemudi atau melakukan aktivitas berbahaya bila mengantuk.',
          ],
        ),
        ReadingSection(
          'Sleep compression',
          paragraphs: [
            'McLaren et al. (2023) juga membedakan sleep restriction konvensional (pembatasan waktu di tempat tidur dengan aturan standar) yang memangkas TIB (Time In Bad) secara lebih cepat dengan sleep compression (pengurangan waktu di tempat tidur secara bertahap) yang mengurangi TIB secara bertahap.',
            'Dibandingkan sleep restriction konvensional, sleep compression dilakukan secara lebih perlahan dan fleksibel sehingga dapat lebih nyaman bagi lansia. Pelaksanaannya tetap perlu mempertimbangkan rasa kantuk pada siang hari, risiko jatuh, kondisi kesehatan, dan arahan tenaga kesehatan',
            '**Contoh kasus**',
            'Jika lansia berada di tempat tidur selama 9 jam, waktu tersebut dapat dikurangi secara bertahap, misalnya 15–30 menit setiap minggu, sesuai kondisi dan hasil pemantauan tidurnya.',
          ],
          callout:
              'Sleep Efficiency (SE) = Total Sleep Time (TST) / Time in Bed (TIB) x 100%',
          calloutLabel: 'Rumus Sleep Efficiency',
          tables: [sleepPlanExampleTable, sleepPlanTable],
          note:
              '“Tujuannya adalah mengurangi waktu terjaga di tempat tidur dan membuat tidur lebih terkonsolidasi, bukan tidur lebih sedikit”.',
          noteLabel: 'Pesan',
        ),
      ],
    ),
    Article(
      id: 'session-4',
      title: 'Sesi 4: Restrukturisasi Kognitif (Tenangkan Pikiran)',
      summary: 'Kenali, periksa, dan ganti pikiran yang tidak membantu tidur.',
      source: 'Materi Program Aplikasi DISQAM, Sesi 4.',
      sections: [
        ReadingSection(
          'Pengertian',
          paragraphs: [
            'Restrukturisasi kognitif (cognitive restructuring) merupakan salah satu komponen penting dalam CBT-I yang diadaptasi ke DISQAM yang bertujuan membantu individu mengenali, mengevaluasi, dan mengubah pikiran, keyakinan, serta interpretasi yang tidak realistis atau maladaptif mengenai tidur.',
            'Pada lansia, restrukturisasi kognitif perlu dilakukan secara sederhana, bertahap, konkret, dan menggunakan bahasa yang mudah dipahami. Hal ini penting karena intervensi DISQAM dapat menjadi lebih menuntut secara kognitif pada sebagian lansia, terutama apabila terdapat keterbatasan fungsi kognitif.',
          ],
        ),
        ReadingSection(
          'Keyakinan yang sering muncul',
          paragraphs: [
            'Kekhawatiran, keyakinan yang tidak membantu mengenai tidur, dan pikiran yang muncul tanpa diinginkan dapat menyertai insomnia. Keyakinan keliru yang umum ditemukan pada insomnia meliputi:',
          ],
          points: [
            'Menganggap dampak kekurangan tidur akan sangat buruk atau membawa bencana.',
            'Menilai secara keliru kualitas tidur yang diperoleh pada malam hari.',
            'Memiliki anggapan keliru bahwa tidur berada di luar kendali diri.',
            'Memiliki keyakinan yang keliru mengenai perilaku yang mendukung tidur yang baik.',
          ],
        ),
        ReadingSection(
          'Kenali · Periksa · Ganti',
          paragraphs: [
            'Sebagaimana pada gangguan lainnya, restrukturisasi kognitif digunakan untuk mengenali keyakinan yang keliru tersebut dan menemukan informasi yang realistis untuk meninjaunya kembali. Selanjutnya, keyakinan tersebut diganti dengan keyakinan yang lebih membantu dan mendukung tidur.',
            "Misalnya, pikiran seperti 'Saya harus tidur delapan jam', 'Kalau malam ini gagal tidur, besok semuanya akan kacau', atau 'Saya harus memaksa diri tidur sekarang' dapat membuat tubuh dan pikiran semakin tegang serta mendorong seseorang terlalu memaksakan diri untuk tidur sehingga tidur justru lebih sulit.",
            'Teknik Restrukturisasi kognitif pada komponen program DISQAM dapat dilakukan melalui **KPG (KENALI–PERIKSA–GANTI)**.',
          ],
          points: [
            '**KENALI** pikiran otomatis yang muncul ketika sulit tidur.',
            '**PERIKSA** apakah pikiran tersebut selalu benar, terlalu mutlak, atau memperbesar ancaman.',
            '**GANTI** dengan kalimat yang lebih realistis, lembut, dan berbasis pengalaman.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/kenali-periksa-ganti.png',
              alt: 'Tiga langkah Kenali, Periksa, dan Ganti.',
              caption:
                  'Restrukturisasi Kognitif melalui KPG (KENALI–PERIKSA–GANTI)',
            ),
          ],
        ),
        ReadingSection(
          'Kurangi usaha memaksa tidur',
          paragraphs: [
            'Mengurangi usaha berlebihan untuk memaksakan diri agar tidur (sleep effort) dapat dilakukan dengan cara berikut:',
          ],
          points: [
            'Hindari terus-menerus mengecek apakah sudah mengantuk.',
            'Hindari memantau jam berulang kali.',
            "Jangan menilai malam sebagai 'berhasil/gagal' setiap beberapa menit.",
            'Fokus pada kondisi rileks, bukan pada memaksa tidur.',
            'Gunakan napas atau aktivitas tenang sebagai transisi.',
          ],
          note:
              '“Tidur adalah proses yang muncul ketika kondisi mendukung. Semakin saya memaksa, semakin tubuh dapat menjadi waspada”.',
          noteLabel: 'Pesan',
        ),
      ],
    ),
    Article(
      id: 'session-5',
      title: 'Sesi 5: Relaksasi',
      summary:
          'Mengurangi ketegangan tubuh dan pikiran dengan latihan sederhana.',
      source: 'Materi Program Aplikasi DISQAM, Sesi 5.',
      openingParagraphs: [
        'Relaksasi merupakan salah satu komponen DISQAM. Tujuannya bukan membuat tidur secara paksa, tetapi mengurangi arousal fisiologis dan kognitif.',
        'Sebagai alternatif, telah dikembangkan bentuk relaksasi pasif. Dalam teknik ini, lansia dilatih untuk mengenali dan merilekskan ketegangan fisik yang dirasakan, sambil menggunakan imajinasi terbimbing untuk menenangkan pikiran yang terus berulang dan melemaskan otot yang tegang. Teknik relaksasi juga direkomendasikan sebagai pengganti tidur siang pada lansia untuk meningkatkan efisiensi tidur pada malam hari (Laidlaw et al., 2003).',
        'Beberapa latihan relaksasi sederhana yang dapat dilakukan, antara lain:',
      ],
      sections: [
        ReadingSection(
          'Latihan pernapasan sederhana',
          points: [
            'Duduk atau berbaring dalam posisi yang nyaman dan aman.',
            'Letakkan perhatian pada napas tanpa berusaha mengubahnya terlalu banyak.',
            'Tarik napas perlahan melalui hidung.',
            'Rasakan perut atau dada bergerak dengan lembut.',
            'Hembuskan napas perlahan.',
            'Ulangi beberapa menit; hentikan bila pusing atau tidak nyaman.',
          ],
          afterPoints: [
            'Langkah-langkah latihannya secara ringkas dapat dilihat pada ilustrasi berikut:',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/breathing-exercise.jpeg',
              alt: 'Langkah latihan pernapasan sederhana.',
              caption: 'Latihan relaksasi napas dalam',
            ),
          ],
        ),
        ReadingSection(
          'Relaksasi otot progresif sederhana',
          paragraphs: [
            'Kencangkan kelompok otot dengan ringan selama beberapa detik lalu lepaskan. Hindari area yang nyeri, cedera, atau memiliki keterbatasan tertentu. Urutan dapat dimulai dari tangan, bahu, wajah, tungkai, kemudian seluruh tubuh. Langkah-langkah relaksasi otot progresif sederhana dapat dilihat pada ilustrasi berikut:',
          ],
          media: [
            ReadingMedia(
              asset:
                  'assets/images/materials/progressive-muscle-relaxation.png',
              alt: 'Langkah relaksasi otot progresif sederhana.',
              caption: 'Latihan relaksasi otot progresif sederhana',
            ),
          ],
        ),
        ReadingSection(
          'Pijat mata untuk lansia',
          paragraphs: [
            'Pijat mata membantu memberikan rasa nyaman dan membantu relaksasi sebelum tidur. Pijatan dilakukan pada area sekitar alis dan pelipis, bukan pada bola mata. Jangan menekan atau menggosok bola mata. Jika memiliki glaukoma, baru menjalani operasi mata, atau sedang mengalami keluhan mata, konsultasikan terlebih dahulu dengan dokter mata. Menggosok mata dapat menimbulkan cedera dan meningkatkan tekanan di dalam mata.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/eye-massage.png',
              alt: 'Langkah pijat ringan di sekitar mata.',
              caption: 'Latihan Pijat Mata untuk Lansia',
            ),
          ],
        ),
        ReadingSection(
          'Pencegahan kekambuhan',
          points: [
            'Beberapa malam buruk tidak berarti program gagal.',
            'Kembali ke diary bila pola tidur mulai memburuk.',
            'Periksa kembali waktu bangun, tidur siang, aktivitas, kafein, dan stimulus control.',
            "Gunakan teknik kognitif ketika muncul pikiran 'saya kembali gagal'.",
            'Kembali ke relaksasi untuk menurunkan arousal.',
            'Hubungi tenaga kesehatan bila muncul red flags atau keluhan menetap.',
          ],
          note:
              '“Tujuan akhir DISQAM adalah kemandirian: peserta mengetahui keterampilan apa yang perlu digunakan ketika tidur kembali terganggu”.',
          noteLabel: 'Pesan',
        ),
      ],
    ),
    Article(
      id: 'session-6',
      title: 'Sesi 6: Sleep Diary (Buku Harian Tidur dan Monitoring)',
      summary:
          'Mencatat pola tidur dan melihat perubahan dari minggu ke minggu.',
      source: 'Materi Program Aplikasi DISQAM, Sesi 6.',
      sections: [
        ReadingSection(
          'Buku harian tidur',
          paragraphs: [
            '**Sleep diary atau buku harian tidur** adalah catatan harian yang digunakan untuk mendokumentasikan pola tidur dan bangun seseorang secara sistematis. Informasi yang dicatat umumnya meliputi waktu masuk tempat tidur, perkiraan waktu mulai tidur, jumlah dan durasi terbangun pada malam hari, waktu bangun pagi, waktu keluar dari tempat tidur, tidur siang, serta penggunaan obat atau zat yang dapat memengaruhi tidur (Carney et al., 2012; Morin et al., 2015).',
            'Dalam DISQAM, sleep diary merupakan salah satu alat penting untuk memantau diri sendiri (self-monitoring). Lansia tidak hanya mencatat apakah tidurnya “baik” atau “buruk”, tetapi belajar mengenali pola tidur secara objektif berdasarkan kebiasaan dan pengalaman tidur sehari-hari. Sleep diary juga dapat membantu menghitung Sleep Onset Latency (SOL) yaitu waktu yang dibutuhkan sejak mulai berusaha tidur sampai benar-benar tertidur, Wake After Sleep Onset (WASO) yaitu total waktu terjaga setelah pertama kali tertidur hingga bangun untuk memulai aktivitas, Total Sleep Time (TST) yaitu total waktu tidur sebenarnya selama periode tidur, Time In Bed (TIB) yaitu total waktu yang dihabiskan di tempat tidur, dan Sleep Efficiency (SE) yaitu efisiensi tidur, yaitu persentase waktu di tempat tidur yang benar-benar digunakan untuk tidur.',
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
          'Tujuan Sleep Diary dalam Program DISQAM',
          paragraphs: ['Penggunaan sleep diary dalam DISQAM bertujuan untuk:'],
          points: [
            'Mengidentifikasi pola tidur dan bangun lansia.',
            'Mengidentifikasi kebiasaan yang dapat mengganggu tidur.',
            'Memantau perubahan pola tidur selama intervensi.',
            'Mengidentifikasi waktu tidur, waktu bangun, dan terjaga pada malam hari.',
            'Menghitung Sleep Efficiency (SE).',
            'Membantu lansia memahami hubungan antara kebiasaan sehari-hari dan kualitas tidur.',
            'Memberikan umpan balik terhadap perkembangan intervensi.',
            'Membantu fasilitator mengevaluasi kepatuhan terhadap program DISQAM.',
            'Menjadi dasar diskusi pada sesi monitoring.',
            'Mendukung evaluasi perubahan tidur dari minggu ke minggu.',
          ],
          afterPoints: [
            'Sleep diary juga direkomendasikan sebagai alat klinis untuk memperoleh informasi longitudinal (Informasi yang dikumpulkan atau catatan perkembangan yang dipantau dari waktu ke waktu) mengenai pola tidur dan respons terhadap intervensi insomnia (Carney et al., 2012). Contoh sleep diary dapat dilihat pada tabel dibawah ini:',
          ],
          tables: [sleepDiaryTable],
          note:
              '“Sleep diary bukan ujian. Tidak ada jawaban benar atau salah. Bapak/Ibu cukup mencatat apa yang benar-benar terjadi.”',
          noteLabel: 'Pesan',
        ),
        ReadingSection(
          'Monitoring',
          paragraphs: [
            'Monitoring merupakan proses pemantauan perubahan pola tidur selama program berlangsung. Dalam DISQAM, monitoring dapat dilakukan melalui tiga tingkat:',
          ],
          points: [
            '**Monitoring mandiri:** Lansia mengisi sleep diary setiap pagi.',
            '**Monitoring fasilitator:** Fasilitator mengevaluasi sleep diary secara berkala.',
            '**Monitoring caregiver atau pendamping:** Jika diperlukan, caregiver membantu lansia mengingat atau mencatat informasi yang diperlukan.',
            '**Monitoring Kepatuhan Intervensi:** Selain pola tidur, DISQAM perlu memantau adherence/kepatuhan terhadap intervensi. Hal ini penting karena perubahan kualitas tidur tidak hanya dipengaruhi oleh efektivitas materi, tetapi juga oleh sejauh mana peserta menjalankan komponen intervensi yang dapat dilakukan pemantauan melalui lembar daftar periksa komponen intervensi DISQAM yang dilaksanakan seperti pada tabel dibawah ini:',
          ],
          tables: [adherenceTable],
        ),
      ],
    ),
  ],
);
