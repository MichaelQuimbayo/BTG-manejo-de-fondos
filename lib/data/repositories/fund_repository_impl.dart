import '../../domain/entities/fund.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/i_fund_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/fund_model.dart';
import '../models/transaction_model.dart';

/// Implementación del repositorio de fondos.
/// Se encarga de coordinar el flujo de datos entre la fuente de datos local y el dominio.
class FundRepositoryImpl implements IFundRepository {
  final LocalDataSource localDataSource;

  FundRepositoryImpl(this.localDataSource);

  @override
  Future<List<Fund>> getFunds() async {
    final models = localDataSource.getFunds();
    
    // Inicialización del catálogo con los datos requeridos por la prueba técnica
    // si la base de datos local está vacía.
    if (models.isEmpty) {
      final initialFunds = _getInitialFunds();
      await localDataSource.saveFunds(
        initialFunds.map((f) => FundModel.fromEntity(f)).toList()
      );
      return initialFunds;
    }
    
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<double> getUserBalance() async {
    return localDataSource.getBalance();
  }

  @override
  Future<void> updateUserBalance(double newBalance) async {
    await localDataSource.saveBalance(newBalance);
  }

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    await localDataSource.saveTransaction(TransactionModel.fromEntity(transaction));
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final models = localDataSource.getTransactions();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateFundSubscriptionStatus(String fundId, bool isSubscribed) async {
    await localDataSource.updateFundStatus(fundId, isSubscribed);
  }

  /// Define la lista inicial de fondos según el documento del caso de negocio.
  List<Fund> _getInitialFunds() {
    return [
      const Fund(id: '1', name: 'FPV_BTG_PACTUAL_RECAUDADORA', minimumAmount: 75000, category: FundCategory.fpv),
      const Fund(id: '2', name: 'FPV_BTG_PACTUAL_ECOPETROL', minimumAmount: 125000, category: FundCategory.fpv),
      const Fund(id: '3', name: 'DEUDAPRIVADA', minimumAmount: 50000, category: FundCategory.fic),
      const Fund(id: '4', name: 'FDO-ACCIONES', minimumAmount: 250000, category: FundCategory.fic),
      const Fund(id: '5', name: 'FPV_BTG_PACTUAL_DINAMICA', minimumAmount: 100000, category: FundCategory.fpv),
    ];
  }
}
