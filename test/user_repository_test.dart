import 'package:flutter_test/flutter_test.dart';
import 'package:isp_app/core/error/failures.dart';
import 'package:isp_app/data/models/datasources/local/local_data_source.dart';
import 'package:isp_app/data/models/datasources/remote/remote_data_source.dart';
import 'package:isp_app/data/models/user_model.dart';
import 'package:isp_app/domain/repositories/user_repository_impl.dart';

class FakeRemoteDataSource implements RemoteDataSource {
  UserModel? userToReturn;
  Exception? errorToThrow;
  bool shouldDelay = true;

  @override
  Future<UserModel> getUserData(String userId) async {
    if (shouldDelay) await Future.delayed(const Duration(milliseconds: 10));
    if (errorToThrow != null) throw errorToThrow!;
    
    return userToReturn ?? UserModel(
      id: userId,
      name: 'Fake User',
      email: 'fake@test.com',
      phone: '+1234567890',
      planName: 'Fake Plan',
      monthlyPayment: 49.99,
      dataUsage: 250.0,
      dataLimit: 1000.0,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<UserModel> login(String email, String password) {
    throw UnimplementedError();
  }
}

class FakeLocalDataSource implements LocalDataSource {
  UserModel? cachedUser;

  @override
  Future<void> cacheUser(UserModel user) async {
    cachedUser = user;
  }

  @override
  Future<UserModel?> getCachedUser() async => cachedUser;

  @override
  Future<void> clearCache() async {
    cachedUser = null;
  }
}

void main() {
  late UserRepositoryImpl repository;
  late FakeRemoteDataSource fakeRemoteDataSource;
  late FakeLocalDataSource fakeLocalDataSource;

  setUp(() {
    fakeRemoteDataSource = FakeRemoteDataSource();
    fakeLocalDataSource = FakeLocalDataSource();
    repository = UserRepositoryImpl(
      remoteDataSource: fakeRemoteDataSource,
      localDataSource: fakeLocalDataSource,
    );
  });

  group('cache', () {
    test('should return cached user when available', () async {
      // Arrange
      final cachedUser = UserModel(
        id: '1',
        name: 'Cached User',
        email: 'cached@test.com',
        phone: '+1234567890',
        planName: 'Cached Plan',
        monthlyPayment: 29.99,
        dataUsage: 100.0,
        dataLimit: 500.0,
        lastUpdated: DateTime.now(),
      );
      fakeLocalDataSource.cachedUser = cachedUser;
      
      // Act
      final result = await repository.getUserData('1');
      
      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (user) => expect(user.name, 'Cached User')
      );
    });

    test('should fetch remote data when cache is empty', () async {
      // Act
      final result = await repository.getUserData('2');
      
      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (user) {
          expect(user.name, 'Fake User');
          expect(fakeLocalDataSource.cachedUser?.id, '2');
        }
      );
    });

    test('should return error when remote fetch fails', () async {
      // Arrange
      fakeRemoteDataSource.errorToThrow = Exception('Network error');
      
      // Act
      final result = await repository.getUserData('3');
      
      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (user) => fail('Should have failed'),
      );
    });

    test('should use cache if remote fetch fails', () async {
      // Arrange
      final cachedUser = UserModel(
        id: '4',
        name: 'Fallback User',
        email: 'fallback@test.com',
        phone: '+1234567890',
        planName: 'Fallback Plan',
        monthlyPayment: 29.99,
        dataUsage: 100.0,
        dataLimit: 500.0,
        lastUpdated: DateTime.now(),
      );
      fakeLocalDataSource.cachedUser = cachedUser;
      fakeRemoteDataSource.errorToThrow = Exception('Network error');
      
      // Act
      final result = await repository.getUserData('4');
      
      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should use cached data'),
        (user) => expect(user.name, 'Fallback User')
      );
    });
  });
}