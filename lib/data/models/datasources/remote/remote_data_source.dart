import 'package:isp_app/data/models/user_model.dart';

abstract class RemoteDataSource {
  Future<dynamic> get(String url);
  dynamic mockResponse(String url);
  Future<dynamic> post(String url, {Map<String, dynamic> body});
  Future<UserModel> login(String email, String password);
  Future<UserModel> getUserData(String userId);
}