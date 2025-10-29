import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:news_blog_app/core/errors/failures.dart';

/// Base class for all use cases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case that doesn't require parameters
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// Base class for parameters
abstract class Params extends Equatable {
  const Params();
}

/// No parameters class
class NoParams extends Params {
  const NoParams();

  @override
  List<Object?> get props => [];
}
