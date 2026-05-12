import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'data_providers.dart';

part 'balance_provider.g.dart';

@riverpod
class Balance extends _$Balance {
  @override
  Future<double> build() async {
    final repository = ref.watch(fundRepositoryProvider);
    return repository.getUserBalance();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(fundRepositoryProvider).getUserBalance());
  }
}
