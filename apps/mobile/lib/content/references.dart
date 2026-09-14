import 'models.dart';

const _borbely = ReadingLink(
  label: 'Borbély (2016) · Model dua proses tidur',
  url: 'https://doi.org/10.1111/jsr.12371',
);
const _carney = ReadingLink(
  label: 'Carney dkk. (2012) · Consensus Sleep Diary',
  url: 'https://doi.org/10.5665/sleep.1642',
);
const _edinger = ReadingLink(
  label: 'Edinger dkk. (2021) · Pedoman CBT-I',
  url: 'https://doi.org/10.5664/jcsm.8986',
);
const _kim = ReadingLink(
  label: 'Kim dkk. (2025) · CBT-I digital untuk lansia',
  url: 'https://doi.org/10.2196/67751',
);
const _kutzer = ReadingLink(
  label: 'Kutzer dkk. (2024) · CBT-I pada lansia',
  url: 'https://doi.org/10.1111/psyg.13074',
);
const _laidlaw = ReadingLink(
  label: 'Laidlaw dkk. (2003) · CBT untuk lansia',
  url: 'https://doi.org/10.1002/9780470713402',
);
const _li = ReadingLink(
  label: 'Li dkk. (2022) · Efektivitas CBT-I digital',
  url: 'https://doi.org/10.3390/ijerph19159544',
);
const _mander = ReadingLink(
  label: 'Mander dkk. (2017) · Tidur dan penuaan',
  url: 'https://doi.org/10.1016/j.neuron.2017.02.004',
);
const _mclaren = ReadingLink(
  label: 'McLaren dkk. (2023) · Komponen perilaku CBT-I',
  url: 'https://doi.org/10.1111/jsr.13843',
);
const _miner = ReadingLink(
  label: 'Miner & Kryger (2020) · Tidur pada lansia',
  url: 'https://doi.org/10.1016/j.jsmc.2020.02.016',
);
const _morin = ReadingLink(
  label: 'Morin dkk. (2015) · Gangguan insomnia',
  url: 'https://doi.org/10.1038/nrdp.2015.26',
);
const _peever = ReadingLink(
  label: 'Peever & Fuller (2017) · Biologi tidur REM',
  url: 'https://doi.org/10.1016/j.cub.2017.10.026',
);
const _patel = ReadingLink(
  label: 'Patel dkk. (2024) · Tahap dan siklus tidur',
  url: 'https://www.ncbi.nlm.nih.gov/books/NBK526132/',
);
const _riemann = ReadingLink(
  label: 'Riemann dkk. (2023) · Pedoman insomnia Eropa',
  url: 'https://doi.org/10.1111/jsr.14035',
);
const _spielman = ReadingLink(
  label: 'Spielman dkk. (1987) · Pengaturan waktu di tempat tidur',
  url: 'https://doi.org/10.1093/sleep/10.1.45',
);
const _thakral = ReadingLink(
  label: 'Thakral dkk. (2020) · CBT-I pada orang lanjut usia',
  url: 'https://doi.org/10.1016/j.smrv.2019.101230',
);

/// Rujukan ditempatkan dekat materi yang menggunakannya. Daftar pustaka
/// lengkap tetap tersedia sebagai halaman tersendiri.
const articleReferences = <String, List<ReadingLink>>{
  'sleep-definition': [_miner],
  'sleep-functions': [_miner],
  'sleep-cycle': [_patel, _peever],
  'sleep-processes': [_borbely],
  'sleep-stages': [_patel, _mander, _peever],
  'sleep-aging': [_li, _mander, _miner],
  'sleep-disorders': [_morin, _riemann],
  'sleep-factors': [_miner, _riemann],
  'sleep-mechanisms': [_edinger, _riemann],
  'sleep-impacts': [_edinger, _miner, _riemann],
  'cbt-definition': [_edinger, _kutzer, _mclaren],
  'cbt-digital': [_kim, _li],
  'disqam-definition': [_kim],
  'disqam-components': [_edinger, _mclaren],
  'disqam-sessions': [_edinger, _mclaren],
  'caregiver-role': [_kim, _laidlaw],
  'caregiver-communication': [_laidlaw],
  'caregiver-boundaries': [_laidlaw],
  'appendix-1': [_carney],
  'appendix-2': [_carney],
  'appendix-3': [_edinger],
  'appendix-4': [_edinger, _mclaren],
  'appendix-5': [_kutzer, _thakral],
  'session-1': [_carney, _miner],
  'session-2': [_edinger, _mclaren],
  'session-3': [_mclaren, _spielman],
  'session-4': [_kutzer, _thakral],
  'session-5': [_laidlaw],
  'session-6': [_carney, _morin],
};
