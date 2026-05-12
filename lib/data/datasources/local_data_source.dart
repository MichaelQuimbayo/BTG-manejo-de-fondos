import 'package:hive_flutter/hive_flutter.dart';
import '../models/fund_model.dart';
import '../models/transaction_model.dart';

class LocalDataSource {
  static const String fundsBoxName = 'funds_box';
  static const String transactionsBoxName = 'transactions_box';
  static const String balanceBoxName = 'balance_box';
  static const String balanceKey = 'user_balance';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(FundModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    
    await Hive.openBox<FundModel>(fundsBoxName);
    await Hive.openBox<TransactionModel>(transactionsBoxName);
    await Hive.openBox<double>(balanceBoxName);
  }

  Box<FundModel> get _fundsBox => Hive.box<FundModel>(fundsBoxName);
  Box<TransactionModel> get _transactionsBox => Hive.box<TransactionModel>(transactionsBoxName);
  Box<double> get _balanceBox => Hive.box<double>(balanceBoxName);

  List<FundModel> getFunds() {
    return _fundsBox.values.toList();
  }

  Future<void> saveFunds(List<FundModel> funds) async {
    final Map<String, FundModel> fundsMap = {
      for (var fund in funds) fund.id: fund,
    };
    await _fundsBox.putAll(fundsMap);
  }

  Future<void> updateFundStatus(String fundId, bool isSubscribed) async {
    final fund = _fundsBox.get(fundId);
    if (fund != null) {
      final updatedFund = FundModel(
        id: fund.id,
        name: fund.name,
        minimumAmount: fund.minimumAmount,
        category: fund.category,
        isSubscribed: isSubscribed,
      );
      await _fundsBox.put(fundId, updatedFund);
    }
  }

  double getBalance() {
    return _balanceBox.get(balanceKey, defaultValue: 500000.0) ?? 500000.0;
  }

  Future<void> saveBalance(double balance) async {
    await _balanceBox.put(balanceKey, balance);
  }

  Future<void> saveTransaction(TransactionModel transaction) async {
    await _transactionsBox.add(transaction);
  }

  List<TransactionModel> getTransactions() {
    return _transactionsBox.values.toList().reversed.toList();
  }
}
