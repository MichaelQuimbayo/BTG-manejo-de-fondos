// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localDataSourceHash() => r'20d32e98797b5791295e8e847d079633e6605a91';

@ProviderFor(localDataSource)
final localDataSourceProvider = Provider<LocalDataSource>.internal(
  localDataSource,
  name: r'localDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalDataSourceRef = ProviderRef<LocalDataSource>;
String _$fundRepositoryHash() => r'240e104e76941a0295e8e847d079633e6605a91';

@ProviderFor(fundRepository)
final fundRepositoryProvider = Provider<IFundRepository>.internal(
  fundRepository,
  name: r'fundRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fundRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FundRepositoryRef = ProviderRef<IFundRepository>;
String _$subscribeToFundUseCaseHash() => r'30d32e98797b5791295e8e847d079633e6605a91';

@ProviderFor(subscribeToFundUseCase)
final subscribeToFundUseCaseProvider = AutoDisposeProvider<SubscribeToFundUseCase>.internal(
  subscribeToFundUseCase,
  name: r'subscribeToFundUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscribeToFundUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SubscribeToFundUseCaseRef = AutoDisposeProviderRef<SubscribeToFundUseCase>;
String _$cancelFundUseCaseHash() => r'40d32e98797b5791295e8e847d079633e6605a91';

@ProviderFor(cancelFundUseCase)
final cancelFundUseCaseProvider = AutoDisposeProvider<CancelFundUseCase>.internal(
  cancelFundUseCase,
  name: r'cancelFundUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cancelFundUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CancelFundUseCaseRef = AutoDisposeProviderRef<CancelFundUseCase>;
String _$getHistoryUseCaseHash() => r'50d32e98797b5791295e8e847d079633e6605a91';

@ProviderFor(getHistoryUseCase)
final getHistoryUseCaseProvider = AutoDisposeProvider<GetHistoryUseCase>.internal(
  getHistoryUseCase,
  name: r'getHistoryUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getHistoryUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetHistoryUseCaseRef = AutoDisposeProviderRef<GetHistoryUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
