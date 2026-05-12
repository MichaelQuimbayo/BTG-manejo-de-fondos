import '../entities/fund.dart';
import '../entities/transaction_entity.dart';
import '../repositories/i_fund_repository.dart';

class CancelFundUseCase {
  final IFundRepository repository;

  CancelFundUseCase(this.repository);

  Future<void> execute(Fund fund) async {
    final balance = await repository.getUserBalance();
    final newBalance = balance + fund.minimumAmount;

    await repository.updateUserBalance(newBalance);

    final transaction = TransactionEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fundId: fund.id,
      fundName: fund.name,
      amount: fund.minimumAmount,
      date: DateTime.now(),
      type: TransactionType.cancellation,
      notificationMethod: NotificationMethod.none,
    );

    await repository.saveTransaction(transaction);
    await repository.updateFundSubscriptionStatus(fund.id, false);
  }
}
