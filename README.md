# FinTrack - Smart Personal Finance & Expense Tracker

A cross-platform Flutter application for tracking personal expenses and budgets with analytics. Built with clean architecture, state management, and offline-first approach.

## 📱 Features

### Core Features
- **Dashboard**
  - Real-time current balance (Income - Expenses)
  - Recent transactions list (last 10)
  - Interactive pie chart showing expenses by category
  - Responsive layout for all screen sizes

- **Transactions Management**
  - Add, edit, and delete transactions
  - Categories for Income (Salary, Business, Investment, Gift, Other)
  - Categories for Expenses (Food, Travel, Bills, Shopping, Entertainment, Healthcare, Education, Other)
  - Input validation and error handling
  - Swipe-to-delete with undo functionality
  - Offline-first storage using Hive
  - Filter by transaction type (All, Income, Expense)

- **Budget Management**
  - Set monthly budgets per category
  - Visual progress indicators with color-coded alerts
  - Budget status tracking:
    - 🟢 Green: Under 80% of budget
    - 🟠 Orange: 80-100% of budget (approaching limit)
    - 🔴 Red: Over budget
  - Month navigation to view historical budgets

### Bonus Features
- ✅ **Light/Dark Mode Toggle** - System-aware theme with manual toggle
- ✅ **Smooth Animations** - Animated charts and transitions
- ✅ **CSV Export** - Export transactions to CSV format
- ✅ **Undo Delete** - Restore accidentally deleted transactions

## 🏗️ Architecture

### Project Structure
```
lib/
├── models/              # Data models with Hive adapters
│   ├── transaction_model.dart
│   ├── budget_model.dart
│   └── *.g.dart        # Generated Hive adapters
├── screens/            # UI screens
│   ├── dashboard_screen.dart
│   ├── transactions_screen.dart
│   ├── budgets_screen.dart
│   ├── add_transaction_screen.dart
│   └── add_budget_screen.dart
├── widgets/            # Reusable widgets
│   ├── balance_card.dart
│   ├── expense_chart.dart
│   └── transaction_list_item.dart
├── providers/          # State management
│   ├── transaction_provider.dart
│   ├── budget_provider.dart
│   └── theme_provider.dart
├── services/           # Business logic
│   ├── storage_service.dart
│   └── csv_export_service.dart
└── main.dart          # App entry point

test/
├── models/            # Model tests
├── widget_test.dart   # Widget and provider tests
└── ...
```

### State Management
**Choice: Provider**

Provider was chosen for this project because:
- ✅ Official Flutter recommendation
- ✅ Simple and intuitive API
- ✅ Excellent for small to medium apps
- ✅ Great performance with ChangeNotifier
- ✅ Easy testing and debugging
- ✅ Built-in dependency injection

**Alternative Considered:**
- Riverpod: More powerful but overkill for this scope
- Bloc: More boilerplate, better for large teams

### State Management Implementation
- `TransactionProvider`: Manages transaction CRUD, balance calculations, category aggregations
- `BudgetProvider`: Handles budget CRUD, budget status checks, alerts
- `ThemeProvider`: Manages theme mode persistence and switching

### Local Storage
**Choice: Hive**

Hive was selected because:
- ✅ Fast, pure Dart NoSQL database
- ✅ Type-safe with code generation
- ✅ Excellent offline support
- ✅ Minimal boilerplate
- ✅ Cross-platform compatibility
- ✅ Better performance than SQLite for this use case

**Storage Boxes:**
- `transactions`: Stores all transaction records
- `budgets`: Stores monthly budget configurations
- `settings`: Stores app preferences (theme mode)

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- Android SDK (for Android) or Xcode (for iOS)

### Installation Steps

1. **Clone the repository**
```bash
git clone https://github.com/swatv3nub/FinTrack.git
cd fintrack
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate Hive adapters** (already included in repo, but if needed)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device_id>
```

5. **Run tests**
```bash
# All tests
flutter test

# With coverage
flutter test --coverage

# Specific test file
flutter test test/widget_test.dart
```

## 🧪 Testing

### Test Coverage
The project includes comprehensive testing:

- ✅ **Unit Tests**
  - Transaction model tests (creation, copyWith, toMap)
  - Budget model tests (creation, copyWith, toMap)
  - Category validation tests

- ✅ **Widget Tests**
  - BalanceCard display tests
  - TransactionListItem rendering tests
  - Theme switching tests

- ✅ **Provider Tests**
  - Transaction CRUD operations
  - Balance calculations
  - Expense aggregation by category
  - Budget status checks
  - Undo delete functionality

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage report
flutter test --coverage
lcov --summary coverage/lcov.info

# Run specific test suite
flutter test test/models/transaction_model_test.dart
```

### Test Files
- `test/models/transaction_model_test.dart` - Transaction model unit tests
- `test/models/budget_model_test.dart` - Budget model unit tests
- `test/widget_test.dart` - Widget and provider integration tests

## 📦 Dependencies

### Production Dependencies
```yaml
provider: ^6.1.1          # State management
hive: ^2.2.3              # NoSQL database
hive_flutter: ^1.1.0      # Flutter integration for Hive
path_provider: ^2.1.1     # File system paths
fl_chart: ^0.65.0         # Beautiful charts
csv: ^5.1.1               # CSV export functionality
intl: ^0.18.1             # Internationalization
cupertino_icons: ^1.0.6   # iOS-style icons
```

### Dev Dependencies
```yaml
flutter_test:            # Testing framework
flutter_lints: ^3.0.1    # Flutter linting rules
hive_generator: ^2.0.1   # Hive adapter generator
build_runner: ^2.4.6     # Code generation
```

## 🎨 Design Decisions

### UI/UX
- Material Design 3 with custom theming
- Card-based layout for better visual hierarchy
- Color-coded indicators (green/orange/red) for budget status
- Swipe gestures for intuitive deletion
- Bottom navigation for easy access to main features
- Pull-to-refresh on dashboard

### Performance
- Lazy loading of transactions with ListView.builder
- Efficient state updates with ChangeNotifier
- Offline-first approach reduces network dependency
- Optimized chart rendering with fl_chart

### Code Quality
- Clean architecture with separation of concerns
- Consistent naming conventions
- Comprehensive documentation
- Flutter lints enabled
- Type-safe data models with Hive
- Error handling and validation throughout



## 🚧 Future Enhancements

Potential improvements for future versions:
- [ ] Multi-currency support
- [ ] Cloud sync with Firebase
- [ ] Recurring transactions
- [ ] Advanced analytics and reports
- [ ] Bill reminders and notifications
- [ ] Biometric authentication
- [ ] Data import from bank statements
- [ ] Category customization
- [ ] Budget templates

---
