import 'package:flutter/foundation.dart';

class L10n extends ChangeNotifier {
  L10n._();
  static final instance = L10n._();

  String lang = 'Indonesia'; // 'Indonesia' atau 'English'

  void setLang(String name) {
    final v = name == 'English' ? 'English' : 'Indonesia';
    if (v == lang) return;
    lang = v;
    notifyListeners();
  }

  String tr(String id) {
    if (lang == 'Indonesia') return id;
    return _en[id] ?? id; // teks yang belum diterjemahkan tetap Indonesia
  }

  static const _en = <String, String>{
    // Bottom nav
    'Beranda': 'Home',
    'Favorit': 'Favorites',
    'Favorit Saya': 'My Favorites',
    'Favorite': 'Favorites',
    'PINDAI': 'SCAN',
    'Riwayat': 'History',
    'Profil': 'Profile',
    // Home
    'Tabik pun!': 'Tabik pun!',
    'Selamat datang di KAINARA': 'Welcome to KAINARA',
    'Cari nama motif, asal daerah...': 'Search motif name, region...',
    'Motif Tapis': 'Tapis Motifs',
    'Rekomendasi Outfit': 'Outfit Recommendations',
    'Semua': 'All',
    'Motif tidak ditemukan': 'No motifs found',
    'Outfit tidak ditemukan': 'No outfits found',
    'Gambar Tapis': 'Tapis Image',
    'Gambar Outfit': 'Outfit Image',
    'Warna yang Pas\nuntuk Gayamu': 'Colors That Suit\nYour Style',
    'Temukan Tapis yang sesuai\ndengan warna kulit-mu':
        'Find Tapis that suit\nyour skin tone',
    'Filter Daerah Motif Tapis': 'Filter Tapis Motif by Region',
    'Batal': 'Cancel',
    'Terapkan': 'Apply',
    // Favorit
    'Temukan motif favorit anda': 'Find your favorite motifs',
    'Temukan outfit favorit anda': 'Find your favorite outfits',
    'Pilih': 'Select',
    'Selesai': 'Done',
    'Motif': 'Motifs',
    'Outfit': 'Outfits',
    'Hapus': 'Delete',
    // Riwayat
    'Riwayat Scan': 'Scan History',
    'Riwayat tidak ditemukan': 'No history found',
    'Arsip Identifikasi tapis': 'Tapis identification archive',
    'Arsip Analisis Warna Kulit & Wastra':
        'Skin tone & textile analysis archive',
    'Skintone': 'Skin tone',
    'Cari riwayat...': 'Search history...',
    'akurasi': 'accuracy',
    'Tenun': 'Weaving',
    'TONE': 'TONE',
    'penjelasan': 'details',
    // Scan
    'PEMINDAI  MOTIF TAPIS': 'TAPIS MOTIF SCANNER',
    'scan motif': 'scan motif',
    'scan skintone': 'scan skin tone',
    'ANALISIS MOTIF...': 'ANALYZING MOTIF...',
    // Detail
    'Asal Motif Tapis': 'Tapis Motif Origin',
    'Deskripsi Singkat': 'Short Description',
    'Penggunaan': 'Usage',
    'Perawatan': 'Care',
    'Share motif': 'Share motif',
    'lihat motif lain': 'see other motifs',
    // Profil
    'Nama Pengguna': 'Username',
    'Ubah nama': 'Change name',
    'Email Pengguna': 'User Email',
    'Pilih jenis kelamin': 'Choose gender',
    'Pengaturan': 'Settings',
    'Terverifikasi': 'Verified',
    'Perempuan': 'Female',
    'Laki-laki': 'Male',
    'Lainnya': 'Other',
    // Settings
    'Settings Account': 'Account Settings',
    'Pengaturan Akun': 'Account Settings',
    'Notifikasi': 'Notifications',
    'Pengaturan Bahasa': 'Language Settings',
    'Privasi dan Keamanan': 'Privacy and Security',
    'Privasi & Keamanan': 'Privacy & Security',
    'Ganti Password/Email': 'Change Password/Email',
    'Ganti Akun': 'Switch Account',
    'Log Out': 'Log Out',
    'Jeda semua': 'Pause all',
    'Jeda semua notifikasi sementara': 'Temporarily pause all notifications',
    'Notifikasi motif tapis aktif': 'Tapis motif notifications on',
    'Notifikasi rekomendasi outfit aktif':
        'Outfit recommendation notifications on',
    'Bahasa Utama': 'Main Language',
    'Edit': 'Edit',
    'Tambahkan Bahasa': 'Add Language',
    'Password': 'Password',
    'Email': 'Email',
    'nama@email.com': 'name@email.com',
    'Daftar bahasa tersimpan': 'Saved languages',
    'Pemeriksaan Keamanan': 'Security Check',
    'Perangkat Anda': 'Your Devices',
    'Simpan info login': 'Save login info',
    'Kelola Perangkat': 'Manage Devices',
    'Perangkat saat ini': 'Current device',
    'Perangkat lain tempat anda masuk': 'Other devices you are signed in on',
    'Keluar': 'Sign out',
    'Aktif': 'Active',
    'Password & Email': 'Password & Email',
    'Simpan': 'Save',
    'Tutup': 'Close',
    'Fitur ganti akun segera hadir': 'Account switching will be available soon',
    'Anda yakin ingin keluar dari akun ini?':
        'Are you sure you want to log out of this account?',
    'Semua bahasa sudah ditambahkan': 'All available languages have been added',
    'Jawa': 'Javanese',
    'Bahasa Jawa': 'Javanese language',
    'Lampung': 'Lampung',
    'Bahasa Lampung': 'Lampung language',
    'Sunda': 'Sundanese',
    'Bahasa Sunda': 'Sundanese language',
    'Melayu': 'Malay',
    'Bahasa Melayu': 'Malay language',
    'Inggris': 'English',
    'Bahasa Indonesia': 'Indonesian',
    'Bahasa pertama di daftar akan digunakan sebagai prioritas tampilan antarmuka kain dan busana KAINARA.': 'The first language in the list will be the preferred language for the KAINARA textile and fashion interface.',
    'Semua info login yang disimpan untuk akun ini akan dihapus jika pengaturan ini dinonaktifkan.': 'All saved login information for this account will be deleted if this setting is turned off.',
    'Keamanan': 'Security',
    'Lihat dan kelola pengaturan untuk menjaga keamanan akun Anda':
        'View and manage settings to keep your account secure',
    'Peringatan Keamanan': 'Security Alert',
    'Aktivitas akun selama 7 hari terakhir':
        'Account activity over the last 7 days',
    'Tidak ada aktivitas mencurigakan pada akun Anda dalam 7 hari terakhir.': 'There has been no suspicious activity on your account in the last 7 days.',
    'Ubah email': 'Change email',
    'Password baru': 'New password',
    'Minimal 6 karakter': 'At least 6 characters',
    'Password diperbarui': 'Password updated',
    'Aplikasi': 'App',
    'Sesi Utama': 'Primary Session',
    'Keluar dari perangkat': 'Sign out of device',
    'Keluarkan akun Anda dari': 'Sign your account out of',
    'Tidak ada perangkat lain': 'No other devices',
    '26 Oktober 2025 08.56 WIB': 'October 26, 2025 08:56 AM',
    'Semua Busana': 'All Outfits',
    'Belum ada favorit.\nTekan ikon hati pada motif atau outfit.':
        'No favorites yet.\nTap the heart icon on a motif or outfit.',
  };
}

/// Pintasan: tr('teks Indonesia')
String tr(String id) => L10n.instance.tr(id);
