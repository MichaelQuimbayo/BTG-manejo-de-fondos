import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/transaction_entity.dart';
import 'balance_provider.dart';
import 'data_providers.dart';
import 'history_provider.dart';

part 'fund_providers.g.dart';

/// Notifier encargado de gestionar la lista de fondos y las operaciones de vinculación/desvinculación.
@riverpod
class Funds extends _$Funds {
  /// Inicializa el estado cargando la lista de fondos desde el repositorio.
  @override
  Future<List<Fund>> build() async {
    final repository = ref.watch(fundRepositoryProvider);
    return repository.getFunds();
  }

  /// Realiza la suscripción a un fondo.
  /// 1. Cambia el estado a 'loading'.
  /// 2. Ejecuta el caso de uso de suscripción.
  /// 3. Invalida los estados de saldo e historial para forzar su recarga.
  /// 4. Actualiza la lista de fondos con el nuevo estado de suscripción.
  Future<void> subscribe(Fund fund, NotificationMethod method) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(subscribeToFundUseCaseProvider);
      await useCase.execute(fund, method);
      
      // Actualizamos los otros estados dependientes
      ref.invalidate(balanceProvider);
      ref.invalidate(historyProvider);
      
      // Refrescamos la lista de fondos para reflejar el cambio en la UI
      state = AsyncValue.data(await ref.read(fundRepositoryProvider).getFunds());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Realiza la cancelación de la suscripción a un fondo.
  /// Sigue un flujo similar a [subscribe] para actualizar los estados globales.
  Future<void> cancelSubscription(Fund fund) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(cancelFundUseCaseProvider);
      await useCase.execute(fund);
      
      ref.invalidate(balanceProvider);
      ref.invalidate(historyProvider);
      
      state = AsyncValue.data(await ref.read(fundRepositoryProvider).getFunds());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
