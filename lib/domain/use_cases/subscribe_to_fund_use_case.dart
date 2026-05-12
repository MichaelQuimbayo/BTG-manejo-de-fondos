import '../entities/fund.dart';
import '../entities/transaction_entity.dart';
import '../repositories/i_fund_repository.dart';

class SubscribeToFundUseCase {
  final IFundRepository repository;

  SubscribeToFundUseCase(this.repository);

  Future<void> execute(Fund fund, NotificationMethod notification) async {
    final balance = await repository.getUserBalance();

    if (balance < fund.minimumAmount) {
      throw Exception('No tiene saldo disponible para vincularse al fondo ${fund.name}');
    }

    final newBalance = balance - fund.minimumAmount;
    await repository.updateUserBalance(newBalance);

    final transaction = TransactionEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fundId: fund.id,
      fundName: fund.name,
      amount: fund.minimumAmount,
      date: DateTime.now(),
      type: TransactionType.subscription,
      notificationMethod: notification,
    );

    await repository.saveTransaction(transaction);
    await repository.updateFundSubscriptionStatus(fund.id, true);
  }
}
