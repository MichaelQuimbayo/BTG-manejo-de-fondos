import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/fund_repository_impl.dart';
import '../../domain/repositories/i_fund_repository.dart';
import '../../domain/use_cases/subscribe_to_fund_use_case.dart';
import '../../domain/use_cases/cancel_fund_use_case.dart';
import '../../domain/use_cases/get_history_use_case.dart';

part 'data_providers.g.dart';

/// Provee la instancia de la fuente de datos local.
/// Se mantiene viva (keepAlive) para evitar reinicializaciones costosas de Hive.
@Riverpod(keepAlive: true)
LocalDataSource localDataSource(LocalDataSourceRef ref) {
  return LocalDataSource();
}

/// Provee la implementación del repositorio de fondos.
@Riverpod(keepAlive: true)
IFundRepository fundRepository(FundRepositoryRef ref) {
  final dataSource = ref.watch(localDataSourceProvider);
  return FundRepositoryImpl(dataSource);
}

/// Provee el caso de uso para suscribirse a un fondo.
@riverpod
SubscribeToFundUseCase subscribeToFundUseCase(SubscribeToFundUseCaseRef ref) {
  final repository = ref.watch(fundRepositoryProvider);
  return SubscribeToFundUseCase(repository);
}

/// Provee el caso de uso para cancelar una suscripción.
@riverpod
CancelFundUseCase cancelFundUseCase(CancelFundUseCaseRef ref) {
  final repository = ref.watch(fundRepositoryProvider);
  return CancelFundUseCase(repository);
}

/// Provee el caso de uso para obtener el historial de transacciones.
@riverpod
GetHistoryUseCase getHistoryUseCase(GetHistoryUseCaseRef ref) {
  final repository = ref.watch(fundRepositoryProvider);
  return GetHistoryUseCase(repository);
}
