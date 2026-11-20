import 'package:flutter/foundation.dart';

class FavoritesStore extends ChangeNotifier {
  FavoritesStore._();
  static final instance = FavoritesStore._();

  final Set<String> _keys = {};

  bool isFav(String key) => _keys.contains(key);

  void toggle(String key) {
    if (!_keys.remove(key)) _keys.add(key);
    notifyListeners();
  }
}