import 'package:flutter/foundation.dart';

class ProfileStore extends ChangeNotifier {
  ProfileStore._();
  static final instance = ProfileStore._();

  String name = 'Dewi Indah Permata Sari';
  String email = 'Dewi5679@email.com';
  String password = 'Abcde123';
  String gender = 'Perempuan';
  bool verified = true;
  Uint8List? avatarBytes;

  String get maskedPassword =>
      '${password[0]}${'*' * (password.length - 2)}${password[password.length - 1]}';

  void update({
    String? name,
    String? email,
    String? password,
    String? gender,
    bool? verified,
    Uint8List? avatarBytes,
    bool clearAvatar = false,
  }) {
    if (name != null) this.name = name;
    if (email != null) this.email = email;
    if (password != null) this.password = password;
    if (gender != null) this.gender = gender;
    if (verified != null) this.verified = verified;
    if (avatarBytes != null) this.avatarBytes = avatarBytes;
    if (clearAvatar) this.avatarBytes = null;
    notifyListeners();
  }
}
