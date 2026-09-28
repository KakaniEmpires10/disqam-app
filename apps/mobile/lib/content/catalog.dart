import 'models.dart';
import 'program.dart';

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

const sleepGroup = ContentGroup(
  id: 'sleep',
  title: 'Konsep Tidur',
  asset: 'assets/images/sleep.webp',
  singleSectionIconAsset: 'assets/images/icons/sleep-concept.webp',
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
            'Tidur merupakan keadaan kesehatan tubuh yang ditandai dengan perubahan tingkat kesadaran, aktivitas otak, reaksi tubuh terhadap gangguan dari lingkungan sekitar (rangsangan eksternal), dan berbagai fungsi tubuh (fisiologis). Tidur bukan hanya keadaan saat tubuh berhenti beraktivitas. Ketika tidur, tubuh dan otak tetap bekerja untuk memulihkan tenaga, memperbaiki sel-sel tubuh, dan menjaga kesehatan (Miner & Kryger, 2020).',
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
          'Fungsi Tidur',
          paragraphs: [
            'Tidur mempunyai hubungan erat dengan berbagai fungsi biologis dan psikologis. Dalam konteks kesehatan lansia, tidur yang baik mendukung pemeliharaan fungsi fisik, kognitif, dan emosional, sedangkan gangguan tidur dapat berhubungan dengan berbagai masalah kesehatan dan penurunan fungsi (Miner & Kryger, 2020).',
            'Secara konseptual, fungsi tidur dapat dipahami melalui beberapa aspek:',
          ],
          points: [
            '**Pemulihan fisiologis**, yaitu mendukung proses pemulihan tubuh.',
            '**Pemeliharaan fungsi otak**, termasuk proses yang berkaitan dengan pembelajaran dan memori.',
            '**Regulasi emosi **(mengelola perasaan dan menjaga suasana hati tetap stabil)**,** sehingga tidur yang terganggu dapat berkaitan dengan perubahan mood atau suasana hati.',
            '**Pemeliharaan fungsi fisik**, termasuk kemampuan melakukan aktivitas sehari-hari, dan',
            '**Pemeliharaan kesehatan secara keseluruhan** (Miner & Kryger, 2020).',
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
          'Siklus Tidur',
          paragraphs: [
            'Tidur merupakan proses aktif yang diatur oleh otak. Saat tidur, tubuh tidak berada dalam satu keadaan yang sama sepanjang malam, tetapi melewati beberapa tahap dengan tingkat kedalaman dan aktivitas otak yang berbeda. Tahap-tahap tersebut tersusun dalam pola yang disebut struktur tidur atau sleep architecture. Secara umum, tidur terbagi menjadi:',
          ],
          points: [
            'Tidur NREM (non-rapid eye movement), terdiri atas tahap N1, N2, dan N3.',
            'Tidur REM (rapid eye movement), yaitu tahap yang ditandai dengan gerakan mata cepat, aktivitas otak meningkat, dan otot tubuh sangat rileks.',
          ],
          afterPoints: [
            'Pergantian dari tidur NREM menuju REM dan kembali lagi disebut siklus tidur. Tubuh biasanya melewati sekitar 4 sampai 6 siklus dalam satu malam. Setiap siklus berlangsung kurang lebih 90 menit sampai dengan 110 menit, tetapi durasinya dapat berbeda pada setiap orang dan setiap siklus (Patel et al, 2024).',
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
      openingParagraphs: [
        'Tidur diatur oleh dua proses utama yang dikenal sebagai teori two-process model of sleep regulation, antara lain:',
      ],
      sections: [
        ReadingSection(
          'Dorongan tidur',
          paragraphs: [
            'Dorongan tidur meningkat selama seseorang terjaga. Semakin lama seseorang tidak tidur, semakin besar kebutuhan tubuh untuk tidur. Setelah tidur dimulai, dorongan tersebut berkurang secara bertahap.',
            'Sebagai contoh, seseorang yang aktif sejak pagi biasanya mulai mengantuk pada malam hari. Namun, apabila ia tidur siang terlalu lama, sebagian dorongan tidurnya telah berkurang sehingga lebih sulit mengantuk pada malam hari.',
          ],
        ),
        ReadingSection(
          'Jam alami tubuh',
          paragraphs: [
            'Jam alami tidur merupakan jam alami tubuh yang mengatur waktu tidur dan bangun dalam pola sekitar 24 jam. Sistem ini dipengaruhi oleh cahaya dan kegelapan, waktu beraktivitas, jadwal makan, kebiasaan tidur dan bangun, interaksi sosial. pelepasan hormon, termasuk melatonin.',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-stages',
      title: '5. Tahap-Tahap Tidur',
      summary: 'Kenali tahap N1, N2, N3, dan REM.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 5.',
      openingParagraphs: [
        'Tidur dilalui oleh beberapa tahap, untuk setiap tahap akan dijelaskan dibawah ini dengan rinci',
      ],
      sections: [
        ReadingSection(
          'Tahap N1 (Mulai tertidur)',
          paragraphs: [
            'N1 merupakan tahap peralihan dari keadaan terjaga menuju tidur. Tahap ini adalah tahap tidur yang paling ringan dan biasanya berlangsung singkat. Pada tahap N1 mata mulai terpejam, gerakan mata menjadi lamba, otot mulai mengendur, denyut jantung dan pernapasan mulai melambat, respons terhadap suara dan keadaan sekitar mulai berkurang, dan seseorang masih mudah dibangunkan.',
            'Pada tahap ini sebagian orang dapat merasakan sensasi seperti jatuh atau mengalami sentakan kaki secara tiba-tiba ketika mulai tertidur, kondisi ini umumnya normal. Jika dibangunkan pada tahap N1 seseorang mungkin merasa bahwa dirinya belum benar-benar tidur. Dalam pemeriksaan aktivitas otak, tahap N1 ditandai dengan berkurangnya gelombang alfa saat terjaga dan munculnya gelombang teta. Tahap ini umumnya hanya menempati sebagian kecil dari keseluruhan waktu tidur.',
          ],
        ),
        ReadingSection(
          'Tahap N2 (tidur semakin stabil)',
          paragraphs: [
            'Setelah melewati N1, seseorang masuk ke tahap N2. Pada tahap ini, tidur menjadi lebih stabil dan seseorang tidak semudah pada tahap N1 untuk dibangunkan. Perubahan tubuh pada tahap N2 meliputi denyut jantung melambat, pernapasan menjadi lebih teratur, suhu tubuh menurun, otot semakin rileks, gerakan mata berhenti, dan kesadaran terhadap lingkungan semakin berkurang.',
            'Aktivitas otak pada tahap N2 ditandai oleh kumparan tidur (sleep spindles) dan kompleks-K (K-complexes). Kumparan tidur merupakan aktivitas singkat yang membantu mempertahankan tidur dan diduga berperan dalam proses pembelajaran serta penyimpanan ingatan. Sedangn kompleks-K membantu otak merespons rangsangan dari lingkungan tanpa harus selalu membuat seseorang terbangun. Tahap N2 merupakan tahap yang paling banyak ditemui selama tidur malam dan biasanya semakin panjang pada siklus-siklus berikutnya (Patel et al., 2024).',
          ],
        ),
        ReadingSection(
          'Tahap N3 (tidur dalam)',
          paragraphs: [
            'Tahap N3 merupakan tahap tidur paling dalam dan sering disebut sebagai tidur gelombang lambat atau slow-wave sleep. Pada tahap ini, aktivitas otak didominasi oleh gelombang delta yang bergerak lambat. Pada tahap N3 denyut jantung dan pernapasan berada pada tingkat yang lebih lambat dan stabil, otot sangat rileks, tubuh lebih sulit dibangunkan, pemulihan fisik berlangsung lebih kuat, dan perbaikan jaringan,  pemulihan energi didukung, sistem kekebalan tubuh dan pengaturan hormon mendapat dukungan, pengolahan dan penguatan ingatan tertentu berlangsung.',
            'Apabila seseorang dibangunkan secara tiba-tiba pada tahap N3, ia dapat merasa bingung, lemas, atau belum sepenuhnya sadar selama beberapa saat. Keadaan ini disebut kebingungan sesaat setelah bangun atau sleep inertia.',
            'Berjalan sambil tidur, teror malam, dan berbicara tanpa sadar dapat muncul dari tidur NREM dalam, terutama tahap N3. Tahap ini lebih banyak terjadi pada sepertiga awal malam dan semakin berkurang menjelang pagi  (Mander et al., 2017).',
          ],
        ),
        ReadingSection(
          'Tahap REM (aktivitas otak meningkat)',
          paragraphs: [
            'REM adalah singkatan dari Rapid Eye Movement atau gerakan mata cepat. Pada tahap ini, aktivitas otak meningkat dan mendekati aktivitas ketika seseorang terjaga, tetapi sebagian besar otot tubuh mengalami penurunan kekuatan untuk bergerak.',
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
      title: '6. Perubahan Tidur Pada Lansia',
      summary: 'Pola tidur dapat berubah seiring usia, tetapi gangguan menetap perlu dinilai.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 6.',
      openingParagraphs: [
        'Bertambahnya usia atau terjadinya proses penuaan dapat menyebabkan perubahan pada struktur tidur. Lansia secara umum cenderung mengalami beberapa perubahan tidur dibandingkan dengan orang dewasa yang lebih muda. Perubahan tersebut, diantaranya adalah:',
      ],
      sections: [
        ReadingSection(
          'Tidur lebih ringan',
          paragraphs: [
            'Lansia lebih banyak berada pada tahap N1 dan N2 serta mengalami pengurangan tahap N3. Akibatnya, lansia menjadi lebih mudah terbangun oleh suara, cahaya, nyeri, suhu kamar, atau keinginan buang air kecil.',
          ],
        ),
        ReadingSection(
          'Tidur lebih sering terputus',
          paragraphs: [
            'Kemampuan mempertahankan tidur dapat berkurang. Lansia mungkin lebih sering terbangun dan memiliki waktu terjaga yang lebih panjang setelah mulai tidur.',
          ],
        ),
        ReadingSection(
          'Tidur dalam berkurang',
          paragraphs: [
            'Penurunan tidur N3 merupakan salah satu perubahan yang paling konsisten ditemukan seiring bertambahnya usia. Perubahan ini dapat membuat tidur terasa kurang nyenyak, walaupun lama berada di tempat tidur cukup panjang.',
          ],
        ),
        ReadingSection(
          'Perubahan waktu tidur dan bangun',
          paragraphs: [
            'Jam alami tubuh lansia dapat bergeser lebih awal. Lansia mungkin mengantuk lebih awal pada sore atau malam hari dan terbangun lebih awal pada pagi hari.',
          ],
        ),
        ReadingSection(
          'REM dapat mengalami perubahan',
          paragraphs: [
            'Proporsi REM cenderung mengalami sedikit penurunan sepanjang masa dewasa, tetapi perubahan tersebut tidak selalu besar pada semua lansia. Penyakit, obat-obatan, gangguan pernapasan, depresi, dan kebiasaan tidur dapat lebih memengaruhi REM dibandingkan usia saja.',
          ],
        ),
        ReadingSection(
          'Efisiensi tidur menurun',
          paragraphs: [
            'Lansia dapat menghabiskan waktu cukup lama di tempat tidur, tetapi tidak seluruh waktu tersebut digunakan untuk tidur. Hal ini menyebabkan efisiensi tidur menjadi lebih rendah. Penelitian menunjukkan bahwa peningkatan tidur ringan, penurunan tidur dalam, dan lebih sering terbangun merupakan perubahan yang sering ditemukan dalam proses penuaan. Namun, besarnya perubahan berbeda pada setiap individu dan sebagian perubahan mulai relatif stabil setelah usia 60 tahun (Li et al., 2022).',
          ],
        ),
      ],
      closingParagraphs: [
        'Keluhan tidur pada lansia juga dapat dipengaruhi oleh nyeri kronis, sesak napas, penyakit jantung atau paru-paru, diabetes mellitus, sering buang air kecil pada malam hari, kecemasan atau depresi, kurangnya aktivitas pada siang hari, tidur siang terlalu lama, obat-obatan tertentu, apnea tidur obstruktif, sindrom kaki gelisah, dan lingkungan tidur yang tidak nyaman.',
      ],
    ),
    Article(
      id: 'sleep-disorders',
      title: '7. Gangguan Tidur Pada Lansia',
      summary:
          'Mengenali insomnia dan gangguan tidur lain yang perlu diperiksa.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 7.',
      openingParagraphs: [
        'Gangguan tidur adalah berbagai kondisi yang menyebabkan seseorang sulit mendapatkan tidur yang cukup dan nyenyak. beberapa gangguan tidur yang perlu diperhatikan lebih lanjut saat menilai kondisi tidur lansia, antara lain:',
      ],
      sections: [
        ReadingSection(
          'Insomnia disorders',
          paragraphs: [
            'Insomnia didefinisikan sebagai keluhan tidur yang tidak mencukupi dan tidak memberikan rasa segar setelah bangun, yang berlangsung setidaknya selama satu bulan serta mengganggu fungsi pekerjaan atau sosial. Untuk menegakkan diagnosis insomnia, perlu dipastikan bahwa keluhan tersebut bukan disebabkan oleh gangguan tidur lain, misalnya apnea tidur, atau gangguan otot, misalnya sindrom kaki gelisah atau gangguan gerakan anggota tubuh berkala',
            'Insomnia dapat muncul dalam tiga bentuk:',
          ],
          points: [
            'Insomnia awal tidur (sleep onset insomnia), yaitu kesulitan untuk mulai tertidur.',
            'Insomnia mempertahankan tidur (sleep maintenance insomnia), yaitu sering terbangun pada malam hari atau bangun lebih pagi daripada yang diinginkan, disertai kesulitan untuk tidur kembali.',
            'Insomnia tipe campuran (mixed type insomnia), yaitu mengalami kesulitan untuk mulai tertidur sekaligus mempertahankan tidur.',
          ],
          afterPoints: [
            'Selain itu, insomnia dibedakan menjadi insomnia primer dan insomnia sekunder. Insomnia primer terjadi ketika kurangnya tidur tidak disertai kondisi medis lain, gangguan kejiwaan, atau penggunaan zat. Sedangkan insomnia sekunder terjadi ketika gangguan tidur berkaitan dengan kondisi-kondisi lain yang telah disebutkan di atas.',
          ],
        ),
        ReadingSection(
          'Sleep-Related Breathing Disorders',
          paragraphs: [
            'Kelompok ini mencakup gangguan pernapasan selama tidur, termasuk obstructive sleep apnea yaitu  gangguan tidur ketika saluran pernapasan menyempit atau tertutup sementara sehingga napas berhenti berulang kali selama tidur. Kecurigaan terhadap gangguan ini perlu diperhatikan apabila terdapat gejala seperti mendengkur keras, kejadian berhenti napas sesaat yang diamati orang lain, terbangun dengan sensasi tersedak, atau kantuk berlebihan pada siang hari (AASM, 2023).',
          ],
        ),
        ReadingSection(
          'Circadian Rhythm Sleep-Wake Disorders',
          paragraphs: [
            'Gangguan ini terjadi ketika pola tidur dan bangun tidak selaras dengan jadwal alami tubuh atau tuntutan lingkungan. Perubahan jam alami tidur seseorang juga merupakan salah satu perubahan tidur yang dapat ditemukan pada proses penuaan (Miner & Kryger, 2020; AASM, 2023).',
          ],
        ),
        ReadingSection(
          'Parasomnias',
          paragraphs: [
            'Parasomnia mencakup kejadian atau perilaku yang tidak diharapkan selama tidur atau peralihan antara keadaan tidur dan terbangun (AASM, 2023).',
          ],
        ),
        ReadingSection(
          'Sleep-Related Movement Disorders',
          paragraphs: [
            'Kelompok ini mencakup gangguan gerakan yang berhubungan dengan tidur, termasuk restless legs syndrome atau sindrom kaki gelisah yaitu suatu kondisi ketika kaki terasa tidak nyaman dan muncul dorongan kuat untuk terus menggerakkannya, terutama saat sedang duduk, berbaring, atau menjelang tidur.',
            'Keluhannya dapat berupa rasa kesemutan, tertusuk, merayap, gatal, atau pegal pada kaki. Rasa tidak nyaman biasanya berkurang setelah kaki digerakkan atau digunakan untuk berjalan . Kondisi tersebut dapat mengganggu proses memulai dan mempertahankan tidur (AASM, 2023).',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-factors',
      title: '8. Faktor Penyebab Gangguan Tidur pada Lansia',
      summary:
          'Tubuh, pikiran, kebiasaan, lingkungan, dan obat saling memengaruhi.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 8.',
      sections: [
        ReadingSection(
          'Faktor Biologis',
          paragraphs: [
            'Masalah tidur pada lansia biasanya tidak hanya disebabkan oleh satu hal. Seiring bertambahnya usia, tidur dapat menjadi lebih ringan, lebih mudah terbangun, serta waktu tidur dan bangun dapat berubah. Penyakit menahun, rasa nyeri, sesak napas, dan masalah kesehatan lainnya juga dapat membuat tidur lansia semakin terganggu (Miner & Kryger, 2020).',
          ],
        ),
        ReadingSection(
          'Faktor Psikologis',
          paragraphs: [
            'Faktor psikososial (kondisi pikiran, perasaan, dan hubungan sosial) juga dapat memengaruhi gangguan tidur pada lansia.',
            'Contohnya, rasa kesepian, stres, kekhawatiran atau kecemasan, kehilangan orang terdekat, kurangnya dukungan keluarga, serta kondisi psikososial lainnya dapat membuat lansia sulit tidur atau sering terbangun pada malam hari (Miner & Kryger, 2020; Riemann et al., 2023).',
          ],
        ),
        ReadingSection(
          'Faktor Perilaku',
          paragraphs: [
            'Perilaku tertentu dapat mempertahankan masalah tidur, seperti waktu tidur yang tidak teratur, terlalu lama berada di tempat tidur ketika tidak tidur, tidur siang yang tidak sesuai, atau menggunakan tempat tidur untuk aktivitas selain tidur.',
          ],
        ),
        ReadingSection(
          'Faktor Lingkungan',
          paragraphs: [
            'Lingkungan tidur juga perlu diperhatikan karena kualitas tidur dapat dipengaruhi oleh kondisi yang dapat mengganggu tidur untuk lebih nyenyak dan tidak sering terbangun pada malam hari.',
          ],
        ),
        ReadingSection(
          'Faktor Obat dan Polifarmasi',
          paragraphs: [
            'Mengkonsumsi banyak jenis obat secara bersamaan atau disebut dengan istilah polifarmasi. Polifarmasi merupakan salah satu faktor yang perlu diperhatikan pada lansia dengan gangguan tidur.',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-mechanisms',
      title: '9. Mekanisme Gangguan Tidur Pada Lansia',
      summary: 'Tubuh atau pikiran dapat tetap terlalu aktif menjelang tidur.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 9.',
      openingParagraphs: [
        'Mekanisme gangguan tidur pada lansia dapat dibagi menjadi dua, yaitu:',
      ],
      sections: [
        ReadingSection(
          'Tubuh sulit tenang (arousal fisiologis)',
          paragraphs: [
            'Kondisi ini terjadi ketika tubuh masih tegang atau terlalu aktif menjelang tidur sehingga lansia sulit merasa rileks. Tanda-tandanya dapat berupa jantung berdebar, napas terasa cepat, otot tegang, gelisah, atau tubuh sulit merasa nyaman. Latihan relaksasi dapat membantu menenangkan tubuh dan mempersiapkannya untuk tidur (Edinger et al., 2021).',
          ],
        ),
        ReadingSection(
          'Pikiran sulit tenang (arousal kognitif)',
          paragraphs: [
            'Kondisi ini terjadi ketika pikiran terus aktif menjelang tidur. Lansia mungkin terus memikirkan masalah, merasa khawatir tidak dapat tidur, atau takut terhadap akibat kurang tidur. Dalam CBT-I, lansia dibantu untuk mengenali dan mengubah pikiran yang kurang tepat mengenai tidur agar pikiran menjadi lebih tenang dan tidur lebih mudah (Edinger et al., 2021; Riemann et al., 2023).',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-impacts',
      title: '10. Dampak Gangguan Tidur Pada Lansia',
      summary: 'Gangguan tidur dapat memengaruhi kesehatan dan kegiatan sehari-hari.',
      source: 'Materi Program Aplikasi DISQAM, Konsep Tidur bagian 10.',
      openingParagraphs: [
        'Gangguan tidur pada lansia berhubungan dengan berbagai konsekuensi terhadap kesehatan dan fungsi. Miner dan Kryger (2020) menyebutkan bahwa gangguan tidur pada lansia berhubungan dengan morbiditas dan mortalitas serta perlu dipandang sebagai kondisi geriatri multifaktorial. Dampak yang perlu diperhatikan meliputi:',
      ],
      sections: [
        ReadingSection(
          'Dampak fisik',
          paragraphs: [
            'Gangguan tidur dapat berkaitan dengan penurunan fungsi dan masalah kesehatan pada lansia (Miner & Kryger, 2020).',
          ],
        ),
        ReadingSection(
          'Dampak kognitif',
          paragraphs: [
            'Tidur memiliki hubungan erat dengan fungsi otak sehingga gangguan tidur perlu diperhatikan dalam pengkajian lansia yang mengalami masalah kognitif atau fungsi sehari-hari (Miner & Kryger, 2020).',
          ],
        ),
        ReadingSection(
          'Dampak psikologis',
          paragraphs: [
            'Gangguan tidur dan masalah psikologis dapat saling memengaruhi. Karena itu, evaluasi insomnia perlu mencakup kondisi psikologis dan komorbiditas yang mungkin berhubungan dengan gangguan tidur (Riemann et al., 2023).',
          ],
        ),
        ReadingSection(
          'Dampak fungsi dan kualitas hidup',
          paragraphs: [
            'Insomnia kronis dapat menyebabkan gangguan fungsi dan merupakan salah satu alasan penting mengapa insomnia perlu ditangani secara klinis (Edinger et al., 2021; Riemann et al., 2023).',
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
  singleSectionIconAsset: 'assets/images/icons/cbt-concept.webp',
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
            'CBT-I merupakan intervensi terstruktur yang mengubah kebiasaan dan pola pikir yang mempertahankan insomnia. Kutzer et al. (2024) merangkum komponen CBT-I sebagai sleep hygiene, cognitive therapy, sleep restriction, stimulus control, dan relaxation training. McLaren et al. (2023) juga menempatkan komponen tersebut sebagai inti pendekatan CBT-I.',
            'CBT-I merupakan intervensi psikologis dan perilaku yang dirancang khusus untuk insomnia. American Academy of Sleep Medicine (AASM) memberikan rekomendasi kuat terhadap CBT-I multikomponen (Sleep Hygiene, Stimulus Control, Sleep Restriction Therapy, Cognitive Therapy/Cognitive Restructuring, Relaxation Therapy)  untuk penanganan chronic insomnia disorder pada orang dewasa (Edinger et al., 2021).',
            'Secara umum berikut komponen CBT-I yang dapat digambarkan pada skema dibawah ini',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/cbt-i-components.jpeg',
              alt: 'Lima komponen CBT-I.',
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
          'Pendekatan CBT-I Berbasis Digital',
          paragraphs: [
            'Pendekatan digital dapat meningkatkan akses dan mengurangi hambatan waktu serta jarak. Kim et al. (2025). Hoyos et al. (2026) menggunakan dCBT-I enam sesi mingguan, masing-masing sekitar 30 menit, melalui platform digital dengan dukungan otomatis dan kontak pada minggu tertentu. Sebanyak 79% peserta menyelesaikan setidaknya empat sesi.',
            'Shimizu et al. (2024) juga menggambarkan program dCBT lima minggu yang memasukkan sleep diary, relaksasi, breathing exercise, guided imagery, dan perubahan perilaku tidur. Hal ini memperlihatkan bahwa intervensi digital dapat dirancang dengan durasi yang relatif singkat dan komponen terstruktur.',
          ],
        ),
      ],
    ),
    Article(
      id: 'cbt-disqam-adaptation',
      title: '3. Adaptasi CBT-I pada Program DISQAM Untuk Lansia',
      summary:
          'Penyesuaian CBT-I agar aman dan sesuai dengan kebutuhan lansia.',
      source: 'Materi Program Aplikasi DISQAM, Konsep CBT-I bagian 3.',
      openingParagraphs: [
        'CBT-I merupakan standar yang dirancang untuk populasi dewasa umum dan biasanya melibatkan pembatasan waktu di tempat tidur yang cukup ketat (McLaren et al., 2023; Kim et al., 2025). Pada lansia dengan penyakit kronis dan risiko frailty, beberapa penyesuaian penting dilakukan dalam program DISQAM:',
      ],
      sections: [
        ReadingSection(
          'Adaptasi CBT-I pada Program DISQAM Untuk Lansia',
          points: [
            'Pembatasan tidur dilakukan lebih bertahap dan tidak boleh mengurangi total waktu tidur di bawah batas aman (umumnya tidak kurang dari 5 sampai dengan 5,5 jam), untuk menghindari kelelahan berlebihan dan risiko jatuh.',
            'Sesi program DISQAM dibuat lebih singkat dan lebih sedikit dibandingkan CBT-I standar, dengan pengulangan materi yang lebih banyak.',
            'Bahasa dan materi visual dibuat sederhana, dengan font besar dan ilustrasi bila memungkinkan.',
            'Keterlibatan keluarga dan pendamping didorong untuk membantu pemantauan dan pengingat jadwal.',
            'Pemantauan gejala fisik (pusing, mengantuk berlebihan di siang hari, nyeri) dilakukan lebih ketat di setiap sesi.',
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
  singleSectionIconAsset: 'assets/images/icons/disqam-concept.webp',
  summary: 'Mengenal prinsip, komponen, dan enam sesi Program DISQAM.',
  articles: [
    Article(
      id: 'disqam-definition',
      title: '1. DISQAM',
      summary:
          'Program tidur multikomponen untuk lansia dengan penyakit kronis.',
      source: 'Materi Program Aplikasi DISQAM, Program DISQAM bagian 1.',
      sections: [
        ReadingSection(
          'DISQAM (Program Digital Improving Sleep Quality for Aging Management)',
          paragraphs: [
            'DISQAM adalah program intervensi tidur multi-komponen yang mengadaptasi prinsip CBT-I, dirancang khusus untuk lansia dengan penyakit kronis.',
            'Program ini disebut "digital" karena memanfaatkan media sederhana seperti panggilan video, pesan pengingat melalui telepon genggam/WhatsApp, atau aplikasi pencatatan tidur untuk mendukung pemantauan dan keberlangsungan program, tanpa menggantikan pendampingan tatap muka oleh fasilitator.',
            'Adapun prinsip Program DISQAM adalah:',
          ],
          points: [
            'Sederhana dan ramah lansia',
            'Latihan harian singkat',
            'Sleep diary sebagai dasar feedback',
            'Fleksibel terhadap kondisi fisik dan kognitif',
            'Caregiver dilibatkan bila diperlukan',
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
            'Komponen DISQAM terdiri dari 6 (enam) sesi, diantaranya kenali masalah tidur dan sleep hygiene: kebiasaan tidur sehat, stimulus kontrol: kebiasaan tidur yang baik,  pengaturan waktu tidur, restrukturisasi kognitif: tenangkan pikiran, relaksasi dan sleep diary: buku harian tidur dan monitoring.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/disqam-components.png',
              alt: 'Enam komponen Program DISQAM.',
              caption: 'Komponen Utama Program DISQAM',
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
      primaryActionArticleId: 'session-1',
      primaryActionLabel: 'Masuk ke Sesi 1',
      sections: [
        ReadingSection(
          'Sesi Program DISQAM',
          points: [
            'Kenali masalah tidur dan sleep hygiene (kebiasaan tidur sehat)',
            'Stimulus kontrol (kebiasaan tidur yang baik)',
            'Pengaturan waktu tidur',
            'Restrukturisasi kognitif (tenangkan pikiran)',
            'Relaksasi',
            'Sleep diary (buku harian tidur) dan monitoring.',
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
  singleSectionIconAsset: 'assets/images/icons/caregiver.webp',
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
            'Sebagian lansia dapat mengikuti program secara mandiri. Namun caregiver (pendamping atau keluarga) dapat membantu bila terdapat keterbatasan penglihatan, keterampilan digital, daya ingat, mobilitas (berpindah), atau risiko jatuh. Pada DISQAM, dukungan keluarga/teman melalui komunikasi langsung atau via WhatsApp, telepon atau video call dimungkinkan untuk memberikan dukungan emosional (Kim et al., 2025).',
            '**Peran yang dianjurkan**',
          ],
          points: [
            'Membantu membuka aplikasi tanpa mengambil alih seluruh proses',
            'Mengingatkan pengisian sleep diary secara netral',
            'Membantu memastikan keamanan saat peserta bangun malam',
            'Mendukung jadwal bangun yang konsisten',
            'Membantu menghubungi tenaga kesehatan bila ada red flags (tanda bahaya).',
            "Memberikan dukungan tanpa menekan peserta agar 'harus tidur'",
          ],
        ),
      ],
    ),
    Article(
      id: 'caregiver-communication',
      title: '2. Contoh komunikasi',
      summary: 'Kalimat yang membantu tanpa menekan peserta.',
      source: 'Materi Program Aplikasi DISQAM, Contoh Komunikasi.',
      sections: [
        ReadingSection(
          'Contoh Komunikasi',
          paragraphs: [
            'Contoh komunikasi yang perlu dihindari dan digunakan dapat dilihat berikut ini:',
          ],
          communicationExamples: [
            CommunicationExample(
              avoid: "'Ayo tidur, harus tidur sekarang.'",
              use:
                  "'Tidak perlu memaksa tidur. Kita buat kondisi lebih nyaman dulu.'",
            ),
            CommunicationExample(
              avoid: "'Kenapa belum tidur juga?'",
              use:
                  "'Kalau belum mengantuk, boleh lakukan aktivitas tenang dulu.'",
            ),
            CommunicationExample(
              avoid: "'Jangan sampai besok sakit karena kurang tidur.'",
              use:
                  "'Kita ikuti rencana dan lihat pola beberapa hari, bukan satu malam saja.'",
            ),
          ],
        ),
      ],
    ),
    Article(
      id: 'caregiver-boundaries',
      title: '3. Batas peran caregiver',
      summary: 'Keputusan klinis tetap berada pada tenaga kesehatan.',
      source: 'Materi Program Aplikasi DISQAM, Batas peran caregiver.',
      sections: [
        ReadingSection(
          'Batas peran caregiver',
          paragraphs: [
            '“Caregiver tidak mengubah obat, menentukan diagnosis, atau memperketat jadwal tidur sendiri. Keputusan klinis tetap berada pada tenaga kesehatan/tim penelitian”.',
          ],
        ),
      ],
    ),
  ],
);

const appendixGroup = ContentGroup(
  id: 'appendices',
  title: 'Lampiran dan Daftar Pustaka',
  asset: 'assets/images/diary.webp',
  singleSectionIconAsset: 'assets/images/icons/appendices.webp',
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

const conclusionGroup = ContentGroup(
  id: 'conclusion',
  title: 'Penutup',
  asset: 'assets/images/sleep.webp',
  singleSectionIconAsset: 'assets/images/icons/conclusion.webp',
  summary: 'Penutup materi DISQAM dan harapan untuk kualitas tidur lansia.',
  articles: [
    Article(
      id: 'conclusion',
      title: 'Penutup',
      summary: 'Merangkum peran DISQAM bagi lansia dengan penyakit kronis.',
      source: 'Materi Program Aplikasi DISQAM, Bab VI Penutup.',
      sections: [
        ReadingSection(
          'Penutup',
          paragraphs: [
            'Keluhan tidur yang kurang baik sering ditemukan dalam pelayanan kepada lansia. Meskipun kurangnya tidur pada usia lanjut dapat disebabkan oleh berbagai faktor. Terapi kognitif dan perilaku telah menjadi pilihan intervensi lini pertama, terlepas dari jenis kesulitan tidur yang dialami.',
            'Namun, tenaga kesehatan sering menghadapi tantangan ketika pasien yang merasa sangat tidak nyaman akibat tidur yang buruk meminta obat sebagai pilihan pertama karena dianggap memberikan hasil paling cepat.',
            'Dalam situasi ini, tenaga kesehatan perlu memberikan edukasi yang kuat serta penjelasan yang jelas mengenai alasan dan manfaat terapi DISQAM. Hal ini bertujuan mendorong pasien untuk bersedia mempelajari kebiasaan tidur dan cara pandang baru mengenai tidur yang jauh lebih bermanfaat dalam jangka panjang',
            'DISQAM dirancang sebagai jembatan antara bukti ilmiah CBT-I yang kuat dengan kebutuhan nyata lansia dengan penyakit kronis di lapangan. Melalui pendekatan yang sederhana, bertahap, dan penuh empati, diharapkan program ini dapat membantu memperbaiki kualitas tidur lansia, memperlambat proses frailty (kerapuhan), serta pada akhirnya meningkatkan kualitas hidup dan kemandirian lansia dalam menjalani hari-harinya.',
          ],
          note: 'Aplikasi ini dapat terus disempurnakan berdasarkan pengalaman lapangan dan masukan dari fasilitator maupun peserta program.',
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
  conclusionGroup,
];

Article? findArticle(String? id) {
  for (final group in contentGroups) {
    for (final article in group.articles) {
      if (article.id == id) return article;
    }
  }
  return null;
}
