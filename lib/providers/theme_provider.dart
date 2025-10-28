import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider with ChangeNotifier {
  final StorageService _storageService;
  bool _isDarkMode = false;

  ThemeProvider(this._storageService) {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void _loadTheme() {
    _isDarkMode = _storageService.getThemeMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storageService.setThemeMode(_isDarkMode);
    notifyListeners();
  }
}
