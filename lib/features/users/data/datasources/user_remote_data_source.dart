import 'package:dio/dio.dart';

import '../models/user_model.dart';

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource(this.dio);

  Future<List<UserModel>> getUsers() async {

    print("API Calling");
    try {
      final response = await dio.get<List<dynamic>>('/users');

      final data = response.data ?? [];

      return data.map((json) {
        return UserModel.fromJson(
          json as Map<String, dynamic>,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load users. Please try again.');
    }
  }
}