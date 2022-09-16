import 'package:dartz/dartz.dart';
import 'package:tdd_study/core/error/failures.dart';
import 'package:tdd_study/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_study/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUseCase {
  GetConcreteNumberTriviaUseCase({required this.repository});

  final NumberTriviaRepository repository;

  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
