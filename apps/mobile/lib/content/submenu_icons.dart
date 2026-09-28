/// Visual markers for article cards in each submenu.
/// Assets originate from docs/source/Icons.
const submenuIconAssets = <String, String>{
  'sleep-definition': 'assets/images/submenu-icons/Icon_Sub_Konsep_Tidur.webp',
  'sleep-functions': 'assets/images/submenu-icons/Fungsi_tidur.webp',
  'sleep-cycle': 'assets/images/submenu-icons/icon_Siklus_tidur.webp',
  'sleep-processes':
      'assets/images/submenu-icons/Icon_Faktor_penyebab_&_mekanisme.webp',
  'sleep-stages': 'assets/images/submenu-icons/Icon_Sub_Konsep_Tidur.webp',
  'sleep-aging':
      'assets/images/submenu-icons/Icon_perubahan_Tidur_Pada_Lansia.webp',
  'sleep-disorders': 'assets/images/submenu-icons/Icon_Gangguan_Tidur.webp',
  'sleep-factors':
      'assets/images/submenu-icons/Icon_Faktor_penyebab_&_mekanisme.webp',
  'sleep-mechanisms':
      'assets/images/submenu-icons/Icon_Faktor_penyebab_&_mekanisme.webp',
  'sleep-impacts':
      'assets/images/submenu-icons/Icon_Keterkaitan_Tidur_ frailty_dan_penyakit_kronis.webp',
  'cbt-definition': 'assets/images/submenu-icons/Icon_Konsep_CBT.webp',
  'cbt-digital':
      'assets/images/submenu-icons/Icon_Pendekatan_CBT_berbasis_Digital.webp',
  'cbt-disqam-adaptation':
      'assets/images/submenu-icons/Icon_Adaptasi_CBT_pada_gangguan_Tidur.webp',
  'disqam-definition':
      'assets/images/submenu-icons/Icon_Program_Digital_Improving_Sleep_Quality_for_Aging_Management_(DISQAM).webp',
  'disqam-components': 'assets/images/submenu-icons/Icon_komponen_Disqam.webp',
  'disqam-sessions':
      'assets/images/submenu-icons/Icon_Pelaksanaan_intervensi_DISQAM.webp',
  'session-1': 'assets/images/submenu-icons/Icon_Sesi_I.webp',
  'session-2': 'assets/images/submenu-icons/Icon_Program_Disqam.webp',
  'session-3': 'assets/images/submenu-icons/Icon_Sesi_III.webp',
  'session-4':
      'assets/images/submenu-icons/Icon_Adaptasi_CBT_pada_gangguan_Tidur.webp',
  'session-5': 'assets/images/submenu-icons/Icon_App.webp',
  'session-6': 'assets/images/submenu-icons/Icon_Sesi_VI.webp',
  'caregiver-role': 'assets/images/submenu-icons/Icon_peran_Cargiver.webp',
  'caregiver-communication':
      'assets/images/submenu-icons/Icon_contoh_komunikasi.webp',
  'caregiver-boundaries':
      'assets/images/submenu-icons/Icon_peran_Cargiver.webp',
  'appendix-1': 'assets/images/submenu-icons/icon.webp',
  'appendix-2': 'assets/images/submenu-icons/icon.webp',
  'appendix-3': 'assets/images/submenu-icons/icon.webp',
  'appendix-4': 'assets/images/submenu-icons/icon.webp',
  'bibliography': 'assets/images/submenu-icons/Icon_App.webp',
  'conclusion': 'assets/images/submenu-icons/icon_full.webp',
};

String? submenuIconAsset(String articleId) => submenuIconAssets[articleId];
