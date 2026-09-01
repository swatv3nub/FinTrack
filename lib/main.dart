import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/data/datasources/hive_data_source.dart';
import 'package:fintrack/data/models/transaction_hive_model.dart';
import 'package:fintrack/data/models/budget_hive_model.dart';
import 'package:fintrack/data/repositories/transaction_repository_impl.dart';
import 'package:fintrack/data/repositories/budget_repository_impl.dart';
import 'package:fintrack/data/repositories/settings_repository_impl.dart';
import 'package:fintrack/domain/repositories/transaction_repository.dart';
import 'package:fintrack/domain/repositories/budget_repository.dart';
import 'package:fintrack/domain/repositories/settings_repository.dart';
import 'package:fintrack/domain/usecases/transaction_usecases.dart';
import 'package:fintrack/domain/usecases/budget_usecases.dart';
import 'package:fintrack/domain/usecases/settings_usecases.dart';
import 'package:fintrack/presentation/providers/transaction_provider.dart';
import 'package:fintrack/presentation/providers/budget_provider.dart';
import 'package:fintrack/presentation/providers/theme_provider.dart';
import 'package:fintrack/presentation/screens/dashboard_screen.dart';
import 'package:fintrack/core/constants/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(TransactionHiveModelAdapter());
  Hive.registerAdapter(TransactionTypeHiveAdapter());
  Hive.registerAdapter(BudgetHiveModelAdapter());

  // Initialize Data Source
  final hiveDataSource = HiveDataSource();
  await hiveDataSource.init();

  // Initialize Repositories
  final TransactionRepository transactionRepository = TransactionRepositoryImpl(hiveDataSource);
  final BudgetRepository budgetRepository = BudgetRepositoryImpl(hiveDataSource);
  final SettingsRepository settingsRepository = SettingsRepositoryImpl(hiveDataSource);

  // Initialize Use Cases
  final getAllTransactionsUseCase = GetAllTransactionsUseCase(transactionRepository);
  final getRecentTransactionsUseCase = GetRecentTransactionsUseCase(transactionRepository);
  final getTransactionsByMonthUseCase = GetTransactionsByMonthUseCase(transactionRepository);
  final getExpenseForCategoryUseCase = GetExpenseForCategoryUseCase(transactionRepository);
  final addTransactionUseCase = AddTransactionUseCase(transactionRepository);
  final updateTransactionUseCase = UpdateTransactionUseCase(transactionRepository);
  final deleteTransactionUseCase = DeleteTransactionUseCase(transactionRepository);

  final getAllBudgetsUseCase = GetAllBudgetsUseCase(budgetRepository);
  final getBudgetsByMonthUseCase = GetBudgetsByMonthUseCase(budgetRepository);
  final getBudgetForCategoryUseCase = GetBudgetForCategoryUseCase(budgetRepository);
  final addBudgetUseCase = AddBudgetUseCase(budgetRepository);
  final updateBudgetUseCase = UpdateBudgetUseCase(budgetRepository);
  final deleteBudgetUseCase = DeleteBudgetUseCase(budgetRepository);
  final checkBudgetStatusUseCase = CheckBudgetStatusUseCase(budgetRepository, transactionRepository);
  final getBudgetProgressUseCase = GetBudgetProgressUseCase(budgetRepository, transactionRepository);

  final getThemeModeUseCase = GetThemeModeUseCase(settingsRepository);
  final setThemeModeUseCase = SetThemeModeUseCase(settingsRepository);

  runApp(MyApp(
    transactionProvider: TransactionProvider(
      getAllTransactionsUseCase: getAllTransactionsUseCase,
      getRecentTransactionsUseCase: getRecentTransactionsUseCase,
      getTransactionsByMonthUseCase: getTransactionsByMonthUseCase,
      getExpenseForCategoryUseCase: getExpenseForCategoryUseCase,
      addTransactionUseCase: addTransactionUseCase,
      updateTransactionUseCase: updateTransactionUseCase,
      deleteTransactionUseCase: deleteTransactionUseCase,
    ),
    budgetProvider: BudgetProvider(
      getAllBudgetsUseCase: getAllBudgetsUseCase,
      getBudgetsByMonthUseCase: getBudgetsByMonthUseCase,
      getBudgetForCategoryUseCase: getBudgetForCategoryUseCase,
      addBudgetUseCase: addBudgetUseCase,
      updateBudgetUseCase: updateBudgetUseCase,
      deleteBudgetUseCase: deleteBudgetUseCase,
      checkBudgetStatusUseCase: checkBudgetStatusUseCase,
      getBudgetProgressUseCase: getBudgetProgressUseCase,
    ),
    themeProvider: ThemeProvider(
      getThemeModeUseCase: getThemeModeUseCase,
      setThemeModeUseCase: setThemeModeUseCase,
    ),
  ),
);
}

class MyApp extends StatelessWidget {
  final TransactionProvider transactionProvider;
  final BudgetProvider budgetProvider;
  final ThemeProvider themeProvider;

  const MyApp({
    super.key,
    required this.transactionProvider,
    required this.budgetProvider,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: transactionProvider),
        ChangeNotifierProvider.value(value: budgetProvider),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'FinTrack',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const DashboardScreen(),
          );
        },
      ),
    );
  }
}