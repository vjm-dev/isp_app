import 'package:dartz/dartz.dart';
import 'package:isp_app/core/error/failures.dart';
import 'package:isp_app/domain/entities/user.dart';
import 'package:isp_app/domain/repositories/user_repository.dart';

class GetUserData {
  final UserRepository repository;

  GetUserData(this.repository);

  Future<Either<Failure, User>> call(String userId) async {
    return await repository.getUserData(userId);
  }
}