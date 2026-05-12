import '../entities/fund.dart';
import '../entities/transaction_entity.dart';

abstract class IFundRepository {
  Future<List<Fund>> getFunds();
  Future<double> getUserBalance();
  Future<void> updateUserBalance(double newBalance);
  Future<void> saveTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>> getTransactions();
  Future<void> updateFundSubscriptionStatus(String fundId, bool isSubscribed);
}
