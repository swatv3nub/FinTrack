# FinTrack — Smart Personal Finance & Expense Tracker

A production-quality, cross-platform Flutter application for tracking personal expenses and budgets with analytics. Built with **clean architecture**, **type-safe domain modeling**, **integer-based financial arithmetic**, and an **offline-first** approach.

---

## 📱 Features

### Core Features

- **Dashboard**
  - Real-time current balance (Income − Expenses) with minor-unit precision
  - Income / Expense breakdown cards
  - Interactive pie chart showing expenses by category (fl_chart)
  - Recent transactions list (last 10) with swipe actions
  - Pull-to-refresh

- **Transactions Management**
  - Add, edit, and delete transactions
  - Categories for Income (Salary, Business, Investment, Gift, Other)
  - Categories for Expenses (Food, Travel, Bills, Shopping, Entertainment, Healthcare, Education, Other)
  - Input validation (amount > 0, required title, decimal precision)
  - Swipe-to-delete with undo via SnackBar
  - Filter by type: All / Income / Expense
  - Sort by date (newest first)
  - CSV export via system share sheet (cross-platform, works on Android 10+/iOS)

- **Budget Management**
  - Set monthly budgets per expense category
  - Visual progress bars with color-coded status
  - Budget status:
    - 🟢 **Under Budget** (< 80%)
    - 🟠 **Approaching Limit** (80–100%)
    - 🔴 **Over Budget** (> 100%)
  - Month/Year navigation for historical views
  - Tap card to edit; long-press or menu to delete

### Bonus Features
- ✅ **Light / Dark Mode** — System-aware with manual toggle, persisted via Hive
- ✅ **CSV Export** — Uses `share_plus`; saves to temp dir, opens system share sheet (email, Drive, Files, etc.)
- ✅ **Undo Delete** — SnackBar with UNDO action restores last deleted transaction
- ✅ **Integer Money Arithmetic** — All amounts stored as minor units (paise/cents) to avoid floating-point errors
- ✅ **Responsive Layout** — Works on phones, tablets, portrait & landscape

---

## 🏗️ Architecture

### High-Level Layering

```
UI (Presentation)
    ↓
State / Providers
    ↓
Use Cases (Domain)
    ↓
Repositories (Interfaces)
    ↓
Data Sources (Hive)
```

### Project Structure

```
lib/
├── app/
│   └── main.dart                    # App entry, DI wiring
├── core/
│   └── constants/
│       ├── design_tokens.dart       # Colors, spacing, radius, elevation, typography
│       └── theme.dart               # Light / Dark ThemeData builders
├── data/
│   ├── datasources/
│   │   └── hive_data_source.dart    # Hive box operations (async)
│   ├── models/
│   │   ├── transaction_hive_model.dart   # Hive adapter + toEntity/fromEntity
│   │   └── budget_hive_model.dart        # Hive adapter + toEntity/fromEntity
│   └── repositories/
│       ├── transaction_repository_impl.dart
│       ├── budget_repository_impl.dart
│       └── settings_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── transaction.dart         # Transaction, TransactionType, TransactionCategories, CategoryIcon
│   │   └── budget.dart              # Budget, BudgetStatus
│   ├── repositories/
│   │   ├── transaction_repository.dart
│   │   ├── budget_repository.dart
│   │   └── settings_repository.dart
│   └── usecases/
│       ├── transaction_usecases.dart    # 7 use cases
│       ├── budget_usecases.dart         # 8 use cases
│       └── settings_usecases.dart       # 2 use cases
├── presentation/
│   ├── providers/
│   │   ├── transaction_provider.dart
│   │   ├── budget_provider.dart
│   │   └── theme_provider.dart
│   ├── screens/
│   │   ├── dashboard_screen.dart
│   │   ├── transactions_screen.dart
│   │   ├── budgets_screen.dart
│   │   ├── add_transaction_screen.dart
│   │   └── add_budget_screen.dart
│   └── widgets/
│       ├── balance_card.dart
│       ├── expense_chart.dart
│       └── transaction_list_item.dart
└── services/
    └── csv_export_service.dart      # share_plus + CSV generation
```

### State Management

**Choice: Provider (ChangeNotifier)**

- Official Flutter recommendation
- Simple, intuitive API with built-in DI
- Excellent performance for small–medium apps
- Easy testing via mocked repositories

**Providers**
- `TransactionProvider` — Loads all transactions once; exposes `totalIncome`, `totalExpense`, `currentBalance`, `expensesByCategory`, `recentTransactions` (computed synchronously from in-memory list)
- `BudgetProvider` — Lazy-loads budgets per month via `FutureBuilder`; exposes async status/progress helpers
- `ThemeProvider` — Persists `isDarkMode` to Hive settings box

### Local Storage

**Choice: Hive (pure Dart NoSQL)**

- Type-safe with generated adapters (`hive_generator`)
- Offline-first, zero config, cross-platform
- Boxes:
  - `transactions` → `TransactionHiveModel`
  - `budgets` → `BudgetHiveModel`
  - `settings` → key-value (`isDarkMode`)

### Financial Model (Key Hardening)

| Concept | Implementation |
|---------|----------------|
| Money representation | `int` minor units (100 = ₹1.00) |
| Display | `amountInMajorUnits` → `₹100.00` |
| Signed display | `+₹100.00` / `-₹100.00` |
| Calculations | `fold(0, (sum, t) => sum + t.amount)` on `int` — no FP drift |
| Persistence | Hive stores `int` directly |

---

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK **3.19+** (tested on 3.35.7)
- Dart SDK **3.3+**
- Android Studio / VS Code with Flutter extensions
- Android SDK (API 24+) or Xcode (iOS 12+)

### Installation

```bash
# 1. Clone
git clone https://github.com/swatv3nub/FinTrack.git
cd fintrack

# 2. Dependencies
flutter pub get

# 3. Generate Hive adapters (already committed, but run if models change)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run
flutter run                    # Debug
flutter run --release          # Release
flutter run -d <device_id>     # Specific device
```

---

## 🧪 Testing

### Coverage

| Layer | Tests |
|-------|-------|
| **Domain Entities** | Transaction/Budget creation, `copyWith`, formatting, category lists |
| **Widgets** | `BalanceCard`, `TransactionListItem` rendering (light/dark) |
| **Providers** | CRUD, undo delete, balance math, category aggregation |

### Running

```bash
# All tests
flutter test

# With coverage
flutter test --coverage
lcov --summary coverage/lcov.info

# Single suite
flutter test test/models/transaction_entity_test.dart
```

### Test Files

- `test/models/transaction_entity_test.dart`
- `test/models/budget_entity_test.dart`
- `test/widget_test.dart` (widget + provider integration)

---

## 📦 Dependencies

### Production
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1          # State management
  hive: ^2.2.3              # NoSQL database
  hive_flutter: ^1.1.0      # Flutter integration
  path_provider: ^2.1.1     # Temp directory for CSV
  fl_chart: ^0.65.0         # Pie chart
  csv: ^5.1.1               # CSV encoding
  intl: ^0.18.1             # Date formatting
  share_plus: ^12.0.2       # Cross-platform file share
  cupertino_icons: ^1.0.6
  equatable: ^2.1.0         # Entity equality
```

### Dev
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

---

## 🎨 Design System

### Tokens (`core/constants/design_tokens.dart`)

| Category | Values |
|----------|--------|
| **Colors** | Primary `#2E3B7E`, semantic (success/warning/error), surface hierarchy |
| **Spacing** | `xs=4`, `sm=8`, `md=16`, `lg=24`, `xl=32`, `xxl=48` |
| **Radius** | `sm=8`, `md=12`, `lg=16`, `xl=24`, `full=9999` |
| **Elevation** | `none=0`, `low=1`, `medium=3`, `high=6` |
| **Typography** | Material 3 `TextTheme` (Roboto) |
| **Icons** | `xs=16`, `sm=20`, `md=24`, `lg=28`, `xl=32` |
| **Durations** | `fast=150ms`, `medium=300ms`, `slow=500ms` |

### Themes (`core/constants/theme.dart`)

- **Light**: Clean white surfaces, blue primary, subtle shadows
- **Dark**: `#121212` background, `#1E1E1E` surface, blue-primary container
- Both share identical component styling (cards, inputs, buttons, nav bars, dialogs, chips, FABs, progress indicators)

---

## 🔧 Development Commands

```bash
# Format
dart format .

# Static analysis
flutter analyze

# Tests
flutter test

# Build APK
flutter build apk --debug
flutter build apk --release

# Generate adapters (after model changes)
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🧩 Code Quality Standards

- **Immutability**: Entities use `copyWith`; no public setters
- **Equality**: `equatable` for value-based comparison
- **Null Safety**: Full null-safety; no `!` or `late` without justification
- **Linting**: `flutter_lints` + `prefer_const_constructors`, `require_trailing_commas`
- **Formatting**: `dart format` enforced
- **Architecture**: UI never touches Hive; repositories hide data source

---

## 🚧 Known Limitations

| Limitation | Notes |
|------------|-------|
| Single currency | INR hardcoded; `SettingsRepository` has stub for future |
| No cloud sync | Pure local-first; Hive boxes only |
| No recurring transactions | Manual entry only |
| No data import | CSV export only |
| No schema migrations | Hive `typeId` stable; migrations not implemented |
| iOS untested | Android primary target; iOS config exists but unverified |

---

## 🛣️ Roadmap

- [ ] Hive schema migration strategy (versioned boxes)
- [ ] Cloud backup / sync (Firebase / Supabase)
- [ ] Multi-currency with exchange rates
- [ ] Recurring transactions + scheduling
- [ ] Advanced analytics (trends, forecasting, custom ranges)
- [ ] Biometric app lock
- [ ] Full accessibility audit (TalkBack / VoiceOver)
- [ ] CI/CD pipeline (GitHub Actions)
- [ ] Performance profiling on low-end devices
- [ ] Category customization (user-defined)

---

## 📄 License

MIT — see `LICENSE` file.

---

**FinTrack** — Built with Flutter, clean architecture, and attention to financial correctness.