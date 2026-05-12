import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/transaction_entity.dart';
import 'balance_provider.dart';
import 'data_providers.dart';
import 'history_provider.dart';

part 'fund_providers.g.dart';

@riverpod
class Funds extends _$Funds {
  @override
  Future<List<Fund>> build() async {
    final repository = ref.watch(fundRepositoryProvider);
    return repository.getFunds();
  }

  Future<void> subscribe(Fund fund, NotificationMethod method) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(subscribeToFundUseCaseProvider);
      await useCase.execute(fund, method);
      
      // Actualizamos los otros estados
      ref.invalidate(balanceProvider);
      ref.invalidate(historyProvider);
      
      // Refrescamos la lista de fondos
      state = AsyncValue.data(await ref.read(fundRepositoryProvider).getFunds());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

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
