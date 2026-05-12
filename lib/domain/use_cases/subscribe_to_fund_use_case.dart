import '../entities/fund.dart';
import '../entities/transaction_entity.dart';
import '../repositories/i_fund_repository.dart';

/// Caso de uso para gestionar la suscripción de un usuario a un fondo.
/// Contiene la lógica de validación de saldo y creación de transacciones.
class SubscribeToFundUseCase {
  final IFundRepository repository;

  SubscribeToFundUseCase(this.repository);

  /// Ejecuta la lógica de suscripción.
  /// 1. Verifica si el usuario tiene saldo suficiente (monto mínimo del fondo).
  /// 2. Descuenta el monto del saldo total.
  /// 3. Crea y guarda el registro de la transacción.
  /// 4. Actualiza el estado de suscripción del fondo.
  /// 
  /// Lanza una [Exception] si el saldo es insuficiente.
  Future<void> execute(Fund fund, NotificationMethod notification) async {
    final balance = await repository.getUserBalance();

    // Requisito funcional: Validar saldo suficiente según el monto mínimo
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
