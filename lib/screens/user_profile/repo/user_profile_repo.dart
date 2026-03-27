import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/constant.dart';

import '../../../config/api_routes.dart';
import '../model/user_profile_model.dart';

class UserProfileRepository {

  Future<List<UserProfileModel>> fetchUserProfile()async {
    try{
      final response = await AppConstant.apiBaseHelper.getAPICall(
          ApiRoutes.getUserProfileApi,
        {}
      );
      if(response.statusCode == 200) {
        List<UserProfileModel> data = [];
        data.add(UserProfileModel.fromJson(response.data));
        return data;
      } else {
        return [];
      }
    }catch(e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<UserProfileModel>> updateUserProfile({
    required String userName,
    File? userImage,
  })async {
    try{
      Map<String, dynamic> fields = {
        'name': userName,
      };

      // Only add profile_image if a new image is provided
      if (userImage != null) {
        fields['profile_image'] = await MultipartFile.fromFile(
          userImage.path,
          filename: userImage.path.split('/').last,
        );
      }

      FormData formData = FormData.fromMap(fields);

      final response = await AppConstant.apiBaseHelper.postAPICall(
          ApiRoutes.updateUserProfileApi,
          formData
      );
      if(response.statusCode == 200) {
        List<UserProfileModel> data = [];
        data.add(UserProfileModel.fromJson(response.data));
        return data;
      } else {
        return [];
      }
    } catch(e) {
      throw ApiException('Failed to get user profile');
    }
  }

}