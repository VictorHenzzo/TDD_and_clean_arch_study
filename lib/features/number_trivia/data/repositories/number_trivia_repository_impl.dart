import 'package:tdd_study/core/error/exceptions.dart';
import 'package:tdd_study/core/platform/network_info.dart';
import 'package:tdd_study/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:tdd_study/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:tdd_study/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_study/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_study/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NetworkInfo networkInfo;
  final NumberTriviaLocalDatasource localDatasource;
  final NumberTriviaRemoteDatasource remoteDatasource;

  NumberTriviaRepositoryImpl({
    required this.networkInfo,
    required this.localDatasource,
    required this.remoteDatasource,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    if (await networkInfo.deviceIsConnected) {
      try {
        final result = await remoteDatasource.getConcreteNumberTrivia(number);

        localDatasource.cacheNumberTrivia(result);

        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final result = await localDatasource.getLastNumberTrivia();

        return Right(result);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
