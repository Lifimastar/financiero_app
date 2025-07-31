import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/category.dart';
import '../../../../data/models/transaction.dart';
import '../../../../data/repositories/transaction_repository.dart';
import 'package:intl/intl.dart';

final transactionTypeProvider = StateProvider<CategoryType>(
  (ref) => CategoryType.expense,
);

class AddEditTransactionScreen extends ConsumerStatefulWidget {
  const AddEditTransactionScreen({super.key});

  @override
  ConsumerState<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState
    extends ConsumerState<AddEditTransactionScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, introduce un importe válido.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newTransaction = Transaction()
      ..amount = amount
      ..description = _descriptionController.text
      ..date = _selectedDate;
    // TODO: Asignar la categoria seleccionada

    await ref
        .read(transactionRepositoryProvider)
        .saveTransaction(newTransaction);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionType = ref.watch(transactionTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CAMPO DE MONTO
            TextField(
              controller: _amountController,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              decoration: const InputDecoration(
                prefixText: '\$',
                prefixStyle: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondaryColor,
                ),
                hintText: '0.00',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 24),

            // DESCRIPCION
            _buildSectionLabel('Description'),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'e.g., Coffee with friends',
              ),
            ),
            const SizedBox(height: 24),

            // FECHA
            _buildSectionLabel('Date'),
            const SizedBox(height: 8),
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: DateFormat('yyyy-MM-dd').format(_selectedDate),
              ),
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // CATEGORIA
            _buildSectionLabel('Category'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(),
              value: 'Food & Drink',
              items: ['Food & Drink', 'Shopping', 'Transport'].map((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),

            // TIPO DE TRANSACCION
            _buildSectionLabel('Transaction Type'),
            const SizedBox(height: 8),
            _buildTransactionTypeSelector(context, ref),
          ],
        ),
      ),
      // BOTONES INFERIORES
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSectionLabel(String text) => Text(
  text,
  style: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppTheme.textSecondaryColor,
  ),
);

Widget _buildTransactionTypeSelector(BuildContext context, WidgetRef ref) {
  final selectedType = ref.watch(transactionTypeProvider);
  return Container(
    decoration: BoxDecoration(
      color: AppTheme.inputBackgroundColor,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => ref.read(transactionTypeProvider.notifier).state =
                CategoryType.expense,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: selectedType == CategoryType.expense
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                        ),
                      ],
                    )
                  : null,
              child: Center(
                child: Text(
                  'Expense',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selectedType == CategoryType.expense
                        ? AppTheme.textPrimaryColor
                        : AppTheme.textSecondaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => ref.read(transactionTypeProvider.notifier).state =
                CategoryType.income,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: selectedType == CategoryType.income
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                        ),
                      ],
                    )
                  : null,
              child: Center(
                child: Text(
                  'Income',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selectedType == CategoryType.income
                        ? AppTheme.textPrimaryColor
                        : AppTheme.textSecondaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
