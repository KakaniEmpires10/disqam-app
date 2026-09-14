import 'models.dart';
import 'program.dart';

const caregiverCommunicationTable = ReadingTable(
  title: 'Tabel 4.11 · Contoh Komunikasi',
  headers: ['Hindari', 'Gunakan'],
  rows: [
    [
      '“Ayo tidur, harus tidur sekarang.”',
      '“Tidak perlu memaksa tidur. Kita buat kondisi lebih nyaman dulu.”',
    ],
    [
      '“Kenapa belum tidur juga?”',
      '“Kalau belum mengantuk, boleh lakukan kegiatan tenang dulu.”',
    ],
    [
      '“Jangan sampai besok sakit karena kurang tidur.”',
      '“Kita ikuti rencana dan lihat pola beberapa hari, bukan satu malam saja.”',
    ],
  ],
);

const weeklyEfficiencyTable = ReadingTable(
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

const sleepHygieneAppendixTable = ReadingTable(
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

const stimulusControlAppendixTable = ReadingTable(
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

const thoughtWorksheetTable = ReadingTable(
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

const sleepGroup = ContentGroup(
  id: 'sleep',
  title: 'Konsep Tidur',
  asset: 'assets/images/sleep.webp',
  summary: 'Mengenal tidur, perubahan pada lansia, serta gangguan yang perlu diperhatikan.',
  articles: [
    Article(
      id: 'sleep-definition',
      title: '1. Pengertian Tidur',
      summary: 'Tidur adalah proses aktif untuk memulihkan tubuh dan otak.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 1.',
      sections: [
        ReadingSection(
          'Pengertian tidur',
          paragraphs: [
            'Tidur merupakan keadaan tubuh yang ditandai dengan perubahan tingkat kesadaran, aktivitas otak, reaksi terhadap rangsangan dari lingkungan, dan berbagai fungsi tubuh. Tidur bukan hanya saat tubuh berhenti beraktivitas. Ketika tidur, tubuh dan otak tetap bekerja untuk memulihkan tenaga, memperbaiki sel-sel tubuh, dan menjaga kesehatan (Miner & Kryger, 2020).',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-functions',
      title: '2. Fungsi Tidur',
      summary: 'Tidur mendukung tubuh, otak, emosi, dan kegiatan sehari-hari.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 2.',
      sections: [
        ReadingSection(
          'Fungsi tidur',
          paragraphs: [
            'Tidur berhubungan erat dengan fungsi biologis dan psikologis. Pada lansia, tidur yang baik mendukung fungsi fisik, daya pikir, dan emosi. Gangguan tidur dapat berkaitan dengan masalah kesehatan dan penurunan fungsi (Miner & Kryger, 2020).',
          ],
          points: [
            'Mendukung pemulihan tubuh.',
            'Memelihara fungsi otak, pembelajaran, dan daya ingat.',
            'Membantu mengelola perasaan dan menjaga suasana hati.',
            'Memelihara kemampuan melakukan kegiatan sehari-hari.',
            'Mendukung kesehatan secara keseluruhan.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/sleep-benefits.png',
              alt: 'Manfaat tidur bagi lansia.',
              caption: 'Manfaat tidur bagi lansia',
            ),
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-cycle',
      title: '3. Siklus Tidur',
      summary: 'Tubuh melewati tidur NREM dan REM berulang kali.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 3.',
      sections: [
        ReadingSection(
          'Siklus tidur',
          paragraphs: [
            'Tidur adalah proses aktif yang diatur oleh otak. Sepanjang malam, tubuh melewati beberapa tahap dengan kedalaman dan aktivitas otak yang berbeda. Susunannya disebut struktur tidur atau sleep architecture.',
            'Tidur NREM terdiri atas tahap N1, N2, dan N3. Tidur REM ditandai gerakan mata cepat, aktivitas otak meningkat, dan otot sangat rileks. Pergantian NREM menuju REM dan kembali lagi disebut siklus tidur. Tubuh biasanya melewati 4–6 siklus per malam. Setiap siklus berlangsung sekitar 90–110 menit, tetapi dapat berbeda pada setiap orang dan setiap siklus (Patel et al., 2024).',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/sleep-cycle.jpeg',
              alt: 'Siklus tidur NREM dan REM.',
              caption: 'Siklus tidur',
            ),
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-processes',
      title: '4. Proses Utama Tidur',
      summary: 'Dorongan tidur dan jam alami tubuh bekerja bersama.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 4.',
      sections: [
        ReadingSection(
          'Dorongan tidur',
          paragraphs: [
            'Dorongan tidur meningkat selama seseorang terjaga. Semakin lama tidak tidur, semakin besar kebutuhan tubuh untuk tidur. Setelah tidur dimulai, dorongan ini berkurang. Tidur siang terlalu lama dapat mengurangi dorongan tidur sehingga malam hari lebih sulit mengantuk.',
          ],
        ),
        ReadingSection(
          'Jam alami tubuh',
          paragraphs: [
            'Jam alami tubuh mengatur waktu tidur dan bangun dalam pola sekitar 24 jam. Sistem ini dipengaruhi cahaya dan kegelapan, waktu beraktivitas, jadwal makan, kebiasaan tidur dan bangun, interaksi sosial, serta pelepasan hormon termasuk melatonin.',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-stages',
      title: '5. Tahap-Tahap Tidur',
      summary: 'Kenali tahap N1, N2, N3, dan REM.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 5.',
      sections: [
        ReadingSection(
          'Tahap N1 · mulai tertidur',
          paragraphs: [
            'N1 adalah peralihan dari terjaga menuju tidur dan merupakan tahap paling ringan. Mata mulai terpejam, gerakan mata melambat, otot mengendur, denyut jantung dan napas melambat, respons terhadap sekitar berkurang, dan seseorang masih mudah dibangunkan.',
            'Sebagian orang merasakan sensasi seperti jatuh atau sentakan kaki saat mulai tertidur. Hal ini umumnya normal. Jika dibangunkan, seseorang mungkin merasa belum benar-benar tidur.',
            'Dalam pemeriksaan aktivitas otak, tahap N1 ditandai dengan berkurangnya gelombang alfa saat terjaga dan munculnya gelombang teta. Tahap ini umumnya hanya menempati sebagian kecil dari keseluruhan waktu tidur.',
          ],
        ),
        ReadingSection(
          'Tahap N2 · tidur semakin stabil',
          paragraphs: [
            'Pada N2, tidur menjadi lebih stabil. Denyut jantung melambat, napas lebih teratur, suhu tubuh menurun, otot lebih rileks, gerakan mata berhenti, dan kesadaran terhadap lingkungan berkurang.',
            'Kumparan tidur membantu mempertahankan tidur serta diduga berperan dalam pembelajaran dan penyimpanan ingatan. Kompleks-K membantu otak merespons rangsangan dari lingkungan tanpa selalu membuat seseorang terbangun. N2 merupakan tahap yang paling banyak ditemui selama tidur malam dan biasanya semakin panjang pada siklus berikutnya (Patel et al., 2024).',
          ],
        ),
        ReadingSection(
          'Tahap N3 · tidur dalam',
          paragraphs: [
            'N3 adalah tidur paling dalam atau tidur gelombang lambat. Denyut jantung dan napas lebih lambat dan stabil, otot sangat rileks, dan tubuh lebih sulit dibangunkan. Tahap ini mendukung pemulihan fisik, perbaikan jaringan, energi, kekebalan tubuh, hormon, dan ingatan.',
            'Jika dibangunkan tiba-tiba, seseorang dapat merasa bingung atau lemas selama beberapa saat. N3 lebih banyak terjadi pada sepertiga awal malam dan berkurang menjelang pagi (Mander et al., 2017).',
            'Berjalan sambil tidur, teror malam, dan berbicara tanpa sadar dapat muncul dari tidur NREM dalam, terutama pada tahap N3.',
          ],
        ),
        ReadingSection(
          'Tahap REM · aktivitas otak meningkat',
          paragraphs: [
            'REM berarti Rapid Eye Movement atau gerakan mata cepat. Aktivitas otak meningkat mendekati keadaan terjaga, tetapi sebagian besar otot tubuh sangat rileks. REM berkaitan dengan mimpi, pengolahan emosi, pembelajaran, dan ingatan.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/sleep-stages.png',
              alt: 'Tahap tidur N1, N2, N3, dan REM.',
              caption: 'Mengenali tahap tidur',
            ),
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-aging',
      title: '6. Perubahan Tidur pada Lansia',
      summary: 'Pola tidur dapat berubah seiring usia, tetapi gangguan menetap perlu dinilai.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 6.',
      sections: [
        ReadingSection(
          'Perubahan yang sering terjadi',
          points: [
            'Tidur lebih ringan karena lebih banyak berada pada N1 dan N2 serta berkurangnya N3.',
            'Tidur lebih sering terputus dan waktu terjaga setelah mulai tidur dapat lebih panjang.',
            'Tidur dalam berkurang sehingga tidur terasa kurang nyenyak walaupun lama berada di tempat tidur.',
            'Jam alami tubuh dapat bergeser sehingga mengantuk dan bangun lebih awal.',
            'REM dapat sedikit menurun, tetapi penyakit, obat, gangguan pernapasan, depresi, dan kebiasaan tidur sering lebih berpengaruh.',
            'Efisiensi tidur menurun karena tidak seluruh waktu di tempat tidur digunakan untuk tidur.',
          ],
          paragraphs: [
            'Keluhan tidur juga dapat dipengaruhi nyeri kronis, sesak napas, penyakit jantung atau paru, diabetes, sering buang air kecil pada malam hari, kecemasan atau depresi, kurang kegiatan siang hari, tidur siang terlalu lama, obat tertentu, apnea tidur, sindrom kaki gelisah, dan lingkungan yang tidak nyaman.',
            'Besarnya perubahan berbeda pada setiap orang. Sebagian perubahan tidur mulai relatif stabil setelah usia 60 tahun (Li et al., 2022).',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-disorders',
      title: '7. Gangguan Tidur pada Lansia',
      summary:
          'Mengenali insomnia dan gangguan tidur lain yang perlu diperiksa.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 7.',
      sections: [
        ReadingSection(
          'Insomnia',
          paragraphs: [
            'Insomnia adalah keluhan tidur yang tidak cukup dan tidak memberi rasa segar setelah bangun, berlangsung setidaknya satu bulan, serta mengganggu fungsi pekerjaan atau sosial. Diagnosis perlu memastikan keluhan bukan disebabkan gangguan tidur lain, seperti apnea tidur, sindrom kaki gelisah, atau gangguan gerakan anggota tubuh berkala.',
          ],
          points: [
            'Insomnia awal tidur: sulit mulai tertidur.',
            'Insomnia mempertahankan tidur: sering terbangun, bangun terlalu pagi, atau sulit tidur kembali.',
            'Insomnia campuran: sulit mulai tidur sekaligus mempertahankan tidur.',
          ],
          note: 'Insomnia primer terjadi tanpa kondisi medis lain, gangguan kejiwaan, atau penggunaan zat. Insomnia sekunder berkaitan dengan kondisi lain tersebut.',
        ),
        ReadingSection(
          'Gangguan pernapasan saat tidur',
          paragraphs: [
            'Gangguan ini mencakup obstructive sleep apnea, yaitu saluran napas menyempit atau tertutup sementara sehingga napas berulang kali berhenti. Perhatikan mendengkur keras, napas berhenti yang dilihat orang lain, terbangun seperti tersedak, atau kantuk berlebihan pada siang hari (AASM, 2023).',
          ],
        ),
        ReadingSection(
          'Gangguan jam tidur dan bangun',
          paragraphs: [
            'Gangguan terjadi ketika pola tidur dan bangun tidak selaras dengan jam alami tubuh atau tuntutan lingkungan (Miner & Kryger, 2020; AASM, 2023).',
          ],
        ),
        ReadingSection(
          'Parasomnia',
          paragraphs: [
            'Parasomnia mencakup kejadian atau perilaku yang tidak diharapkan selama tidur atau peralihan antara tidur dan terjaga (AASM, 2023).',
          ],
        ),
        ReadingSection(
          'Gangguan gerakan saat tidur',
          paragraphs: [
            'Sindrom kaki gelisah membuat kaki tidak nyaman dan menimbulkan dorongan kuat untuk menggerakkannya, terutama saat duduk, berbaring, atau menjelang tidur. Keluhan dapat berupa kesemutan, tertusuk, merayap, gatal, atau pegal dan biasanya berkurang setelah bergerak (AASM, 2023).',
          ],
          note: 'Informasi ini membantu mengenali keluhan, bukan menentukan diagnosis. Pemeriksaan dilakukan oleh tenaga kesehatan.',
        ),
      ],
    ),
    Article(
      id: 'sleep-factors',
      title: '8. Faktor Penyebab Gangguan Tidur',
      summary:
          'Tubuh, pikiran, kebiasaan, lingkungan, dan obat saling memengaruhi.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 8.',
      sections: [
        ReadingSection(
          'Faktor biologis',
          paragraphs: [
            'Masalah tidur pada lansia biasanya tidak disebabkan satu hal. Penuaan, penyakit menahun, nyeri, sesak napas, dan masalah kesehatan lain dapat membuat tidur semakin terganggu (Miner & Kryger, 2020).',
          ],
        ),
        ReadingSection(
          'Faktor psikologis dan sosial',
          paragraphs: [
            'Kesepian, stres, kekhawatiran, kehilangan orang terdekat, kurang dukungan keluarga, dan kondisi sosial lain dapat membuat lansia sulit tidur atau sering terbangun (Miner & Kryger, 2020; Riemann et al., 2023).',
          ],
        ),
        ReadingSection(
          'Faktor perilaku',
          paragraphs: [
            'Waktu tidur tidak teratur, terlalu lama di tempat tidur saat tidak tidur, tidur siang yang tidak sesuai, atau menggunakan tempat tidur untuk kegiatan selain tidur dapat mempertahankan masalah tidur.',
          ],
        ),
        ReadingSection(
          'Faktor lingkungan',
          paragraphs: [
            'Suara, cahaya, suhu, kenyamanan, dan keamanan kamar dapat memengaruhi kemampuan tidur lebih nyenyak dan tidak sering terbangun.',
          ],
        ),
        ReadingSection(
          'Obat dan polifarmasi',
          paragraphs: [
            'Polifarmasi adalah penggunaan banyak jenis obat secara bersamaan. Hal ini perlu diperhatikan pada lansia dengan gangguan tidur.',
          ],
          note: 'Jangan menghentikan atau mengubah obat sendiri. Bicarakan dengan tenaga kesehatan.',
        ),
      ],
    ),
    Article(
      id: 'sleep-mechanisms',
      title: '9. Mekanisme Gangguan Tidur pada Lansia',
      summary: 'Tubuh atau pikiran dapat tetap terlalu aktif menjelang tidur.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 9.',
      sections: [
        ReadingSection(
          'Tubuh sulit rileks',
          paragraphs: [
            'Tubuh masih tegang atau terlalu aktif menjelang tidur. Tandanya dapat berupa jantung berdebar, napas cepat, otot tegang, gelisah, atau sulit merasa nyaman. Relaksasi dapat membantu mempersiapkan tubuh untuk tidur (Edinger et al., 2021).',
          ],
        ),
        ReadingSection(
          'Pikiran sulit rileks',
          paragraphs: [
            'Pikiran terus aktif, memikirkan masalah, khawatir tidak dapat tidur, atau takut terhadap akibat kurang tidur. CBT-I membantu mengenali dan mengubah pikiran yang kurang tepat agar tubuh dan pikiran lebih siap beristirahat (Edinger et al., 2021; Riemann et al., 2023).',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-impacts',
      title: '10. Dampak Gangguan Tidur pada Lansia',
      summary: 'Gangguan tidur dapat memengaruhi kesehatan dan kegiatan sehari-hari.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 10.',
      sections: [
        ReadingSection(
          'Dampak yang perlu diperhatikan',
          paragraphs: [
            'Gangguan tidur pada lansia berhubungan dengan berbagai akibat terhadap kesehatan dan fungsi. Gangguan tidur perlu dipandang sebagai kondisi geriatri yang dapat dipengaruhi oleh banyak faktor (Miner & Kryger, 2020).',
          ],
          points: [
            'Dampak fisik: berkaitan dengan penurunan fungsi dan masalah kesehatan.',
            'Dampak daya pikir: tidur berhubungan erat dengan fungsi otak dan kegiatan sehari-hari.',
            'Dampak psikologis: gangguan tidur dan masalah psikologis dapat saling memengaruhi.',
            'Dampak fungsi dan kualitas hidup: insomnia kronis dapat mengganggu kegiatan sehingga perlu ditangani secara klinis.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/sleep-impacts.png',
              alt: 'Dampak gangguan tidur pada kesehatan, daya pikir, emosi, dan kegiatan lansia.',
              caption: 'Dampak gangguan tidur pada lansia',
            ),
          ],
        ),
      ],
    ),
  ],
);

const cbtGroup = ContentGroup(
  id: 'cbt',
  title: 'Konsep CBT-I',
  asset: 'assets/images/cbt.webp',
  summary: 'Pendekatan terstruktur untuk kebiasaan dan pikiran yang mempertahankan insomnia.',
  articles: [
    Article(
      id: 'cbt-definition',
      title: '1. Pengertian CBT-I',
      summary: 'Mengenal lima komponen utama CBT-I.',
      source: 'Materi Program Aplikasi DISQAM, Konsep CBT-I bagian 1.',
      sections: [
        ReadingSection(
          'Pengertian CBT-I',
          paragraphs: [
            'CBT-I adalah intervensi terstruktur yang mengubah kebiasaan dan pola pikir yang mempertahankan insomnia. Komponennya meliputi sleep hygiene, terapi kognitif, sleep restriction, stimulus control, dan latihan relaksasi (Kutzer et al., 2024; McLaren et al., 2023).',
            'American Academy of Sleep Medicine memberikan rekomendasi kuat terhadap CBT-I multikomponen untuk penanganan insomnia kronis pada orang dewasa (Edinger et al., 2021).',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/cbt-i-components.jpeg',
              alt: 'Lima komponen CBT-I.',
              caption: 'Komponen CBT-I',
            ),
          ],
        ),
      ],
    ),
    Article(
      id: 'cbt-digital',
      title: '2. Pendekatan CBT-I Berbasis Digital',
      summary: 'Media digital membantu mengurangi hambatan waktu dan jarak.',
      source: 'Materi Program Aplikasi DISQAM, Konsep CBT-I bagian 2.',
      sections: [
        ReadingSection(
          'Pendekatan digital',
          paragraphs: [
            'Pendekatan digital dapat meningkatkan akses dan mengurangi hambatan waktu serta jarak. Hoyos et al. (2026) menggunakan dCBT-I enam sesi mingguan sekitar 30 menit, dan 79% peserta menyelesaikan setidaknya empat sesi.',
            'Shimizu et al. (2024) menggambarkan program digital lima minggu yang memasukkan buku harian tidur, relaksasi, latihan napas, imajinasi terbimbing, dan perubahan perilaku tidur. Hal ini menunjukkan bahwa intervensi digital dapat dibuat singkat dan terstruktur.',
          ],
        ),
      ],
    ),
  ],
);

const disqamGroup = ContentGroup(
  id: 'disqam-overview',
  title: 'Konsep DISQAM',
  asset: 'assets/images/program.webp',
  summary: 'Mengenal prinsip, komponen, dan enam sesi Program DISQAM.',
  articles: [
    Article(
      id: 'disqam-definition',
      title: '1. Pengertian DISQAM',
      summary:
          'Program tidur multikomponen untuk lansia dengan penyakit kronis.',
      source: 'Materi Program Aplikasi DISQAM, Program DISQAM bagian 1.',
      sections: [
        ReadingSection(
          'DISQAM',
          paragraphs: [
            'DISQAM adalah program intervensi tidur multikomponen yang mengadaptasi prinsip CBT-I dan dirancang untuk lansia dengan penyakit kronis.',
            'Program ini disebut digital karena menggunakan media sederhana seperti panggilan video, pesan melalui telepon atau WhatsApp, dan aplikasi pencatatan tidur. Dukungan digital tidak menggantikan pendampingan tatap muka oleh fasilitator.',
          ],
          points: [
            'Sederhana dan ramah lansia.',
            'Latihan harian singkat.',
            'Buku harian tidur sebagai dasar umpan balik.',
            'Fleksibel terhadap kondisi fisik dan daya pikir.',
            'Pendamping dilibatkan bila diperlukan.',
            'Keselamatan dan rujukan didahulukan dari target intervensi.',
          ],
        ),
      ],
    ),
    Article(
      id: 'disqam-components',
      title: '2. Komponen DISQAM',
      summary: 'Enam komponen yang saling melengkapi.',
      source: 'Materi Program Aplikasi DISQAM, Program DISQAM bagian 2.',
      sections: [
        ReadingSection(
          'Komponen DISQAM',
          paragraphs: [
            'DISQAM terdiri dari enam komponen: kenali masalah tidur dan kebiasaan tidur sehat, stimulus control, pengaturan waktu tidur, restrukturisasi kognitif, relaksasi, serta buku harian tidur dan pemantauan.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/disqam-components.png',
              alt: 'Enam komponen Program DISQAM.',
              caption: 'Gambar 4.1 · Komponen Program DISQAM',
            ),
          ],
        ),
      ],
    ),
    Article(
      id: 'disqam-sessions',
      title: '3. Sesi Program DISQAM',
      summary: 'Gambaran urutan enam sesi program.',
      source: 'Materi Program Aplikasi DISQAM, Program DISQAM bagian 3.',
      sections: [
        ReadingSection(
          'Enam sesi',
          points: [
            'Sesi I: kenali masalah tidur dan kebiasaan tidur sehat.',
            'Sesi II: stimulus control atau membiasakan tempat tidur untuk tidur.',
            'Sesi III: pengaturan waktu tidur.',
            'Sesi IV: restrukturisasi kognitif atau menata pikiran tentang tidur.',
            'Sesi V: relaksasi.',
            'Sesi VI: buku harian tidur dan pemantauan.',
          ],
        ),
      ],
    ),
  ],
);

const caregiverGroup = ContentGroup(
  id: 'caregiver',
  title: 'Peran Pendamping',
  asset: 'assets/images/caregiver.webp',
  summary: 'Cara mendampingi lansia dengan aman tanpa mengambil alih.',
  articles: [
    Article(
      id: 'caregiver-role',
      title: '1. Peran Pendamping',
      summary: 'Dukungan disesuaikan dengan kebutuhan peserta.',
      source: 'Materi Program Aplikasi DISQAM, Peran Caregiver bagian 1.',
      sections: [
        ReadingSection(
          'Kapan pendamping dibutuhkan?',
          paragraphs: [
            'Sebagian lansia dapat mengikuti program secara mandiri. Pendamping atau keluarga dapat membantu jika ada keterbatasan penglihatan, keterampilan digital, daya ingat, kemampuan berpindah, atau risiko jatuh. Dukungan dapat diberikan langsung, melalui WhatsApp, telepon, atau panggilan video.',
          ],
          points: [
            'Membantu membuka aplikasi tanpa mengambil alih seluruh proses.',
            'Mengingatkan pengisian buku harian secara netral.',
            'Membantu menjaga keamanan saat peserta bangun malam.',
            'Mendukung jadwal bangun yang konsisten.',
            'Membantu menghubungi tenaga kesehatan jika ada tanda bahaya.',
            'Memberikan dukungan tanpa menekan peserta agar harus tidur.',
          ],
        ),
      ],
    ),
    Article(
      id: 'caregiver-communication',
      title: '2. Contoh Komunikasi',
      summary: 'Kalimat yang membantu tanpa menekan peserta.',
      source: 'Materi Program Aplikasi DISQAM, Tabel 4.11.',
      sections: [
        ReadingSection(
          'Contoh komunikasi',
          tables: [caregiverCommunicationTable],
        ),
      ],
    ),
    Article(
      id: 'caregiver-boundaries',
      title: '3. Batas Peran Pendamping',
      summary: 'Keputusan klinis tetap berada pada tenaga kesehatan.',
      source: 'Materi Program Aplikasi DISQAM, Peran Caregiver bagian 3.',
      sections: [
        ReadingSection(
          'Batas peran',
          paragraphs: [
            'Pendamping tidak mengubah obat, menentukan diagnosis, atau memperketat jadwal tidur sendiri. Keputusan klinis tetap berada pada tenaga kesehatan atau tim penelitian.',
          ],
          note: 'Jika ada keluhan yang mengkhawatirkan, hubungi fasilitator atau tenaga kesehatan.',
        ),
      ],
    ),
  ],
);

const appendixGroup = ContentGroup(
  id: 'appendices',
  title: 'Lampiran dan Daftar Pustaka',
  asset: 'assets/images/diary.webp',
  summary: 'Pustaka cepat untuk tabel, lembar latihan, dan rujukan ilmiah.',
  articles: [
    Article(
      id: 'appendix-1',
      title: 'Lampiran 1 · Buku Harian Tidur',
      summary: 'Form catatan tidur selama tujuh hari.',
      source: 'Materi Program Aplikasi DISQAM, Lampiran 1.',
      sections: [
        ReadingSection('Buku Harian Tidur', tables: [sleepDiaryTable]),
      ],
    ),
    Article(
      id: 'appendix-2',
      title: 'Lampiran 2 · Rekap Efisiensi Tidur Mingguan',
      summary: 'Rekap TST, TIB, SE, dan kondisi siang hari.',
      source: 'Materi Program Aplikasi DISQAM, Lampiran 2.',
      sections: [
        ReadingSection(
          'Rekap Efisiensi Tidur Mingguan',
          tables: [weeklyEfficiencyTable],
        ),
      ],
    ),
    Article(
      id: 'appendix-3',
      title: 'Lampiran 3 · Daftar Periksa Sleep Hygiene',
      summary: 'Periksa kebiasaan tidur sehat yang sudah dilakukan.',
      source: 'Materi Program Aplikasi DISQAM, Lampiran 3.',
      sections: [
        ReadingSection(
          'Daftar Periksa Sleep Hygiene',
          tables: [sleepHygieneAppendixTable],
        ),
      ],
    ),
    Article(
      id: 'appendix-4',
      title: 'Lampiran 4 · Lembar Stimulus Control',
      summary: 'Catatan latihan stimulus control selama tujuh hari.',
      source: 'Materi Program Aplikasi DISQAM, Lampiran 4.',
      sections: [
        ReadingSection(
          'Lembar Stimulus Control',
          tables: [stimulusControlAppendixTable],
        ),
      ],
    ),
    Article(
      id: 'appendix-5',
      title: 'Lampiran 5 · Kenali · Periksa · Ganti',
      summary: 'Lembar latihan menata pikiran tentang tidur.',
      source: 'Materi Program Aplikasi DISQAM, Lampiran 5.',
      sections: [
        ReadingSection(
          'Lembar Kenali · Periksa · Ganti',
          tables: [thoughtWorksheetTable],
        ),
      ],
    ),
    Article(
      id: 'bibliography',
      title: 'Daftar Pustaka',
      summary: 'Rujukan ilmiah yang digunakan dalam materi DISQAM.',
      source: 'Materi Program Aplikasi DISQAM, Daftar Pustaka.',
      sections: [
        ReadingSection(
          'Daftar pustaka',
          points: [
            'American Academy of Sleep Medicine. (2023). International classification of sleep disorders (3rd ed., text rev.). American Academy of Sleep Medicine.',
            'Borbély, A. A. (2016). The two-process model of sleep regulation: A reappraisal. Journal of Sleep Research, 25(2), 131–143.',
            'Buysse, D. J., Reynolds, C. F., III, Monk, T. H., Berman, S. R., & Kupfer, D. J. (1989). The Pittsburgh Sleep Quality Index: A new instrument for psychiatric practice and research. Psychiatry Research, 28(2), 193–213.',
            'Carney, C. E., Buysse, D. J., Ancoli-Israel, S., Edinger, J. D., Krystal, A. D., Lichstein, K. L., & Morin, C. M. (2012). The consensus sleep diary: Standardizing prospective sleep self-monitoring. Sleep, 35(2), 287–302.',
            'Edinger, J. D., Arnedt, J. T., Bertisch, S. M., Carney, C. E., Harrington, J. J., Lichstein, K. L., Sateia, M. J., Troxel, W. M., Zhou, E. S., Kazmi, U., Heald, J. L., & Martin, J. L. (2021). Behavioral and psychological treatments for chronic insomnia disorder in adults: An American Academy of Sleep Medicine clinical practice guideline. Journal of Clinical Sleep Medicine, 17(2), 255–262.',
            'Hoyos, C. M., Espinosa, N., Marshall, N. S., LaMonica, H. M., Gordon, C. J., Kyle, S. D., Grunstein, R. R., & Naismith, S. L. (2026). Digital cognitive behavioural therapy for insomnia compared to sleep health education in older adults with mild cognitive impairment and insomnia: A feasibility randomised controlled trial. Journal of Sleep Research, 35, e70317.',
            'Kim, C., Lee, Y., Kang, S.-G., & Lee, S.-H. (2025). Effectiveness of information and communication technology-based cognitive behavioral therapy using the Smart Sleep app on insomnia in older adults: Randomized controlled trial. Journal of Medical Internet Research, 27, e67751.',
            'Kutzer, Y., Whitehead, L., Quigley, E., & Stanley, M. (2024). Changes in sleep effort mediate insomnia severity in older adults following online cognitive behavioural therapy. Psychogeriatrics, 24, 303–311.',
            'Laidlaw, K., Thompson, L. W., Dick-Siskin, L., & Gallagher-Thompson, D. (2003). Cognitive behaviour therapy with older people. John Wiley & Sons.',
            'Li, X., Liu, H., Kuang, M., Li, H., He, W., & Luo, J. (2022). Effectiveness of digital cognitive behavior therapy for the treatment of insomnia: Spillover effects of dCBT. International Journal of Environmental Research and Public Health, 19(15), 9544.',
            'Liu, H.-M., Xue, Y.-J., Tang, K.-W., Shen, H.-L., Huang, Y., Deng, W.-Y., Qian, L., & Jin, X.-Q. (2025). Association between sleep duration and frailty in older adults: Systematic review and meta-analysis of observational studies. Archives of Gerontology and Geriatrics, 137, 105949.',
            'Mander, B. A., Winer, J. R., & Walker, M. P. (2017). Sleep and human aging. Neuron, 94(1), 19–36.',
            'McLaren, D. M., Evans, J., Baylan, S., Smith, S., & Gardani, M. (2023). The effectiveness of the behavioural components of cognitive behavioural therapy for insomnia in older adults: A systematic review. Journal of Sleep Research, 32, e13843.',
            'Miner, B., & Kryger, M. H. (2020). Sleep in the aging population. Sleep Medicine Clinics, 15(2), 311–318.',
            'Morin, C. M., & Benca, R. (2012). Chronic insomnia. The Lancet, 379(9821), 1129–1141.',
            'Morin, C. M., Drake, C. L., Harvey, A. G., Krystal, A. D., Manber, R., Riemann, D., & Spiegelhalder, K. (2015). Insomnia disorder. Nature Reviews Disease Primers, 1, 15026.',
            'Patel, A. K., Reddy, V., Shumway, K. R., & Araujo, J. F. (2024). Physiology, sleep stages. In StatPearls. StatPearls Publishing.',
            'Peever, J., & Fuller, P. M. (2017). The biology of REM sleep. Current Biology, 27(22), R1237–R1248.',
            'Qaseem, A., Kansagara, D., Forciea, M. A., Cooke, M., & Denberg, T. D. (2016). Management of chronic insomnia disorder in adults: A clinical practice guideline from the American College of Physicians. Annals of Internal Medicine, 165(2), 125–133.',
            'Riemann, D., Espie, C. A., Altena, E., et al. (2023). The European Insomnia Guideline: An update on the diagnosis and treatment of insomnia 2023. Journal of Sleep Research, 32(6), e14035.',
            'Shimizu, E., Sato, D., Hirano, Y., Ebisu, H., Kagayama, Y., & Hanaoka, H. (2024). Digital cognitive-behavioural therapy application compared with zolpidem for the treatment of insomnia: Protocol for an exploratory randomised controlled trial. BMJ Open, 14, e081205.',
            'Souza, Â. M. N., Fernandes, D. P. S., Castro, I. S., Gróla, F. G., & Ribeiro, A. Q. (2025). Sleep quality and duration and frailty in older adults: A systematic review. Frontiers in Public Health, 13, 1539849.',
            'Spielman, A. J., Saskin, P., & Thorpy, M. J. (1987). Treatment of chronic insomnia by restriction of time in bed. Sleep, 10(1), 45–56.',
            'Thakral, M., Von Korff, M., McCurry, S. M., Morin, C. M., & Vitiello, M. V. (2020). Changes in dysfunctional beliefs about sleep after cognitive behavioral therapy for insomnia: A systematic literature review and meta-analysis. Sleep Medicine Reviews, 49, 101230.',
            'Walker, J., Muench, A., Perlis, M. L., & Vargas, I. (2022). Cognitive behavioral therapy for insomnia (CBT-I): A primer. Clinical Psychology and Special Education, 11(2), 123–137.',
          ],
          links: [
            ReadingLink(
              label: 'Buka Borbély (2016)',
              url: 'https://doi.org/10.1111/jsr.12371',
            ),
            ReadingLink(
              label: 'Buka Buysse et al. (1989)',
              url: 'https://doi.org/10.1016/0165-1781(89)90047-4',
            ),
            ReadingLink(
              label: 'Buka Carney et al. (2012)',
              url: 'https://doi.org/10.5665/sleep.1642',
            ),
            ReadingLink(
              label: 'Buka Edinger et al. (2021)',
              url: 'https://doi.org/10.5664/jcsm.8986',
            ),
            ReadingLink(
              label: 'Buka Hoyos et al. (2026)',
              url: 'https://doi.org/10.1111/jsr.70317',
            ),
            ReadingLink(
              label: 'Buka Kim et al. (2025)',
              url: 'https://doi.org/10.2196/67751',
            ),
            ReadingLink(
              label: 'Buka Kutzer et al. (2024)',
              url: 'https://doi.org/10.1111/psyg.13074',
            ),
            ReadingLink(
              label: 'Buka Laidlaw et al. (2003)',
              url: 'https://doi.org/10.1002/9780470713402',
            ),
            ReadingLink(
              label: 'Buka Li et al. (2022)',
              url: 'https://doi.org/10.3390/ijerph19159544',
            ),
            ReadingLink(
              label: 'Buka Liu et al. (2025)',
              url: 'https://doi.org/10.1016/j.archger.2025.105949',
            ),
            ReadingLink(
              label: 'Buka Mander et al. (2017)',
              url: 'https://doi.org/10.1016/j.neuron.2017.02.004',
            ),
            ReadingLink(
              label: 'Buka McLaren et al. (2023)',
              url: 'https://doi.org/10.1111/jsr.13843',
            ),
            ReadingLink(
              label: 'Buka Miner & Kryger (2020)',
              url: 'https://doi.org/10.1016/j.jsmc.2020.02.016',
            ),
            ReadingLink(
              label: 'Buka Morin & Benca (2012)',
              url: 'https://doi.org/10.1016/S0140-6736(11)60750-2',
            ),
            ReadingLink(
              label: 'Buka Morin et al. (2015)',
              url: 'https://doi.org/10.1038/nrdp.2015.26',
            ),
            ReadingLink(
              label: 'Buka Peever & Fuller (2017)',
              url: 'https://doi.org/10.1016/j.cub.2017.10.026',
            ),
            ReadingLink(
              label: 'Buka Qaseem et al. (2016)',
              url: 'https://doi.org/10.7326/M15-2175',
            ),
            ReadingLink(
              label: 'Buka Riemann et al. (2023)',
              url: 'https://doi.org/10.1111/jsr.14035',
            ),
            ReadingLink(
              label: 'Buka Shimizu et al. (2024)',
              url: 'https://doi.org/10.1136/bmjopen-2023-081205',
            ),
            ReadingLink(
              label: 'Buka Souza et al. (2025)',
              url: 'https://doi.org/10.3389/fpubh.2025.1539849',
            ),
            ReadingLink(
              label: 'Buka Spielman et al. (1987)',
              url: 'https://doi.org/10.1093/sleep/10.1.45',
            ),
            ReadingLink(
              label: 'Buka Thakral et al. (2020)',
              url: 'https://doi.org/10.1016/j.smrv.2019.101230',
            ),
          ],
        ),
      ],
    ),
  ],
);

const contentGroups = [
  sleepGroup,
  cbtGroup,
  disqamGroup,
  programGroup,
  caregiverGroup,
  appendixGroup,
];

Article? findArticle(String? id) {
  for (final group in contentGroups) {
    for (final article in group.articles) {
      if (article.id == id) return article;
    }
  }
  return null;
}
