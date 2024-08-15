// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:user_repository/src/models/user_model.dart';

class UserService {
  late final Dio _dio;
  String baseUrl = "https://recipe-app-6e080-default-rtdb.firebaseio.com/";

  UserService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );
  }

  // get user
  Future<Map<String, dynamic>?> getUser(String? userId) async {
    String url = "users/$userId.json";
    try {
      final response = await _dio.get(url);
      print("User data: ${response.data}");
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      print("S: User get User Error $e");
      rethrow;
    }
  }

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await _dio.get(
          "https://recipe-app-6e080-default-rtdb.firebaseio.com/users.json");

      final List<UserModel> loadedUsers = [];

      response.data.forEach((key, value) {
        print(value);
        value['id'] = key;
        loadedUsers.add(UserModel.fromJson(value));
      });

      return loadedUsers;
    } on DioException catch (error) {
      throw error.message.toString();
    } catch (error) {
      rethrow;
    }
  }


  Future<void> addSavedRecipe(String userId, List updatedData) async {
    Dio dio = Dio();

    String url = 'https://recipe-app-6e080-default-rtdb.firebaseio.com/users/$userId.json';

     try {
      final response = await dio.patch(url, data: {
        "savedReceiptsId":updatedData
      });

      if (response.statusCode == 200) {
        print("Data updated successfully!");
      } else {
        print("Failed to update data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating data: $e");
    }
  }
  Future<void> addLikedRecipe(String userId, List updatedData) async {
    Dio dio = Dio();

    String url = 'https://recipe-app-6e080-default-rtdb.firebaseio.com/users/$userId.json';

     try {
      final response = await dio.patch(url, data: {
        "likedReceiptsId":updatedData
      });

      if (response.statusCode == 200) {
        print("Data updated successfully!");
      } else {
        print("Failed to update data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  // editName
  Future<void> editName(String newName, String? userId) async {
    String url = "users/$userId.json";
    try {
      final response = await _dio.patch(url, data: {"name": newName});
      print("Name updated: ${response.data}");
    } catch (e) {
      print("S: User edit Name Error $e");
      rethrow;
    }
  }

  // editBio
  Future<void> editBio(String newBio, String? userId) async {
    String url = "users/$userId.json";
    try {
      final response = await _dio.patch(url, data: {"bio": newBio});
      print("Bio updated: ${response.data}");
    } catch (e) {
      print("S: User edit Bio Error $e");
      rethrow;
    }
  }

  //Edit photo
  Future<void> editPhoto(File image, String userId) async {
    String imageUrl = basename(image.path);

    // Step 1: Upload the image to the server
    try {
      String uploadUrl =
          "https://firebasestorage.googleapis.com/v0/b/recipe-app-6e080.appspot.com/o?name=$imageUrl"; // Change to your actual image upload API endpoint
      FormData formData = FormData.fromMap({
        "image":
            await MultipartFile.fromFile(image.path, filename: "$userId.jpg"),
      });

      print("Bu formData: ${formData.boundary}");

      final response = await _dio.post(uploadUrl, data: formData);

      print("Bu response: ${response.data}");

      String name = response.data['contentDisposition'].split("'").last;
      String token = response.data['downloadTokens'];

      print("Bu name: $name");
      print("Bu token: $token");

      if (response.statusCode == 200) {
        // Assume the response contains the image URL after upload
        imageUrl =
            "https://firebasestorage.googleapis.com/v0/b/recipe-app-6e080.appspot.com/o/$name?alt=media&token=$token";
        print("Image uploaded successfully: $imageUrl");
      } else {
        throw Exception("Failed to upload image");
      }
    } catch (e) {
      print("Error uploading image: $e");
      rethrow;
    }

    // Step 2: Update the user's photo URL in Firebase
    try {
      if (imageUrl.isNotEmpty) {
        String url = "users/$userId.json";
        final response = await _dio.patch(url, data: {"imageUrl": imageUrl});
        print("Photo URL updated: ${response.data}");
      }
    } catch (e) {
      print("Error updating image URL in Firebase: $e");
      rethrow;
    }
  }


}
