import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'data_providers.dart';

part 'balance_provider.g.dart';

/// Provider encargado de gestionar el estado del saldo del usuario.
/// Utiliza [riverpod_annotation] para la generación automática de código.
@riverpod
class Balance extends _$Balance {
  /// Inicializa el estado obteniendo el saldo desde el repositorio.
  @override
  Future<double> build() async {
    final repository = ref.watch(fundRepositoryProvider);
    return repository.getUserBalance();
  }

  /// Fuerza una actualización del saldo leyendo directamente del repositorio.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(fundRepositoryProvider).getUserBalance());
  }
}
