import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_study/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_study/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_study/features/number_trivia/domain/usecases/get_random_number_trivia_use_case.dart';

void main() {
  late GetRandomNumberTriviaUseCase sut;
  late NumberTriviaRepositoryMock numberTriviaRepositoryMock;

  setUp(() {
    numberTriviaRepositoryMock = NumberTriviaRepositoryMock();
    sut = GetRandomNumberTriviaUseCase(repository: numberTriviaRepositoryMock);
  });

  const testTrivia = NumberTrivia(number: 1, text: '');

  test('should get a random trivia from the repository', () async {
    // arrange
    when(() => numberTriviaRepositoryMock.getRandomNumberTrivia())
        .thenAnswer((final _) async => const Right(testTrivia));

    // act
    final result = await sut();

    // assert
    expect(result, const Right(testTrivia));
    verify(() => numberTriviaRepositoryMock.getRandomNumberTrivia());
    verifyNoMoreInteractions(numberTriviaRepositoryMock);
  });
}

class NumberTriviaRepositoryMock extends Mock
    implements NumberTriviaRepository {}
