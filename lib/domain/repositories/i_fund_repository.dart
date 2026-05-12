import '../entities/fund.dart';
import '../entities/transaction_entity.dart';

/// Interfaz que define las operaciones necesarias para gestionar fondos y transacciones.
/// Sigue el principio de Inversión de Dependencias (D de SOLID).
abstract class IFundRepository {
  /// Obtiene la lista de todos los fondos disponibles.
  Future<List<Fund>> getFunds();
  
  /// Recupera el saldo actual del usuario.
  Future<double> getUserBalance();
  
  /// Actualiza el saldo del usuario tras una operación.
  Future<void> updateUserBalance(double newBalance);
  
  /// Registra una nueva transacción en el historial.
  Future<void> saveTransaction(TransactionEntity transaction);
  
  /// Obtiene el historial completo de transacciones realizadas.
  Future<List<TransactionEntity>> getTransactions();
  
  /// Actualiza el estado de suscripción de un fondo específico en la persistencia.
  Future<void> updateFundSubscriptionStatus(String fundId, bool isSubscribed);
}
