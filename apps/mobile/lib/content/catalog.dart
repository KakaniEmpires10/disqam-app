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
      summary: 'Tidur yang baik lebih dari sekadar lamanya tidur.',
      source: 'Modul DISQAM, Bab II §2.1–2.2.',
      sections: [
        ReadingSection(
          'Tubuh tetap bekerja saat tidur',
          paragraphs: [
            'Tidur adalah waktu bagi tubuh dan otak untuk memulihkan tenaga, memperbaiki sel, dan menjaga kesehatan. Tidur bukan hanya berhenti beraktivitas.',
          ],
        ),
        ReadingSection(
          'Kualitas tidur tidak hanya durasi',
          paragraphs: [
            'Tidur yang lama belum tentu terasa nyenyak. Perhatikan juga waktu yang diperlukan untuk tertidur, seringnya terbangun, dan rasa segar setelah bangun.',
          ],
          points: [
            'Apakah sulit mulai tidur?',
            'Apakah sering terbangun atau lama terjaga?',
            'Bagaimana rasa kantuk dan kemampuan beraktivitas pada siang hari?',
          ],
          note: 'Pertanyaan ini membantu mengenali pengalaman tidur, bukan menentukan diagnosis.',
        ),
        ReadingSection(
          'Fungsi tidur',
          points: [
            'Mendukung pemulihan tubuh dan fungsi fisik.',
            'Mendukung pembelajaran dan daya ingat.',
            'Membantu mengelola perasaan dan suasana hati.',
            'Mendukung kemampuan menjalankan kegiatan sehari-hari.',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-cycle',
      title: 'Siklus tidur dan jam alami tubuh',
      summary: 'Mengenal tidur ringan, tidur dalam, dan jam alami tubuh.',
      source: 'Modul DISQAM, Bab II §2.3.',
      sections: [
        ReadingSection(
          'Tahap tidur berubah sepanjang malam',
          paragraphs: [
            'Tidur terdiri dari tahap NREM dan REM. NREM meliputi N1, N2, dan N3. Tubuh berpindah tahap beberapa kali sepanjang malam.',
          ],
          points: [
            'N1: peralihan dari terjaga menuju tidur; masih mudah dibangunkan.',
            'N2: tidur semakin stabil, napas dan denyut jantung lebih teratur.',
            'N3: tidur dalam yang mendukung pemulihan fisik.',
            'REM: aktivitas otak meningkat dan mimpi sering lebih jelas.',
          ],
        ),
        ReadingSection(
          'Dua proses yang bekerja bersama',
          points: [
            'Dorongan tidur meningkat semakin lama kita terjaga, lalu berkurang setelah tidur.',
            'Jam alami tubuh mengatur rasa mengantuk dan terjaga dalam pola sekitar 24 jam.',
            'Cahaya, kegiatan, jadwal makan, serta kebiasaan tidur-bangun memengaruhi jam alami tubuh.',
          ],
          note: 'Siklus tahap tidur berbeda dari jam alami tubuh dan dapat bervariasi pada setiap orang. Kalkulator aplikasi tidak memperkirakan tahap tidur.',
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
          'Apa yang dapat berubah?',
          points: [
            'Tidur cenderung lebih ringan dan lebih mudah terputus.',
            'Tidur dalam dapat berkurang.',
            'Rasa kantuk dan waktu bangun dapat bergeser lebih awal.',
            'Waktu di tempat tidur tidak selalu seluruhnya digunakan untuk tidur.',
          ],
        ),
        ReadingSection(
          'Keluhan menetap perlu diperhatikan',
          paragraphs: [
            'Perubahan karena usia perlu dibedakan dari gangguan tidur. Keluhan yang menetap dan mengganggu kegiatan bukan sesuatu yang harus dianggap wajar hanya karena sudah lanjut usia.',
            'Nyeri, sesak napas, sering buang air kecil pada malam hari, obat, kecemasan, dan lingkungan tidur dapat ikut memengaruhi tidur.',
          ],
          note: 'Bicarakan keluhan yang menetap dengan tenaga kesehatan agar penyebabnya dapat dinilai.',
        ),
      ],
    ),
    Article(
      id: 'sleep-disorders',
      title: 'Mengenal gangguan tidur',
      summary: 'Keluhan tidur dapat memiliki penyebab yang berbeda.',
      source: 'Modul DISQAM, Bab II §2.5–2.6.',
      sections: [
        ReadingSection(
          'Beberapa kelompok gangguan tidur',
          points: [
            'Insomnia: sulit mulai tidur, sulit mempertahankan tidur, atau bangun terlalu dini.',
            'Gangguan pernapasan saat tidur.',
            'Mengantuk berlebihan pada siang hari.',
            'Gangguan jadwal tidur dan bangun.',
            'Parasomnia: perilaku atau kejadian yang tidak biasa ketika tidur.',
            'Gangguan gerakan saat tidur, termasuk sindrom kaki gelisah.',
          ],
        ),
        ReadingSection(
          'Keluhan yang perlu disampaikan',
          paragraphs: [
            'Beri tahu tenaga kesehatan jika ada mendengkur keras, berhenti napas yang dilihat pendamping, terbangun seperti tersedak, atau kantuk siang berlebihan.',
            'Kaki yang terasa tidak nyaman dan ingin terus digerakkan saat duduk atau berbaring juga perlu diceritakan.',
          ],
          note: 'Aplikasi menyediakan informasi tentang tidur. Penentuan jenis gangguan tidur memerlukan pemeriksaan oleh tenaga kesehatan.',
        ),
      ],
    ),
    Article(
      id: 'sleep-factors',
      title: 'Hal yang memengaruhi tidur',
      summary: 'Kondisi tubuh, pikiran, kebiasaan, lingkungan, dan obat.',
      source: 'Modul DISQAM, Bab II §2.7.',
      sections: [
        ReadingSection(
          'Perhatikan kondisi secara menyeluruh',
          points: [
            'Tubuh: penyakit menahun, nyeri, atau sesak napas.',
            'Pikiran dan perasaan: stres, khawatir, kehilangan, atau kesepian.',
            'Kebiasaan: jadwal tidak teratur, terlalu lama terjaga di tempat tidur, atau tidur siang berlebihan.',
            'Lingkungan: suara, cahaya, suhu, dan kenyamanan kamar.',
            'Obat: jenis, jumlah, dan waktu penggunaan dapat berhubungan dengan perubahan tidur.',
          ],
          note: 'Jangan menghentikan atau mengubah obat sendiri. Diskusikan dengan tenaga kesehatan.',
        ),
        ReadingSection(
          'Saat tubuh tegang dan pikiran terus aktif',
          paragraphs: [
            'Tubuh dapat terasa tegang atau selalu siaga, sementara pikiran terus memikirkan masalah dan akibat kurang tidur.',
            'Latihan relaksasi dan latihan memeriksa pikiran dalam DISQAM membantu mengurangi ketegangan tubuh dan pikiran.',
          ],
        ),
      ],
    ),
    Article(
      id: 'sleep-assessment',
      title: 'Pengkajian dan penanganan tidur',
      summary: 'Mengenali pola tidur bersama tenaga kesehatan.',
      source: 'Modul DISQAM, Bab II §2.8.',
      sections: [
        ReadingSection(
          'Mengenali pola dari beberapa sumber',
          paragraphs: [
            'Pengkajian mencakup riwayat tidur, kondisi kesehatan, kuesioner, dan buku harian tidur. Pemeriksaan tambahan dilakukan sesuai kebutuhan klinis.',
            'Modul menjelaskan PSQI sebagai instrumen untuk menilai kualitas tidur selama satu bulan. Buku harian membantu melihat perubahan dari hari ke hari.',
          ],
        ),
        ReadingSection(
          'Penanganan sesuai kondisi',
          paragraphs: [
            'DISQAM mengadaptasi CBT-I, yaitu pendekatan terhadap kebiasaan dan pola pikir yang berkaitan dengan insomnia. Pemilihan penanganan tetap mempertimbangkan penyebab dan kondisi tiap orang.',
          ],
          note: 'Keputusan penggunaan atau perubahan obat dilakukan oleh tenaga kesehatan, bukan oleh aplikasi atau pendamping.',
        ),
      ],
    ),
    Article(
      id: 'sleep-frailty',
      title: 'Tidur, penyakit kronis, dan kerapuhan',
      summary: 'Mengapa tidur penting bagi kesehatan dan kemandirian.',
      source: 'Modul DISQAM, Bab II §2.9–2.10.',
      sections: [
        ReadingSection(
          'Hubungan yang saling memengaruhi',
          paragraphs: [
            'Penyakit kronis dapat mengganggu tidur melalui nyeri, sesak, sering buang air kecil, atau kecemasan. Sebaliknya, tidur yang buruk dapat mengganggu pemulihan tubuh.',
            'Frailty atau kerapuhan adalah penurunan cadangan dan fungsi tubuh sehingga lansia lebih rentan lelah, jatuh, sakit, dan kehilangan kemandirian.',
          ],
          note: 'DISQAM bertujuan membantu memperbaiki pola tidur dan mendukung kemandirian. Hasil tiap peserta dapat berbeda.',
        ),
        ReadingSection(
          'Program disesuaikan untuk lansia',
          points: [
            'Bahasa sederhana dan materi yang dapat dibaca bertahap.',
            'Bantuan keluarga atau pendamping bila diperlukan.',
            'Penyesuaian jadwal tidur dilakukan hati-hati dan bertahap.',
            'Keluhan pusing, kantuk berlebihan, nyeri, dan risiko jatuh perlu dipantau.',
          ],
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
      title: 'Apa itu CBT-I?',
      summary: 'Pendekatan perilaku dan pikiran untuk insomnia.',
      source: 'Modul DISQAM, Bab III §3.1.',
      sections: [
        ReadingSection(
          'Mengenali kebiasaan dan pola pikir',
          paragraphs: [
            'CBT-I adalah Cognitive Behavioral Therapy for Insomnia. Pendekatan terstruktur ini membantu mengubah kebiasaan dan pola pikir yang mempertahankan masalah insomnia.',
            'DISQAM mengadaptasi pendekatan tersebut agar sesuai dengan kondisi dan kebutuhan lansia.',
          ],
        ),
        ReadingSection(
          'Komponen yang saling melengkapi',
          points: [
            'Sleep hygiene: kebiasaan dan lingkungan tidur sehat.',
            'Stimulus control: mengaitkan tempat tidur dengan tidur.',
            'Pengaturan waktu di tempat tidur.',
            'Restrukturisasi kognitif: memeriksa pikiran tentang tidur.',
            'Relaksasi: menenangkan tubuh dan pikiran.',
          ],
          note: 'Kebiasaan tidur sehat adalah fondasi bersama komponen lain, bukan satu-satunya terapi dalam DISQAM.',
        ),
      ],
    ),
    Article(
      id: 'cbt-digital',
      title: 'CBT-I dengan dukungan digital',
      summary: 'Materi lebih mudah diakses, pendampingan tetap penting.',
      source: 'Modul DISQAM, Bab III §3.2; Bab IV §4.1.',
      sections: [
        ReadingSection(
          'Belajar dan berlatih secara bertahap',
          paragraphs: [
            'Media digital membantu akses ke materi dan mendukung keberlangsungan program. Dalam DISQAM, dukungan digital melengkapi pendampingan fasilitator.',
            'Materi pada aplikasi ini dapat dibaca tanpa internet. Baca ulang bagian yang dibutuhkan dan lakukan latihan sesuai kondisi serta arahan tenaga kesehatan.',
          ],
        ),
      ],
    ),
    Article(
      id: 'cbt-adaptation',
      title: 'Adaptasi untuk lansia',
      summary: 'Keselamatan dan kebutuhan peserta didahulukan.',
      source: 'Modul DISQAM, Bab I; §2.10; §4.3.',
      sections: [
        ReadingSection(
          'Sebelum mengikuti intervensi',
          paragraphs: [
            'Tenaga kesehatan perlu menilai kondisi kesehatan, keluhan tidur, dan kemampuan mengikuti petunjuk. Penilaian ini membantu menentukan kebutuhan pendampingan.',
          ],
          points: [
            'Sampaikan bila berisiko jatuh atau sulit berjalan dengan aman.',
            'Sampaikan bila ada gangguan daya ingat yang menghambat pemahaman.',
            'Sampaikan riwayat bipolar atau kondisi medis yang belum stabil.',
          ],
        ),
        ReadingSection(
          'Tidak memaksakan target',
          paragraphs: [
            'Penyesuaian waktu tidur dilakukan bertahap dan mempertimbangkan kondisi peserta. Pada kondisi tertentu, program perlu disesuaikan atau berfokus pada kebiasaan tidur dan relaksasi sesuai penilaian tenaga kesehatan.',
          ],
          note: 'Jangan memperketat jadwal tidur sendiri. Keselamatan dan kebutuhan rujukan lebih diutamakan daripada pencapaian target intervensi.',
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
      title: 'Membantu sesuai kebutuhan',
      summary: 'Dukungan praktis tanpa mengambil alih.',
      source: 'Modul DISQAM, Bab V §5.1.',
      sections: [
        ReadingSection(
          'Apa yang dapat dibantu?',
          points: [
            'Membantu membuka aplikasi dan membaca petunjuk bila diperlukan.',
            'Mengingatkan pengisian buku harian secara netral.',
            'Membantu menjaga keamanan ketika bangun malam.',
            'Mendukung waktu bangun yang konsisten.',
            'Membantu menghubungi tenaga kesehatan jika ada keluhan mengkhawatirkan.',
          ],
          note: 'Berikan ruang agar peserta tetap terlibat. Bantuan disesuaikan dengan penglihatan, daya ingat, kemampuan digital, dan mobilitasnya.',
        ),
      ],
    ),
    Article(
      id: 'caregiver-communication',
      title: 'Berkomunikasi tanpa menekan',
      summary: 'Contoh kalimat yang tidak membuat peserta merasa tertekan.',
      source: 'Modul DISQAM, Bab V §5.2; Tabel 4.11.',
      sections: [
        ReadingSection(
          'Membantu menciptakan kenyamanan',
          paragraphs: [
            'Daripada meminta “Harus tidur sekarang”, katakan: “Tidak perlu memaksa tidur. Kita buat kondisi lebih nyaman dulu.”',
            'Daripada bertanya “Kenapa belum tidur juga?”, katakan: “Kalau belum mengantuk, boleh lakukan kegiatan ringan dulu.”',
            'Bantu peserta melihat pola beberapa hari, bukan menghakimi satu malam yang buruk.',
          ],
        ),
        ReadingSection(
          'Batas peran pendamping',
          paragraphs: [
            'Pendamping tidak mengubah obat, menentukan diagnosis, atau memperketat jadwal tidur sendiri. Keputusan klinis tetap menjadi kewenangan tenaga kesehatan yang menangani peserta.',
          ],
        ),
      ],
    ),
  ],
);

const contentGroups = [sleepGroup, cbtGroup, programGroup, caregiverGroup];

Article? findArticle(String? id) {
  for (final group in contentGroups) {
    for (final article in group.articles) {
      if (article.id == id) return article;
    }
  }
  return null;
}
