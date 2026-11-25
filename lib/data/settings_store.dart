import 'package:flutter/foundation.dart';

class SettingsStore extends ChangeNotifier {
  SettingsStore._();
  static final instance = SettingsStore._();

  bool pauseNotifications = false;
  bool motifNotifications = true;
  bool outfitNotifications = false;
  bool saveLoginInfo = true;

  bool get motifNotificationsActive =>
      !pauseNotifications && motifNotifications;
  bool get outfitNotificationsActive =>
      !pauseNotifications && outfitNotifications;

  void setPauseNotifications(bool value) {
    if (pauseNotifications == value) return;
    pauseNotifications = value;
    notifyListeners();
  }

  void setMotifNotifications(bool value) {
    if (motifNotifications == value && (!value || !pauseNotifications)) return;
    motifNotifications = value;
    if (value) pauseNotifications = false;
    notifyListeners();
  }

  void setOutfitNotifications(bool value) {
    if (outfitNotifications == value && (!value || !pauseNotifications)) return;
    outfitNotifications = value;
    if (value) pauseNotifications = false;
    notifyListeners();
  }

  void setSaveLoginInfo(bool value) {
    if (saveLoginInfo == value) return;
    saveLoginInfo = value;
    notifyListeners();
  }
}
