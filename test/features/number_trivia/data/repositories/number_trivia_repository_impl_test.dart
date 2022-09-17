import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_study/core/platform/network_info.dart';
import 'package:tdd_study/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:tdd_study/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:tdd_study/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

void main() {
  late NumberTriviaRepositoryImpl sut;
  late NumberTriviaLocalDatasource localDatasource;
  late NumberTriviaRemoteDatasource remoteDatasource;
  late NetworkInfo networkInfo;

  setUp(() {
    localDatasource = NumberTriviaLocalDatasourceMock();
    remoteDatasource = NumberTriviaRemoteDatasourceMock();
    networkInfo = NetworkInfoMock();
    sut = NumberTriviaRepositoryImpl(
      localDatasource: localDatasource,
      remoteDatasource: remoteDatasource,
      networkInfo: networkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final testNumber = 1;
    test('should check if the device is online', () async {
      // arrange
      when(() => networkInfo.deviceIsConnected)
          .thenAnswer((final _) async => true);

      // act
      sut.getConcreteNumberTrivia(testNumber);

      // assert
      verify(() => networkInfo.deviceIsConnected);
    });
  });
}

class NumberTriviaLocalDatasourceMock extends Mock
    implements NumberTriviaLocalDatasource {}

class NumberTriviaRemoteDatasourceMock extends Mock
    implements NumberTriviaRemoteDatasource {}

class NetworkInfoMock extends Mock implements NetworkInfo {}
