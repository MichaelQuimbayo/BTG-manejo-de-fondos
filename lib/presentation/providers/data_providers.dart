import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/fund_repository_impl.dart';
import '../../domain/repositories/i_fund_repository.dart';
import '../../domain/use_cases/subscribe_to_fund_use_case.dart';
import '../../domain/use_cases/cancel_fund_use_case.dart';
import '../../domain/use_cases/get_history_use_case.dart';

part 'data_providers.g.dart';

@Riverpod(keepAlive: true)
LocalDataSource localDataSource(LocalDataSourceRef ref) {
  return LocalDataSource();
}

@Riverpod(keepAlive: true)
IFundRepository fundRepository(FundRepositoryRef ref) {
  final dataSource = ref.watch(localDataSourceProvider);
  return FundRepositoryImpl(dataSource);
}

@riverpod
SubscribeToFundUseCase subscribeToFundUseCase(SubscribeToFundUseCaseRef ref) {
  final repository = ref.watch(fundRepositoryProvider);
  return SubscribeToFundUseCase(repository);
}

@riverpod
CancelFundUseCase cancelFundUseCase(CancelFundUseCaseRef ref) {
  final repository = ref.watch(fundRepositoryProvider);
  return CancelFundUseCase(repository);
}

@riverpod
GetHistoryUseCase getHistoryUseCase(GetHistoryUseCaseRef ref) {
  final repository = ref.watch(fundRepositoryProvider);
  return GetHistoryUseCase(repository);
}
