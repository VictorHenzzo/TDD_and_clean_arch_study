import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_study/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_study/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_study/features/number_trivia/domain/usecases/get_concrete_number_trivia_use_case.dart';

void main() {
  late GetConcreteNumberTriviaUseCase sut;
  late NumberTriviaRepositoryMock numberTriviaRepositoryMock;

  setUp(() {
    numberTriviaRepositoryMock = NumberTriviaRepositoryMock();
    sut =
        GetConcreteNumberTriviaUseCase(repository: numberTriviaRepositoryMock);
  });

  const testNumber = 1;
  const testTrivia = NumberTrivia(number: testNumber, text: '');

  test('should get trivia for the number sent to the repository', () async {
    // arrange
    when(() => numberTriviaRepositoryMock.getConcreteNumberTrivia(any()))
        .thenAnswer((final _) async => const Right(testTrivia));

    // act
    final result = await sut.getConcreteNumberTrivia(testNumber);

    // assert
    expect(result, const Right(testTrivia));
    verify(
        () => numberTriviaRepositoryMock.getConcreteNumberTrivia(testNumber));
    verifyNoMoreInteractions(numberTriviaRepositoryMock);
  });
}

class NumberTriviaRepositoryMock extends Mock
    implements NumberTriviaRepository {}
