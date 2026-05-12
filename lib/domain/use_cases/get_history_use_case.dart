import '../entities/transaction_entity.dart';
import '../repositories/i_fund_repository.dart';

class GetHistoryUseCase {
  final IFundRepository repository;

  GetHistoryUseCase(this.repository);

  Future<List<TransactionEntity>> execute() async {
    return await repository.getTransactions();
  }
}
