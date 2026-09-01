import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/transaction.dart';

class AddBudgetScreen extends StatefulWidget {
  final Budget? budget;
  final int month;
  final int year;

  const AddBudgetScreen({
    super.key,
    this.budget,
    required this.month,
    required this.year,
  });

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  late String _selectedCategory;

  bool get _isEditing => widget.budget != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _amountController.text = widget.budget!.amountInMajorUnits.toStringAsFixed(2);
      _selectedCategory = widget.budget!.category;
    } else {
      _selectedCategory = TransactionCategories.expenseCategories.first;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveBudget() async {
    if (_formKey.currentState!.validate()) {
      final budgetProvider = Provider.of<BudgetProvider>(
        context,
        listen: false,
      );

      // Check if budget already exists for this category and month
      if (!_isEditing) {
        final existingBudget = await budgetProvider.getBudgetForCategory(
          _selectedCategory,
          widget.month,
          widget.year,
        );
        if (existingBudget != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Budget already exists for this category'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      final amount = double.parse(_amountController.text.trim());
      final amountInMinorUnits = (amount * 100).round();

      final budget = Budget(
        id: _isEditing ? widget.budget!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        category: _selectedCategory,
        amount: amountInMinorUnits,
        month: widget.month,
        year: widget.year,
      );

      if (_isEditing) {
        await budgetProvider.updateBudget(budget);
      } else {
        await budgetProvider.addBudget(budget);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Budget updated successfully'
                  : 'Budget added successfully',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Budget' : 'Add Budget'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Category
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category_rounded),
              ),
              items: TransactionCategories.expenseCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: _isEditing
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
            ),
            const SizedBox(height: 16),

            // Amount
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Budget Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money_rounded),
                helperText: 'Set your monthly budget for this category',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a budget amount';
                }
                final amount = double.tryParse(value.trim());
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _saveBudget,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _isEditing ? 'UPDATE BUDGET' : 'ADD BUDGET',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}