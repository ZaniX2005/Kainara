import '../models/motif.dart';

const _usage =
    'Motif tapis ini digunakan dalam kain adat Lampung, khususnya pada acara adat dan upacara penting. Motif ini juga dipakai sebagai simbol harapan dan kekuatan.';
const _care = [
  'Bersihkan lembut: jangan sering dicuci, cukup dilap atau dry clean.',
  'Jangan jemur langsung: cukup diangin-anginkan di tempat teduh.',
  'Simpan rapi: di tempat kering, bersih, bebas lembap dan serangga.',
  'Perbaikan: serahkan ke pengrajin jika ada benang rusak.',
];

Motif _m(
  String id,
  String name,
  String region,
  String summary,
  String image,
) => Motif(
  id: id,
  name: name,
  subtitle: 'Tapis $region',
  region: region,
  origin: 'Lampung ($region)',
  summary: summary,
  description:
      'Tapis $name adalah kain tradisional Lampung dengan corak khas yang melambangkan pertumbuhan, keteguhan, dan harapan hidup.',
  image: image,
  headerImage: image,
  usage: _usage,
  care: _care,
);

final motifs = <Motif>[
  _m(
    'm1',
    'Jung Sarat',
    'Menggala',
    'Tapis ini disulam penuh dengan benang emas.',
    'assets/images/motif/motif_1.png',
  ),
  _m(
    'm2',
    'Raja Tunggal',
    'Way Kanan',
    'Tapis ini umumnya digunakan oleh istri dari tokoh adat.',
    'assets/images/motif/motif_2.png',
  ),
  _m(
    'm3',
    'Raja Medal',
    'Pepadun',
    'Kain ini dipakai oleh pengantin wanita atau tokoh adat.',
    'assets/images/motif/motif_3.png',
  ),
  _m(
    'm4',
    'Laut Andak',
    'Pesisir',
    'Dikenal dengan corak yang lebih spesifik, Tapis ini dipakai pada upacara adat.',
    'assets/images/motif/motif_4.png',
  ),
  _m(
    'm5',
    'Balak',
    'Menggala',
    'Tapis Balak (yang berarti "besar") adalah lambang kebesaran adat.',
    'assets/images/motif/motif_5.png',
  ),
  _m(
    'm6',
    'Silung',
    'Menggala',
    'Memiliki corak khas yang biasanya dipakai oleh perempuan dalam acara adat.',
    'assets/images/motif/motif_6.png',
  ),
];

const outfits = <Outfit>[
  Outfit(
    image: 'assets/images/outfit/outfit_1.png',
    category: 'Dress',
    description: 'Tapis ini disulam penuh dengan benang emas.',
  ),
  Outfit(
    image: 'assets/images/outfit/outfit_2.png',
    category: 'Adat',
    description: 'Tapis ini umumnya digunakan oleh istri dari tokoh adat.',
  ),
  Outfit(
    image: 'assets/images/outfit/outfit_3.png',
    category: 'Blazer',
    description: 'Kain ini dipakai oleh pengantin wanita atau tokoh adat.',
  ),
  Outfit(
    image: 'assets/images/outfit/outfit_4.png',
    category: 'Outer',
    description: 'Dikenal dengan corak yang lebih spesifik, Tapis ini dipakai pada upacara adat.',
  ),
  Outfit(
    image: 'assets/images/outfit/outfit_5.png',
    category: 'Adat',
    description:
        'Tapis Balak (yang berarti "besar") adalah lambang kebesaran adat.',
  ),
  Outfit(
    image: 'assets/images/outfit/outfit_6.png',
    category: 'Adat',
    description: 'Memiliki corak khas yang biasanya dipakai oleh perempuan dalam acara adat.',
  ),
];
