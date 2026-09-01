import 'package:fintrack/data/datasources/hive_data_source.dart';
import 'package:fintrack/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final HiveDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  @override
  Future<bool> getThemeMode() async {
    return await _dataSource.getThemeMode();
  }

  @override
  Future<void> setThemeMode(bool isDarkMode) async {
    await _dataSource.setThemeMode(isDarkMode);
  }

  @override
  Future<String?> getCurrencyCode() async {
    // Future: implement currency support
    return 'INR';
  }

  @override
  Future<void> setCurrencyCode(String code) async {
    // Future: implement currency support
  }
}