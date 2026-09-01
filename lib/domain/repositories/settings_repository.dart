abstract class SettingsRepository {
  Future<bool> getThemeMode();
  Future<void> setThemeMode(bool isDarkMode);
  Future<String?> getCurrencyCode();
  Future<void> setCurrencyCode(String code);
}