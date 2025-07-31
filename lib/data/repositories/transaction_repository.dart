import '../models/transaction.dart';
import '../../main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class TransactionRepository {
  final Isar _isar;

  TransactionRepository(this._isar);

  Future<void> saveTransaction(Transaction newTransaction) async {
    await _isar.writeTxn(() async {
      await _isar.transactions.put(newTransaction);
    });
  }

  Stream<List<Transaction>> watchAllTransactions() {
    return _isar.transactions.where().watch(fireImmediately: true);
  }
}

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  return TransactionRepository(isarService.db as Isar);
});
