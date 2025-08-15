import 'package:dartz/dartz.dart';
import 'package:isp_app/core/error/failures.dart';
import 'package:isp_app/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> checkAuthStatus();
}