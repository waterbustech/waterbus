// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
