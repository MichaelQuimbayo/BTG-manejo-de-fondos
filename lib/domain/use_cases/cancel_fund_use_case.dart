import '../entities/fund.dart';
import '../entities/transaction_entity.dart';
import '../repositories/i_fund_repository.dart';

/// Caso de uso para gestionar la cancelación de la suscripción a un fondo.
/// Se encarga de devolver el dinero al saldo del usuario y registrar el evento.
class CancelFundUseCase {
  final IFundRepository repository;

  CancelFundUseCase(this.repository);

  /// Ejecuta la lógica de cancelación de suscripción.
  /// 1. Obtiene el saldo actual y le suma el monto que estaba invertido en el fondo.
  /// 2. Actualiza el saldo en el repositorio.
  /// 3. Crea un registro de tipo 'cancellation' en el historial.
  /// 4. Cambia el estado del fondo a 'no suscrito'.
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
