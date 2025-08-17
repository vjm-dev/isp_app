import 'package:flutter_test/flutter_test.dart';
import 'package:isp_app/core/error/failures.dart';
import 'package:isp_app/data/models/datasources/local/local_data_source.dart';
import 'package:isp_app/data/models/datasources/remote/remote_data_source.dart';
import 'package:isp_app/data/models/user_model.dart';
import 'package:isp_app/domain/entities/data_usage.dart';
import 'package:isp_app/domain/repositories/auth_repository_impl.dart';

class FakeRemoteDataSource implements RemoteDataSource {
  bool shouldSucceed = true;
  UserModel? userToReturn;
  Exception? errorToThrow;

  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 10));
    
    if (errorToThrow != null) throw errorToThrow!;
    if (!shouldSucceed) throw Exception('Login failed');
    
    return userToReturn ?? UserModel(
      id: '1',
      name: 'Test User',
      email: email,
      phone: '+1234567890',
      planName: 'Test Plan',
      monthlyPayment: 29.99,
      dataUsage: DataUsage(
        startDate: DateTime.now().subtract(Duration(days: 30)),
        endDate: DateTime.now().add(Duration(days: 5)),
        used: 325.6,
        limit: 1000.0,
        dailyUsage: List.generate(30, (index) {
          final date = DateTime.now().subtract(Duration(days: 29 - index));
          return DataConsumption(
            date: date,
            download: (index % 5 + 2.5),
            upload: (index % 3 + 0.5),
          );
        }),
      ),
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<UserModel> getUserData(String userId) {
    throw UnimplementedError();
  }
  
  @override
  Future get(String url) {
    // TODO: implement get
    throw UnimplementedError();
  }
  
  @override
  mockResponse(String url) {
    // TODO: implement mockResponse
    throw UnimplementedError();
  }
  
  @override
  Future post(String url, {Map<String, dynamic>? body}) {
    // TODO: implement post
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
  late AuthRepositoryImpl repository;
  late FakeRemoteDataSource fakeRemoteDataSource;
  late FakeLocalDataSource fakeLocalDataSource;

  setUp(() {
    fakeRemoteDataSource = FakeRemoteDataSource();
    fakeLocalDataSource = FakeLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: fakeRemoteDataSource,
      localDataSource: fakeLocalDataSource,
    );
  });

  group('login', () {
    test('login success should return User and cache data', () async {
      // Act
      final result = await repository.login('test@test.com', 'password');
      
      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (user) {
          expect(user.email, 'test@test.com');
          expect(fakeLocalDataSource.cachedUser?.email, 'test@test.com');
        }
      );
    });

    test('login failure should return ServerFailure', () async {
      // Arrange
      fakeRemoteDataSource.shouldSucceed = false;
      
      // Act
      final result = await repository.login('test@test.com', 'password');
      
      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (user) => fail('Should have failed'),
      );
    });

    test('should handle specific exceptions', () async {
      // Arrange
      fakeRemoteDataSource.errorToThrow = Exception('Invalid credentials');
      
      // Act
      final result = await repository.login('test@test.com', 'password');
      
      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Invalid credentials'));
        },
        (user) => fail('Should have failed'),
      );
    });
  });
}