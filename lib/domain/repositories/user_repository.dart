import 'package:dartz/dartz.dart';
import 'package:isp_app/core/error/failures.dart';
import 'package:isp_app/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserData(String userId);
}