import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_study/core/error/exceptions.dart';
import 'package:tdd_study/core/error/failures.dart';
import 'package:tdd_study/core/platform/network_info.dart';
import 'package:tdd_study/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:tdd_study/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:tdd_study/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_study/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

void main() {
  late NumberTriviaRepositoryImpl sut;
  late NumberTriviaLocalDatasource localDatasource;
  late NumberTriviaRemoteDatasource remoteDatasource;
  late NetworkInfo networkInfo;
  late int testNumber;
  late NumberTriviaModel testNumberTriviaModel;

  setUp(() {
    localDatasource = NumberTriviaLocalDatasourceMock();
    remoteDatasource = NumberTriviaRemoteDatasourceMock();
    networkInfo = NetworkInfoMock();
    sut = NumberTriviaRepositoryImpl(
      localDatasource: localDatasource,
      remoteDatasource: remoteDatasource,
      networkInfo: networkInfo,
    );

    testNumber = 1;
    testNumberTriviaModel =
        const NumberTriviaModel(number: 1, text: 'Test text');
  });

  group('getConcreteNumberTrivia', () {
    const testNumber = 1;
    const testNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'Test text');

    test('should check if the device is online', () async {
      // arrange
      when(() => networkInfo.deviceIsConnected)
          .thenAnswer((final _) async => true);
      when(() => localDatasource.cacheNumberTrivia(testNumberTriviaModel))
          .thenAnswer((final _) async => true);
      when(() => remoteDatasource.getConcreteNumberTrivia(testNumber))
          .thenAnswer((final _) async => testNumberTriviaModel);

      // act
      sut.getConcreteNumberTrivia(testNumber);

      // assert
      verify(() => networkInfo.deviceIsConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => networkInfo.deviceIsConnected)
            .thenAnswer((final _) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful, and then should cache the data locally',
          () async {
        // arrange
        when(() => remoteDatasource.getConcreteNumberTrivia(testNumber))
            .thenAnswer((final _) async => testNumberTriviaModel);
        when(() => localDatasource.cacheNumberTrivia(testNumberTriviaModel))
            .thenAnswer((final _) async => true);

        // act
        final result = await sut.getConcreteNumberTrivia(testNumber);

        // assert
        verify(() => remoteDatasource.getConcreteNumberTrivia(testNumber));
        verify(() => localDatasource.cacheNumberTrivia(testNumberTriviaModel));
        expect(result, equals(const Right(testNumberTriviaModel)));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(() => remoteDatasource.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());

        // act
        final result = await sut.getConcreteNumberTrivia(testNumber);

        // assert
        verify(() => remoteDatasource.getConcreteNumberTrivia(testNumber));
        verifyZeroInteractions(localDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => networkInfo.deviceIsConnected)
            .thenAnswer((final _) async => false);
      });

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        when(() => localDatasource.getLastNumberTrivia())
            .thenAnswer((final _) async => testNumberTriviaModel);

        // act
        final result = await sut.getConcreteNumberTrivia(testNumber);

        // assert
        verifyZeroInteractions(remoteDatasource);
        verify(() => localDatasource.getLastNumberTrivia());
        expect(result, equals(const Right(testNumberTriviaModel)));
      });

      test('should return cache failure when there is no cached data present',
          () async {
        // arrange
        when(() => localDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await sut.getConcreteNumberTrivia(testNumber);

        // assert
        verifyZeroInteractions(remoteDatasource);
        verify(() => localDatasource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    test('should check if the device is online', () async {
      // arrange
      when(() => networkInfo.deviceIsConnected)
          .thenAnswer((final _) async => true);
      when(() => localDatasource.cacheNumberTrivia(testNumberTriviaModel))
          .thenAnswer((final _) async => true);
      when(() => remoteDatasource.getRandomNumberTrivia())
          .thenAnswer((final _) async => testNumberTriviaModel);

      // act
      sut.getRandomNumberTrivia();

      // assert
      verify(() => networkInfo.deviceIsConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => networkInfo.deviceIsConnected)
            .thenAnswer((final _) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful, and then should cache the data locally',
          () async {
        // arrange
        when(() => remoteDatasource.getRandomNumberTrivia())
            .thenAnswer((final _) async => testNumberTriviaModel);
        when(() => localDatasource.cacheNumberTrivia(testNumberTriviaModel))
            .thenAnswer((final _) async => true);

        // act
        final result = await sut.getRandomNumberTrivia();

        // assert
        verify(() => remoteDatasource.getRandomNumberTrivia());
        verify(() => localDatasource.cacheNumberTrivia(testNumberTriviaModel));
        expect(result, equals(Right(testNumberTriviaModel)));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(() => remoteDatasource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        // act
        final result = await sut.getRandomNumberTrivia();

        // assert
        verify(() => remoteDatasource.getRandomNumberTrivia());
        verifyZeroInteractions(localDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => networkInfo.deviceIsConnected)
            .thenAnswer((final _) async => false);
      });

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        when(() => localDatasource.getLastNumberTrivia())
            .thenAnswer((final _) async => testNumberTriviaModel);

        // act
        final result = await sut.getRandomNumberTrivia();

        // assert
        verifyZeroInteractions(remoteDatasource);
        verify(() => localDatasource.getLastNumberTrivia());
        expect(result, equals(Right(testNumberTriviaModel)));
      });

      test('should return cache failure when there is no cached data present',
          () async {
        // arrange
        when(() => localDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await sut.getRandomNumberTrivia();

        // assert
        verifyZeroInteractions(remoteDatasource);
        verify(() => localDatasource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}

class NumberTriviaLocalDatasourceMock extends Mock
    implements NumberTriviaLocalDatasource {}

class NumberTriviaRemoteDatasourceMock extends Mock
    implements NumberTriviaRemoteDatasource {}

class NetworkInfoMock extends Mock implements NetworkInfo {}
