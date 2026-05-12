import 'package:bgt_manejo_de_fondos/domain/entities/fund.dart';
import 'package:bgt_manejo_de_fondos/domain/entities/transaction_entity.dart';
import 'package:bgt_manejo_de_fondos/domain/repositories/i_fund_repository.dart';
import 'package:bgt_manejo_de_fondos/domain/use_cases/subscribe_to_fund_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockFundRepository extends Mock implements IFundRepository {}

void main() {
  late MockFundRepository mockRepository;
  late SubscribeToFundUseCase useCase;

  setUp(() {
    mockRepository = MockFundRepository();
    useCase = SubscribeToFundUseCase(mockRepository);
    registerFallbackValue(TransactionEntity(
      id: '1',
      fundId: '1',
      fundName: 'Test',
      amount: 0,
      date: DateTime.now(),
      type: TransactionType.subscription,
    ));
  });

  final tFund = Fund(
    id: '1',
    name: 'FPV_BTG_PACTUAL_RECAUDADORA',
    minimumAmount: 75000,
    category: FundCategory.fpv,
  );

  test('should subscribe successfully when balance is sufficient', () async {
    // arrange
    when(() => mockRepository.getUserBalance()).thenAnswer((_) async => 500000);
    when(() => mockRepository.updateUserBalance(any())).thenAnswer((_) async => {});
    when(() => mockRepository.saveTransaction(any())).thenAnswer((_) async => {});
    when(() => mockRepository.updateFundSubscriptionStatus(any(), any())).thenAnswer((_) async => {});

    // act
    await useCase.execute(tFund, NotificationMethod.email);

    // assert
    verify(() => mockRepository.getUserBalance()).called(1);
    verify(() => mockRepository.updateUserBalance(425000)).called(1);
    verify(() => mockRepository.saveTransaction(any())).called(1);
    verify(() => mockRepository.updateFundSubscriptionStatus(tFund.id, true)).called(1);
  });

  test('should throw exception when balance is insufficient (Requirement 6)', () async {
    // arrange
    when(() => mockRepository.getUserBalance()).thenAnswer((_) async => 50000);

    // act
    final call = useCase.execute(tFund, NotificationMethod.sms);

    // assert
    expect(() => call, throwsA(isA<Exception>()));
    expect(
      () => call,
      throwsA(predicate((e) => e.toString().contains('No tiene saldo disponible'))),
    );
    
    verify(() => mockRepository.getUserBalance()).called(1);
    verifyNever(() => mockRepository.updateUserBalance(any()));
    verifyNever(() => mockRepository.saveTransaction(any()));
  });
}
