import 'package:fintrack/domain/repositories/settings_repository.dart';

class GetThemeModeUseCase {
  final SettingsRepository repository;

  GetThemeModeUseCase(this.repository);

  Future<bool> call() async {
    return repository.getThemeMode();
  }
}

class SetThemeModeUseCase {
  final SettingsRepository repository;

  SetThemeModeUseCase(this.repository);

  Future<void> call(bool isDarkMode) async {
    return repository.setThemeMode(isDarkMode);
  }
}