import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/transaction_entity.dart';
import 'data_providers.dart';

part 'history_provider.g.dart';

@riverpod
class History extends _$History {
  @override
  Future<List<TransactionEntity>> build() async {
    final useCase = ref.watch(getHistoryUseCaseProvider);
    return useCase.execute();
  }
}
