import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_study/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_study/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_study/features/number_trivia/domain/usecases/get_trivia_use_case.dart';

void main() {
  late GetTriviaUseCase sut;
  late NumberTriviaRepositoryMock numberTriviaRepositoryMock;

  setUp(() {
    numberTriviaRepositoryMock = NumberTriviaRepositoryMock();
    sut = GetTriviaUseCase(repository: numberTriviaRepositoryMock);
  });

  const testNumber = 1;
  const testTrivia = NumberTrivia(number: testNumber, text: '');

  test('should get trivia for the number sent to the repository', () async {
    // arrange
    when(() => numberTriviaRepositoryMock.getTrivia(any()))
        .thenAnswer((final _) async => const Right(testTrivia));

    // act
    final result = await sut(testNumber);

    // assert
    expect(result, const Right(testTrivia));
    verify(() => numberTriviaRepositoryMock.getTrivia(testNumber));
    verifyNoMoreInteractions(numberTriviaRepositoryMock);
  });

  test('should get a random trivia when null is sent to the repository',
      () async {
    // arrange
    when(() => numberTriviaRepositoryMock.getTrivia(null))
        .thenAnswer((final _) async => const Right(testTrivia));

    // act
    final result = await sut(null);

    // assert
    expect(result, const Right(testTrivia));
    verify(() => numberTriviaRepositoryMock.getTrivia(null));
    verifyNoMoreInteractions(numberTriviaRepositoryMock);
  });
}

class NumberTriviaRepositoryMock extends Mock
    implements NumberTriviaRepository {}
