import 'package:hive_flutter/hive_flutter.dart';
import '../models/fund_model.dart';
import '../models/transaction_model.dart';

/// Fuente de datos local que utiliza Hive para la persistencia.
/// Se encarga del almacenamiento físico de los fondos, transacciones y el saldo.
class LocalDataSource {
  static const String fundsBoxName = 'funds_box';
  static const String transactionsBoxName = 'transactions_box';
  static const String balanceBoxName = 'balance_box';
  static const String balanceKey = 'user_balance';

  /// Inicializa Hive y registra los adaptadores necesarios para los modelos.
  /// Abre las cajas (boxes) para cada tipo de dato.
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(FundModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    
    await Hive.openBox<FundModel>(fundsBoxName);
    await Hive.openBox<TransactionModel>(transactionsBoxName);
    await Hive.openBox<double>(balanceBoxName);
  }

  // Getters para acceder a las cajas de Hive
  Box<FundModel> get _fundsBox => Hive.box<FundModel>(fundsBoxName);
  Box<TransactionModel> get _transactionsBox => Hive.box<TransactionModel>(transactionsBoxName);
  Box<double> get _balanceBox => Hive.box<double>(balanceBoxName);

  /// Recupera todos los fondos almacenados localmente.
  List<FundModel> getFunds() {
    return _fundsBox.values.toList();
  }

  /// Guarda una lista de fondos en la base de datos local.
  Future<void> saveFunds(List<FundModel> funds) async {
    final Map<String, FundModel> fundsMap = {
      for (var fund in funds) fund.id: fund,
    };
    await _fundsBox.putAll(fundsMap);
  }

  /// Actualiza el estado de suscripción de un fondo específico.
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

  /// Recupera el saldo del usuario. Si no existe, retorna el valor inicial de 500.000.
  double getBalance() {
    return _balanceBox.get(balanceKey, defaultValue: 500000.0) ?? 500000.0;
  }

  /// Persiste el nuevo saldo del usuario.
  Future<void> saveBalance(double balance) async {
    await _balanceBox.put(balanceKey, balance);
  }

  /// Agrega una nueva transacción al historial local.
  Future<void> saveTransaction(TransactionModel transaction) async {
    await _transactionsBox.add(transaction);
  }

  /// Retorna la lista de transacciones en orden descendente (la más reciente primero).
  List<TransactionModel> getTransactions() {
    return _transactionsBox.values.toList().reversed.toList();
  }
}
