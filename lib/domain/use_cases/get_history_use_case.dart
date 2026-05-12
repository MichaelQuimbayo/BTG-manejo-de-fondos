import '../entities/transaction_entity.dart';
import '../repositories/i_fund_repository.dart';

/// Caso de uso encargado de obtener el historial de transacciones.
class GetHistoryUseCase {
  final IFundRepository repository;

  GetHistoryUseCase(this.repository);

  /// Recupera la lista de transacciones desde el repositorio.
  Future<List<TransactionEntity>> execute() async {
    return await repository.getTransactions();
  }
}
