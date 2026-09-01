import 'package:flutter/material.dart';
import 'package:fintrack/domain/usecases/settings_usecases.dart';

class ThemeProvider extends ChangeNotifier {
  final GetThemeModeUseCase _getThemeModeUseCase;
  final SetThemeModeUseCase _setThemeModeUseCase;

  bool _isDarkMode = false;

  ThemeProvider({
    required GetThemeModeUseCase getThemeModeUseCase,
    required SetThemeModeUseCase setThemeModeUseCase,
  })  : _getThemeModeUseCase = getThemeModeUseCase,
        _setThemeModeUseCase = setThemeModeUseCase {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> _loadTheme() async {
    _isDarkMode = await _getThemeModeUseCase();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _setThemeModeUseCase(_isDarkMode);
    notifyListeners();
  }
}