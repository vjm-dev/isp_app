import 'package:dartz/dartz.dart';
import 'package:isp_app/core/error/failures.dart';
import 'package:isp_app/core/utils/cache_handlers.dart';
import 'package:isp_app/data/models/datasources/local/local_data_source.dart';
import 'package:isp_app/data/models/datasources/remote/remote_data_source.dart';
import 'package:isp_app/domain/entities/user.dart';
import 'package:isp_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> getUserData(String userId) async {
    try {
      // First: try to get from the cache
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null && cachedUser.id == userId && !CacheHandlers.isCacheExpired(cachedUser)) {
        return Right(cachedUser.toEntity());
      }
      
      // If it isn't cached or is different, call the server
      final userModel = await remoteDataSource.getUserData(userId);
      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}