import 'models.dart';
import 'program.dart';

const sleepGroup = ContentGroup(
  id: 'sleep',
  title: 'Konsep Tidur',
  asset: 'assets/images/sleep.webp',
  summary: 'Mengenal tidur dan perubahan yang terjadi pada usia lanjut.',
  articles: [
    Article(
      id: 'sleep-understanding',
      title: 'Mengenal tidur yang berkualitas',
      summary: 'Tidur yang berkualitas tidak hanya dinilai dari lamanya tidur.',
      source: 'Modul DISQAM, Bab II §2.1–2.2.',
      sections: [
        ReadingSection(
          'Tubuh tetap bekerja saat tidur',
          paragraphs: [
            'Tidur merupakan keadaan kesehatan tubuh yang ditandai dengan perubahan tingkat kesadaran, aktivitas otak, reaksi tubuh terhadap rangsangan dari lingkungan sekitar, dan berbagai fungsi tubuh. Tidur bukan hanya keadaan saat tubuh berhenti beraktivitas. Ketika tidur, tubuh dan otak tetap bekerja untuk memulihkan tenaga, memperbaiki sel-sel tubuh, dan menjaga kesehatan.',
          ],
        ),
        ReadingSection(
          'Kualitas tidur tidak hanya durasi',
          paragraphs: [
            'Kualitas tidur dinilai dari berbagai hal. Penilaiannya tidak cukup hanya berdasarkan durasi tidur, tetapi juga mencakup kualitas tidur yang dirasakan, waktu yang diperlukan untuk mulai tidur, lama tidur, efisiensi tidur, gangguan tidur, penggunaan obat tidur, dan gangguan fungsi pada siang hari.',
            'Dengan demikian, tidur yang lama belum tentu merupakan tidur yang baik. Tidur dapat tetap kurang berkualitas apabila seseorang membutuhkan waktu lama untuk tertidur, sering terbangun, tidurnya beberapa kali terputus pada malam hari, atau tetap merasa tidak segar setelah bangun.',
          ],
        ),
        ReadingSection(
          'Fungsi tidur',
          paragraphs: [
            'Tidur mempunyai hubungan erat dengan berbagai fungsi biologis dan psikologis. Pada lansia, tidur yang baik mendukung pemeliharaan fungsi fisik, daya pikir, dan emosi. Sebaliknya, gangguan tidur dapat berhubungan dengan berbagai masalah kesehatan dan penurunan fungsi.',
          ],
          points: [
            'Mendukung proses pemulihan tubuh.',
            'Memelihara fungsi otak, termasuk proses pembelajaran dan daya ingat.',
            'Membantu mengelola perasaan dan menjaga suasana hati tetap stabil.',
            'Memelihara fungsi fisik, termasuk kemampuan melakukan kegiatan sehari-hari.',
            'Mendukung pemeliharaan kesehatan secara keseluruhan.',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-cycle',
      title: 'Siklus tidur dan jam alami tubuh',
      summary: 'Mengenal tahap NREM, REM, dorongan tidur, dan jam alami tubuh.',
      source: 'Modul DISQAM, Bab II §2.3.',
      sections: [
        ReadingSection(
          'Siklus tidur',
          paragraphs: [
            'Tidur merupakan proses aktif yang diatur oleh otak. Tubuh tidak berada dalam satu keadaan yang sama sepanjang malam, tetapi melewati beberapa tahap dengan tingkat kedalaman dan aktivitas otak yang berbeda. Tahap-tahap tersebut disebut struktur tidur atau sleep architecture.',
            'Tidur NREM atau non-rapid eye movement terdiri atas tahap N1, N2, dan N3. Tidur REM atau rapid eye movement ditandai dengan gerakan mata cepat, aktivitas otak meningkat, dan otot tubuh sangat rileks.',
            'Pergantian dari tidur NREM menuju REM dan kembali lagi disebut siklus tidur. Tubuh biasanya melewati sekitar 4 sampai 6 siklus dalam satu malam. Setiap siklus berlangsung kurang lebih 90 sampai 110 menit, tetapi durasinya dapat berbeda pada setiap orang dan setiap siklus.',
            'Siklus tidur berbeda dari jam alami tubuh. Jam alami tubuh mengatur kapan seseorang merasa mengantuk dan terjaga dalam pola sekitar 24 jam, sedangkan siklus tidur menjelaskan apa yang terjadi setelah seseorang tertidur.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/sleep-cycle.jpeg',
              alt: 'Ilustrasi tahap NREM satu, NREM dua, NREM tiga, dan REM.',
              caption: 'Gambar 2.1 · Siklus tidur',
            ),
          ],
        ),
        ReadingSection(
          'Tidur dan kesehatan lansia',
          paragraphs: [
            'Tidur tanpa gangguan merupakan proses penting yang mengatur fungsi tubuh secara keseluruhan. Tidur NREM mendukung fungsi sistem kekebalan tubuh, sedangkan tidur REM berperan dalam mengatur suasana hati sehari-hari.',
            'Kekurangan tidur selama satu atau dua malam biasanya tidak mengkhawatirkan. Namun, kekurangan tidur yang berkelanjutan dapat menyebabkan kelelahan pada siang hari, menurunkan kemampuan menjalankan kegiatan, dan meningkatkan kecenderungan perubahan suasana hati.',
            'Tidur pada usia lanjut sangat peka terhadap masalah kesehatan fisik kronis. Lansia lebih sering terbangun pada malam hari dan dapat membutuhkan waktu lebih lama untuk kembali tidur. Keterbatasan bergerak dan tidur siang yang meningkat juga dapat mengganggu keteraturan jadwal tidur.',
          ],
        ),
        ReadingSection(
          'Dua proses yang mengatur tidur',
          points: [
            'Dorongan tidur meningkat selama seseorang terjaga. Semakin lama seseorang tidak tidur, semakin besar kebutuhan tubuh untuk tidur. Setelah tidur dimulai, dorongan tersebut berkurang secara bertahap.',
            'Tidur siang terlalu lama dapat mengurangi sebagian dorongan tidur sehingga seseorang lebih sulit mengantuk pada malam hari.',
            'Jam alami tubuh mengatur waktu tidur dan bangun dalam pola sekitar 24 jam. Sistem ini dipengaruhi oleh cahaya dan kegelapan, waktu beraktivitas, jadwal makan, kebiasaan tidur dan bangun, interaksi sosial, serta pelepasan hormon termasuk melatonin.',
            'Seseorang lebih mudah tertidur ketika dorongan tidurnya cukup kuat dan jam alami tubuhnya menunjukkan bahwa waktu tidur telah tiba.',
          ],
        ),
        ReadingSection(
          'Tahap N1: mulai tertidur',
          paragraphs: [
            'N1 merupakan tahap peralihan dari keadaan terjaga menuju tidur. Tahap ini paling ringan dan biasanya berlangsung singkat. Mata mulai terpejam, gerakan mata melambat, otot mulai mengendur, denyut jantung dan pernapasan mulai melambat, serta respons terhadap keadaan sekitar mulai berkurang.',
            'Sebagian orang dapat merasakan sensasi seperti jatuh atau sentakan kaki secara tiba-tiba ketika mulai tertidur. Kondisi ini umumnya normal. Jika dibangunkan pada tahap N1, seseorang mungkin merasa dirinya belum benar-benar tidur.',
          ],
        ),
        ReadingSection(
          'Tahap N2: tidur semakin stabil',
          paragraphs: [
            'Pada tahap N2, tidur menjadi lebih stabil dan seseorang tidak semudah pada tahap N1 untuk dibangunkan. Denyut jantung melambat, pernapasan lebih teratur, suhu tubuh menurun, otot semakin rileks, gerakan mata berhenti, dan kesadaran terhadap lingkungan semakin berkurang.',
            'Aktivitas otak pada tahap N2 ditandai oleh sleep spindles dan K-complexes. Keduanya membantu mempertahankan tidur dan berhubungan dengan proses pembelajaran serta penyimpanan ingatan. N2 merupakan tahap yang paling banyak ditemui selama tidur malam.',
          ],
        ),
        ReadingSection(
          'Tahap N3: tidur dalam',
          paragraphs: [
            'N3 merupakan tahap tidur paling dalam dan sering disebut tidur gelombang lambat. Denyut jantung dan pernapasan lebih lambat dan stabil, otot sangat rileks, dan tubuh lebih sulit dibangunkan.',
            'Pada tahap ini, pemulihan fisik berlangsung lebih kuat. Perbaikan jaringan, pemulihan energi, sistem kekebalan tubuh, pengaturan hormon, serta pengolahan dan penguatan ingatan mendapat dukungan.',
            'Jika dibangunkan tiba-tiba, seseorang dapat merasa bingung, lemas, atau belum sepenuhnya sadar selama beberapa saat. Keadaan ini disebut sleep inertia. N3 lebih banyak terjadi pada sepertiga awal malam dan berkurang menjelang pagi.',
          ],
        ),
        ReadingSection(
          'Tahap REM: aktivitas otak meningkat',
          paragraphs: [
            'REM adalah singkatan dari Rapid Eye Movement atau gerakan mata cepat. Aktivitas otak meningkat dan mendekati aktivitas ketika terjaga, tetapi sebagian besar otot tubuh menjadi sangat rileks dan tidak aktif untuk sementara.',
          ],
          points: [
            'Mata bergerak cepat di balik kelopak dan mimpi lebih sering terasa jelas.',
            'Pernapasan lebih bervariasi; denyut jantung dan tekanan darah dapat berubah.',
            'Penurunan aktivitas otot membantu mencegah tubuh melakukan gerakan sesuai isi mimpi, sedangkan otot pernapasan utama tetap bekerja.',
            'REM berkaitan dengan pengolahan emosi, pembelajaran, penyimpanan ingatan, dan hubungan antarsel saraf.',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-aging',
      title: 'Perubahan tidur pada lansia',
      summary: 'Memahami perubahan alami dan keluhan yang perlu diperhatikan.',
      source: 'Modul DISQAM, Bab II §2.4.',
      sections: [
        ReadingSection(
          'Perubahan yang dapat terjadi',
          paragraphs: [
            'Seiring bertambahnya usia, pola tidur lansia mengalami perubahan secara alami. Lansia mungkin lebih sering terbangun pada malam hari, tidur lebih ringan, tidur dan bangun lebih awal, serta mengalami perubahan jadwal tidur sehari-hari.',
            'Namun, perubahan tersebut perlu dibedakan dari gangguan tidur. Gangguan tidur bukanlah hal yang pasti atau wajar hanya karena seseorang bertambah tua. Penyebab masalah tidur pada setiap lansia perlu diketahui agar dapat ditangani dengan tepat.',
          ],
          points: [
            'Tidur lebih ringan karena lebih banyak berada pada tahap N1 dan N2 serta berkurangnya tahap N3.',
            'Tidur lebih sering terputus dan waktu terjaga setelah mulai tidur dapat menjadi lebih panjang.',
            'Tidur dalam berkurang sehingga tidur dapat terasa kurang nyenyak walaupun waktu di tempat tidur cukup panjang.',
            'Jam alami tubuh dapat bergeser lebih awal sehingga rasa mengantuk dan waktu bangun muncul lebih awal.',
            'Proporsi REM dapat sedikit menurun, tetapi penyakit, obat, gangguan pernapasan, depresi, dan kebiasaan tidur sering lebih berpengaruh daripada usia saja.',
            'Efisiensi tidur menurun karena tidak seluruh waktu di tempat tidur digunakan untuk tidur.',
          ],
        ),
        ReadingSection(
          'Keluhan menetap bukan hal yang harus dianggap wajar',
          paragraphs: [
            'Tidur yang lebih ringan dapat terjadi seiring bertambahnya usia. Namun, gangguan tidur yang menetap dan mengganggu kegiatan bukanlah sesuatu yang harus dianggap wajar hanya karena seseorang sudah lanjut usia.',
            'Keluhan tidur dapat dipengaruhi oleh nyeri kronis, sesak napas, penyakit jantung atau paru-paru, diabetes, sering buang air kecil pada malam hari, kecemasan atau depresi, kurangnya aktivitas siang hari, tidur siang terlalu lama, obat tertentu, apnea tidur obstruktif, sindrom kaki gelisah, dan lingkungan tidur yang tidak nyaman.',
          ],
          note: 'Sampaikan keluhan yang menetap kepada tenaga kesehatan agar penyebabnya dapat dinilai.',
        ),
      ],
    ),
    Article(
      id: 'sleep-disorders',
      title: 'Mengenal gangguan tidur',
      summary: 'Gangguan tidur dapat memiliki bentuk dan penyebab yang berbeda.',
      source: 'Modul DISQAM, Bab II §2.5–2.6.',
      sections: [
        ReadingSection(
          'Enam kelompok gangguan tidur',
          paragraphs: [
            'Gangguan tidur adalah berbagai kondisi yang menyebabkan seseorang sulit mendapatkan tidur yang cukup dan nyenyak. Gangguan ini dapat memengaruhi waktu mulai tidur, lamanya tidur, seringnya terbangun, serta jadwal tidur dan bangun.',
          ],
          points: [
            'Gangguan insomnia: sulit mulai tidur, sulit mempertahankan tidur, sering terbangun, atau bangun terlalu pagi.',
            'Gangguan pernapasan saat tidur: pernapasan terganggu selama tidur, seperti mendengkur keras atau napas berhenti sesaat.',
            'Gangguan mengantuk berlebihan: rasa mengantuk berlebihan pada siang hari meskipun telah tidur malam.',
            'Gangguan jadwal tidur dan bangun: waktu tidur dan bangun tidak sesuai dengan jadwal yang dibutuhkan atau lingkungan sekitar.',
            'Parasomnia: perilaku atau kejadian tidak biasa saat tidur, seperti berjalan, berbicara, atau berteriak ketika tidur.',
            'Gangguan gerakan saat tidur: gerakan tubuh berulang atau rasa tidak nyaman ketika akan tidur maupun selama tidur.',
          ],
        ),
        ReadingSection(
          'Insomnia',
          paragraphs: [
            'Modul menjelaskan insomnia sebagai keluhan tidur yang tidak mencukupi dan tidak memberikan rasa segar setelah bangun, berlangsung menetap, serta mengganggu fungsi pekerjaan atau sosial. Penegakan diagnosis perlu memastikan bahwa keluhan bukan disebabkan oleh gangguan tidur atau kondisi lain.',
          ],
          points: [
            'Insomnia awal tidur: kesulitan untuk mulai tertidur.',
            'Insomnia mempertahankan tidur: sering terbangun, bangun lebih pagi dari yang diinginkan, atau sulit tidur kembali.',
            'Insomnia tipe campuran: kesulitan mulai tertidur sekaligus mempertahankan tidur.',
            'Insomnia dapat muncul tanpa kondisi penyerta yang jelas atau berhubungan dengan kondisi medis, psikologis, maupun penggunaan zat tertentu.',
          ],
        ),
        ReadingSection(
          'Gangguan yang perlu diperhatikan pada lansia',
          points: [
            'Apnea tidur obstruktif perlu dicurigai bila ada mendengkur keras, napas berhenti sesaat yang dilihat orang lain, terbangun seperti tersedak, atau kantuk berlebihan pada siang hari.',
            'Gangguan jam alami tubuh terjadi ketika pola tidur dan bangun tidak selaras dengan jadwal alami tubuh atau tuntutan lingkungan.',
            'Parasomnia mencakup kejadian atau perilaku yang tidak diharapkan selama tidur atau saat beralih antara tidur dan terjaga.',
            'Sindrom kaki gelisah dapat menimbulkan kesemutan, rasa tertusuk, merayap, gatal, atau pegal serta dorongan kuat untuk menggerakkan kaki. Keluhan biasanya berkurang setelah kaki digerakkan atau digunakan berjalan.',
          ],
          note: 'Informasi ini membantu mengenali keluhan, bukan menentukan diagnosis. Pemeriksaan dan diagnosis dilakukan oleh tenaga kesehatan.',
        ),
      ],
    ),
    Article(
      id: 'sleep-factors',
      title: 'Penyebab dan dampak gangguan tidur',
      summary: 'Kondisi tubuh, pikiran, kebiasaan, lingkungan, dan obat saling berhubungan.',
      source: 'Modul DISQAM, Bab II §2.7.',
      sections: [
        ReadingSection(
          'Faktor biologis',
          paragraphs: [
            'Masalah tidur pada lansia biasanya tidak hanya disebabkan oleh satu hal. Perubahan akibat usia, penyakit menahun, nyeri, sesak napas, dan masalah kesehatan lain dapat membuat tidur semakin terganggu. Karena itu, pengkajian perlu mempertimbangkan kondisi kesehatan secara menyeluruh, bukan hanya pola tidur.',
          ],
        ),
        ReadingSection(
          'Faktor psikologis dan sosial',
          paragraphs: [
            'Rasa kesepian, stres, kekhawatiran atau kecemasan, kehilangan orang terdekat, kurangnya dukungan keluarga, dan kondisi sosial lainnya dapat membuat lansia sulit tidur atau sering terbangun.',
            'Semakin khawatir tidak bisa tidur, tubuh dan pikiran dapat semakin sulit rileks. Hal ini menjadi salah satu sasaran penting dalam CBT-I yang diadaptasi dalam DISQAM.',
          ],
        ),
        ReadingSection(
          'Faktor perilaku dan lingkungan',
          paragraphs: [
            'Waktu tidur yang tidak teratur, terlalu lama berada di tempat tidur saat tidak tidur, tidur siang yang tidak sesuai, atau menggunakan tempat tidur untuk kegiatan selain tidur dapat mempertahankan masalah tidur.',
            'Lingkungan tidur juga perlu diperhatikan. Suara, cahaya, suhu, kenyamanan kamar, dan keamanan dapat memengaruhi kemampuan tidur lebih nyenyak dan tidak sering terbangun.',
          ],
        ),
        ReadingSection(
          'Obat dan polifarmasi',
          paragraphs: [
            'Polifarmasi adalah penggunaan banyak jenis obat secara bersamaan. Hal ini perlu diperhatikan pada lansia dengan gangguan tidur. Pengkajian perlu mencakup obat yang digunakan, waktu penggunaannya, dan kemungkinan hubungan antara obat dengan perubahan pola tidur.',
          ],
          note: 'Jangan menghentikan, mengganti, atau mengubah dosis obat sendiri. Diskusikan dengan tenaga kesehatan.',
        ),
        ReadingSection(
          'Tubuh dan pikiran tetap siaga',
          paragraphs: [
            'Pada insomnia, tubuh dan pikiran dapat tetap terlalu aktif atau tegang ketika seharusnya mulai memasuki kondisi tidur. DISQAM memasukkan latihan relaksasi dan penataan pikiran untuk membantu mengurangi ketegangan tersebut.',
          ],
          points: [
            'Ketegangan tubuh dapat berupa jantung berdebar, napas terasa cepat, otot tegang, gelisah, atau tubuh sulit merasa nyaman.',
            'Ketegangan pikiran terjadi ketika pikiran terus memikirkan masalah, khawatir tidak dapat tidur, atau takut terhadap akibat kurang tidur.',
          ],
        ),
        ReadingSection(
          'Dampak gangguan tidur',
          points: [
            'Dampak fisik: dapat berkaitan dengan penurunan fungsi dan masalah kesehatan.',
            'Dampak daya pikir: tidur berhubungan erat dengan fungsi otak dan kegiatan sehari-hari.',
            'Dampak psikologis: gangguan tidur dan masalah psikologis dapat saling memengaruhi.',
            'Dampak fungsi dan kualitas hidup: insomnia kronis dapat mengganggu fungsi sehingga perlu ditangani secara klinis.',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-assessment',
      title: 'Pengkajian dan penanganan gangguan tidur',
      summary: 'Mengenali pola tidur dan memilih penanganan sesuai kondisi.',
      source: 'Modul DISQAM, Bab II §2.8.',
      sections: [
        ReadingSection(
          'Pengkajian gangguan tidur',
          paragraphs: [
            'Pengkajian insomnia dan gangguan tidur sebaiknya tidak hanya menggunakan satu pertanyaan tentang sulit tidur. Pengkajian dapat mencakup wawancara mengenai riwayat tidur dan kesehatan, kuesioner tidur, serta buku harian tidur. Pemeriksaan tambahan dilakukan sesuai kebutuhan klinis.',
            'Pittsburgh Sleep Quality Index atau PSQI digunakan untuk menilai kualitas dan gangguan tidur selama satu bulan. Instrumen ini terdiri dari 19 butir yang menghasilkan tujuh komponen.',
          ],
          points: [
            'Kualitas tidur yang dirasakan.',
            'Waktu yang diperlukan untuk mulai tidur.',
            'Durasi tidur dan efisiensi tidur sehari-hari.',
            'Gangguan tidur dan penggunaan obat tidur.',
            'Gangguan fungsi pada siang hari.',
          ],
        ),
        ReadingSection(
          'Buku harian tidur',
          paragraphs: [
            'Buku harian tidur digunakan untuk memperoleh gambaran pola tidur yang dipantau secara berkala dari awal hingga akhir kegiatan terapi. Data ini dapat digunakan untuk menilai perubahan pola tidur selama terapi.',
          ],
          points: [
            'Waktu masuk tempat tidur dan perkiraan waktu mulai tidur.',
            'Jumlah terbangun dan durasi terjaga.',
            'Waktu bangun dan waktu keluar dari tempat tidur.',
            'Tidur siang dan kegiatan tertentu yang berhubungan dengan tidur.',
          ],
        ),
        ReadingSection(
          'Penanganan sesuai kondisi',
          paragraphs: [
            'Penanganan perlu disesuaikan dengan penyebab dan kondisi masing-masing orang. Pada insomnia kronis, pedoman menempatkan CBT-I sebagai terapi utama. Obat dapat dipertimbangkan berdasarkan evaluasi klinis serta manfaat dan risikonya.',
            'Modul menjelaskan bahwa penggunaan obat tidur jangka panjang perlu dipantau karena dapat berkaitan dengan toleransi, pembiasaan, perubahan susunan tahap tidur, kebingungan, ketidakstabilan tubuh, dan ketergantungan psikologis.',
          ],
          note: 'Jangan menghentikan atau mengubah obat tanpa arahan tenaga kesehatan.',
        ),
      ],
    ),
    Article(
      id: 'sleep-frailty',
      title: 'Tidur, penyakit kronis, dan kerapuhan',
      summary: 'Hubungan tidur dengan kesehatan, kekuatan fisik, dan kemandirian.',
      source: 'Modul DISQAM, Bab II §2.9–2.10.',
      sections: [
        ReadingSection(
          'Hubungan yang saling memengaruhi',
          points: [
            'Tidur yang buruk mengganggu pemulihan otot dan keseimbangan hormon. Dalam jangka panjang, hal ini dapat berhubungan dengan penurunan kekuatan fisik.',
            'Penyakit kronis, nyeri, sesak napas, sering buang air kecil pada malam hari, dan kecemasan terkait kesehatan dapat mengganggu kesinambungan tidur.',
            'Kerapuhan dan kelemahan fisik dapat meningkatkan waktu berbaring atau tidur siang berlebihan sehingga kualitas tidur malam memburuk.',
            'Perbaikan pola dan kualitas tidur diharapkan dapat mendukung kekuatan fisik, kewaspadaan, suasana hati, dan kemandirian lansia.',
          ],
        ),
        ReadingSection(
          'Adaptasi CBT-I dalam DISQAM',
          paragraphs: [
            'CBT-I standar dapat melibatkan pembatasan waktu di tempat tidur yang cukup ketat. Pada lansia dengan penyakit kronis dan risiko kerapuhan, DISQAM melakukan beberapa penyesuaian.',
          ],
          points: [
            'Pengaturan waktu tidur dilakukan lebih bertahap dan tidak boleh melewati batas aman yang ditentukan tenaga kesehatan. Modul menyebut batas umum 5 sampai 5,5 jam.',
            'Sesi dibuat lebih singkat, disertai pengulangan materi.',
            'Bahasa dan materi visual dibuat sederhana, dengan huruf besar dan ilustrasi bila memungkinkan.',
            'Keluarga atau pendamping dapat dilibatkan untuk membantu pemantauan dan pengingat jadwal.',
            'Keluhan pusing, kantuk berlebihan pada siang hari, nyeri, dan risiko jatuh dipantau lebih ketat.',
          ],
          note: 'Jangan mengatur atau memperpendek waktu di tempat tidur sendiri. Penyesuaian dilakukan bersama fasilitator atau tenaga kesehatan.',
        ),
      ],
    ),
  ],
);

const cbtGroup = ContentGroup(
  id: 'cbt',
  title: 'CBT-I',
  asset: 'assets/images/cbt.webp',
  summary: 'Mengenal kebiasaan dan cara berpikir yang mendukung tidur.',
  articles: [
    Article(
      id: 'cbt-basics',
      title: 'Dasar CBT-I',
      summary: 'Pendekatan terstruktur untuk kebiasaan dan pikiran yang mempertahankan insomnia.',
      source: 'Modul DISQAM, Bab III §3.1.',
      sections: [
        ReadingSection(
          'Apa itu CBT-I?',
          paragraphs: [
            'CBT-I adalah Cognitive Behavioral Therapy for Insomnia. CBT-I merupakan intervensi terstruktur yang mengubah kebiasaan dan pola pikir yang mempertahankan insomnia.',
            'Intervensi perilaku dan kognitif dapat bermanfaat bagi lansia yang mengalami kesulitan tidur, khususnya ketika penggunaan obat berpotensi menimbulkan masalah. CBT-I multikomponen direkomendasikan untuk penanganan insomnia kronis pada orang dewasa.',
            'Lansia dengan insomnia yang berhubungan dengan kondisi lain juga dapat memberikan respons baik terhadap kontrol stimulus dan relaksasi yang telah disesuaikan agar tidak memperburuk kondisi medisnya.',
          ],
        ),
        ReadingSection(
          'Komponen CBT-I',
          points: [
            'Sleep hygiene: membangun kebiasaan dan lingkungan tidur yang sehat.',
            'Stimulus control: mengaitkan tempat tidur dengan tidur.',
            'Pengaturan waktu tidur: mengurangi waktu di tempat tidur secara bertahap agar tidur lebih menyatu.',
            'Restrukturisasi kognitif: memeriksa dan mengubah pikiran yang tidak membantu tentang tidur.',
            'Relaxation training: mengurangi ketegangan tubuh dan pikiran.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/cbt-i-components.jpeg',
              alt: 'Bagan lima komponen CBT-I untuk lansia.',
              caption: 'Gambar 3.1 · Komponen CBT-I',
            ),
          ],
          note: 'Kebiasaan tidur sehat adalah fondasi bersama komponen lain, bukan satu-satunya terapi.',
        ),
      ],
    ),
    Article(
      id: 'cbt-digital',
      title: 'CBT-I berbasis digital',
      summary: 'Dukungan digital membantu materi dan pemantauan lebih mudah diakses.',
      source: 'Modul DISQAM, Bab III §3.2.',
      sections: [
        ReadingSection(
          'Dukungan digital',
          paragraphs: [
            'Pendekatan digital dapat meningkatkan akses dan mengurangi hambatan waktu serta jarak. Program digital yang dibahas dalam modul menggunakan buku harian tidur, edukasi, latihan relaksasi, pengaturan tidur, latihan fisik, pengingat, dan konsultasi.',
            'Salah satu program berlangsung delapan minggu dan menghasilkan perbaikan insomnia, kualitas tidur, efisiensi tidur, serta keyakinan yang kurang membantu tentang tidur.',
            'Program lain diberikan dalam enam sesi mingguan sekitar 30 menit, dan 79 persen peserta menyelesaikan setidaknya empat sesi. Program digital lima minggu lainnya memasukkan buku harian tidur, relaksasi, latihan pernapasan, imajinasi terbimbing, dan perubahan perilaku tidur.',
            'Temuan tersebut menunjukkan bahwa intervensi digital dapat dirancang dalam durasi yang relatif singkat dengan komponen yang terstruktur.',
          ],
          note: 'Dalam DISQAM, media digital mendukung pembelajaran dan pemantauan. Media digital tidak menggantikan pendampingan fasilitator atau pelayanan tenaga kesehatan.',
        ),
      ],
    ),
    Article(
      id: 'cbt-adaptation',
      title: 'Adaptasi CBT-I untuk lansia',
      summary: 'Program disesuaikan dengan kondisi fisik, daya pikir, dan kebutuhan pendampingan.',
      source: 'Modul DISQAM, Bab II §2.10 dan Bab IV §4.3.',
      sections: [
        ReadingSection(
          'Skrining sebelum intervensi',
          paragraphs: [
            'Sebelum mengikuti intervensi DISQAM, lansia menjalani skrining awal untuk mengenali kondisi tidur dan kebutuhan pendampingan. Skrining dapat menggunakan Insomnia Severity Index atau alat lain sesuai kebutuhan, disertai pengkajian singkat fungsi daya pikir.',
            'Hasil skrining membantu menentukan dukungan dalam memahami materi, mengikuti petunjuk, mengisi buku harian tidur, dan menggunakan media digital.',
          ],
        ),
        ReadingSection(
          'Pelaksanaan yang disesuaikan',
          paragraphs: [
            'Materi dan latihan diberikan secara bertahap, sistematis, interaktif, dan ramah lansia. Pelaksanaannya mempertimbangkan daya ingat, kemampuan memahami petunjuk, kondisi fisik, dan kebutuhan pendampingan masing-masing peserta.',
          ],
          note: 'Keselamatan dan kebutuhan rujukan didahulukan dari target intervensi.',
        ),
      ],
    ),
  ],
);

const disqamGroup = ContentGroup(
  id: 'disqam-overview',
  title: 'Mengenal Program DISQAM',
  asset: 'assets/images/program.webp',
  summary: 'Gambaran program, enam komponen, dan cara pelaksanaannya.',
  articles: [
    Article(
      id: 'disqam-overview',
      title: 'Mengenal Program DISQAM',
      summary: 'Baca gambaran program sebelum memulai enam sesi.',
      source: 'Modul DISQAM, Bab IV §4.1–4.3.',
      sections: [
        ReadingSection(
          'Apa itu DISQAM?',
          paragraphs: [
            'DISQAM adalah program intervensi tidur multikomponen yang mengadaptasi prinsip CBT-I dan dirancang khusus untuk lansia dengan penyakit kronis.',
            'Program ini disebut digital karena memanfaatkan media sederhana seperti panggilan video, pesan pengingat melalui telepon genggam atau WhatsApp, dan aplikasi pencatatan tidur untuk mendukung pemantauan serta keberlangsungan program. Dukungan digital tidak menggantikan pendampingan tatap muka oleh fasilitator.',
          ],
        ),
        ReadingSection(
          'Prinsip Program DISQAM',
          points: [
            'Sederhana dan ramah lansia.',
            'Latihan harian singkat.',
            'Buku harian tidur sebagai dasar umpan balik.',
            'Fleksibel terhadap kondisi fisik dan daya pikir.',
            'Pendamping atau keluarga dilibatkan bila diperlukan.',
            'Keselamatan dan rujukan didahulukan dari target intervensi.',
          ],
        ),
        ReadingSection(
          'Enam komponen DISQAM',
          points: [
            'Kenali masalah tidur dan sleep hygiene: membangun kebiasaan dan lingkungan yang mendukung tidur.',
            'Stimulus control: mengaitkan kembali tempat tidur dengan tidur.',
            'Pengaturan waktu tidur: mengurangi waktu terjaga di tempat tidur dan meningkatkan efisiensi tidur.',
            'Restrukturisasi kognitif: mengubah keyakinan yang tidak realistis atau menekan tentang tidur.',
            'Relaksasi: mengurangi ketegangan tubuh dan pikiran.',
            'Buku harian tidur dan monitoring: memantau pola, respons, dan pelaksanaan kegiatan.',
          ],
          media: [
            ReadingMedia(
              asset: 'assets/images/materials/disqam-components.png',
              alt: 'Bagan enam komponen utama CBT-I yang diadaptasi dalam Program DISQAM.',
              caption: 'Gambar 4.1 · Komponen utama CBT-I dalam DISQAM',
            ),
          ],
        ),
        ReadingSection(
          'Urutan enam sesi',
          points: [
            'Sesi I: mengenali masalah tidur dan membangun kebiasaan tidur sehat. Pilih dua atau tiga kebiasaan prioritas.',
            'Sesi II: stimulus control. Praktikkan penggunaan tempat tidur sebagai tempat untuk tidur.',
            'Sesi III: pengaturan waktu tidur. Ikuti jadwal yang disepakati bersama fasilitator.',
            'Sesi IV: restrukturisasi kognitif. Gunakan lembar Kenali–Periksa–Ganti.',
            'Sesi V: relaksasi dan pencegahan kekambuhan. Buat rencana pemeliharaan pribadi.',
            'Sesi VI: buku harian tidur dan monitoring. Buku harian diisi setiap pagi sejak sesi pertama.',
          ],
        ),
        ReadingSection(
          'Pelaksanaan intervensi',
          paragraphs: [
            'Skrining awal dilakukan untuk mengenali kondisi tidur dan kebutuhan pendampingan. Setelah kondisi awal diketahui, program diberikan secara bertahap melalui enam sesi yang saling berhubungan.',
            'Pendekatan dibuat sederhana, bertahap, interaktif, dan ramah lansia. Materi serta latihan mempertimbangkan kondisi fisik, daya ingat, kemampuan memahami petunjuk, dan kebutuhan pendampingan setiap peserta.',
          ],
        ),
      ],
    ),
  ],
);

const caregiverGroup = ContentGroup(
  id: 'caregiver',
  title: 'Panduan Pendamping',
  asset: 'assets/images/caregiver.webp',
  summary: 'Cara mendampingi tanpa mengambil alih kegiatan lansia.',
  articles: [
    Article(
      id: 'caregiver-role',
      title: 'Peran pendamping',
      summary: 'Dukungan diberikan sesuai kebutuhan peserta.',
      source: 'Modul DISQAM, Bab V §5.1.',
      sections: [
        ReadingSection(
          'Kapan pendamping dibutuhkan?',
          paragraphs: [
            'Sebagian lansia dapat mengikuti program secara mandiri. Pendamping atau keluarga dapat membantu bila terdapat keterbatasan penglihatan, keterampilan digital, daya ingat, kemampuan berpindah, atau risiko jatuh.',
            'Dukungan dapat diberikan secara langsung maupun melalui WhatsApp, telepon, atau panggilan video untuk memberikan bantuan praktis dan dukungan emosional.',
          ],
        ),
        ReadingSection(
          'Peran yang dianjurkan',
          points: [
            'Membantu membuka aplikasi tanpa mengambil alih seluruh proses.',
            'Mengingatkan pengisian buku harian secara netral.',
            'Membantu memastikan keamanan saat peserta bangun malam.',
            'Mendukung jadwal bangun yang konsisten.',
            'Membantu menghubungi tenaga kesehatan bila ada tanda bahaya.',
            'Memberikan dukungan tanpa menekan peserta agar harus tidur.',
          ],
        ),
      ],
    ),
    Article(
      id: 'caregiver-communication',
      title: 'Berkomunikasi tanpa menekan',
      summary: 'Contoh kalimat yang membantu peserta merasa didukung.',
      source: 'Modul DISQAM, Bab V §5.2; Tabel 4.11.',
      sections: [
        ReadingSection(
          'Contoh komunikasi',
          paragraphs: [
            'Daripada mengatakan “Ayo tidur, harus tidur sekarang”, katakan: “Tidak perlu memaksa tidur. Kita buat kondisi lebih nyaman dulu.”',
            'Daripada bertanya “Kenapa belum tidur juga?”, katakan: “Kalau belum mengantuk, boleh lakukan kegiatan ringan dulu.”',
            'Daripada mengatakan “Jangan sampai besok sakit karena kurang tidur”, katakan: “Kita ikuti rencana dan lihat pola beberapa hari, bukan satu malam saja.”',
          ],
        ),
        ReadingSection(
          'Batas peran pendamping',
          paragraphs: [
            'Pendamping tidak mengambil alih seluruh proses, mengubah obat, menentukan diagnosis, atau memperketat jadwal tidur sendiri. Keputusan klinis tetap menjadi kewenangan tenaga kesehatan.',
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
];

Article? findArticle(String? id) {
  for (final group in contentGroups) {
    for (final article in group.articles) {
      if (article.id == id) return article;
    }
  }
  return null;
}
