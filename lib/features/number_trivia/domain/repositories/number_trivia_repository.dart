import 'package:dartz/dartz.dart';
import 'package:tdd_study/core/error/failures.dart';
import 'package:tdd_study/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getTrivia(int? number);
}
