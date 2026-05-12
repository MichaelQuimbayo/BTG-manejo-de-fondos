import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/transaction_entity.dart';
import 'data_providers.dart';

part 'history_provider.g.dart';

/// Notifier encargado de gestionar el estado del historial de transacciones.
@riverpod
class History extends _$History {
  /// Inicializa el estado cargando el historial desde el caso de uso correspondiente.
  @override
  Future<List<TransactionEntity>> build() async {
    final useCase = ref.watch(getHistoryUseCaseProvider);
    return useCase.execute();
  }
}
