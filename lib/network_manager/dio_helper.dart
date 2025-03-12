import 'package:dio/dio.dart';
 import 'dart:async';
import '../ui_helper/storage_helper.dart';
import 'injection_container.dart';

class DioHelper {
  Dio dio = getDio();

  Options options (bool isAuthRequired){
    if(isAuthRequired){
      return Options(
        receiveDataWhenStatusError: true,
        contentType: "application/json",
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {"Authorization": 'Bearer ${StorageHelper().getUserAccessToken()}'},
      );
    }else{
      return Options(
        receiveDataWhenStatusError: true,
        contentType: "application/json",
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
      );
    }
  }


  /// **GET Pathology Test List API (with Pagination)**
  // Future<dynamic> getNavLabScanResponse({int page = 1, int perPage = 10}) async {
  //   String url = "https://dbsanya.drmanasaggarwal.com/api/v1/pathology";
  //
  //   return await get(
  //     url: url,
  //     isAuthRequired: true,  // Change this based on API requirement
  //     queryParams: {"page": page, "per_page": perPage},
  //   );
  // }




  /// GET API
  Future<dynamic> get ({required String url, bool isAuthRequired = false}) async{
    try {
      Response response = await dio.get(url, options: options(isAuthRequired));
      return response.data;
    }catch (error){
      return null;
    }
  }


  /// POST API  ye default post api dio helper hai
  // Future<dynamic> post ({required String url, Object? requestBody, bool isAuthRequired = false}) async{
  //   try{
  //     Response response;
  //     if(requestBody == null){
  //      response = await dio.post(url, options: options(isAuthRequired));
  //     }else{
  //       response = await dio.post(url, data: requestBody, options: options(isAuthRequired));
  //     }
  //
  //     return response.data;
  //   }catch (error){
  //     return null;
  //   }
  // }

  /// POST API ye CHAT GPT WALA POST DIO HELPER HAI
  Future<dynamic> post ({required String url, Object? requestBody, bool isAuthRequired = false}) async{
    try{
      Response response;
      if(requestBody == null){
        response = await dio.post(url, options: options(isAuthRequired));
      }else{
        response = await dio.post(url, data: requestBody, options: options(isAuthRequired));
      }

      return response.data;
    } on DioException catch (e) {
      // ❌ If DioException, check if it contains a response
      if (e.response != null) {
        print("❌ API Error Response: ${e.response?.data}");

        return e.response?.data; // ✅ Return error response from API
      } else {
        print("❌ Network Error: ${e.message}");
        return null; // ✅ Return null for network errors
      }
    }
  }


  /// PUT API
  Future<dynamic> put ({required String url, Object? requestBody, bool isAuthRequired = false}) async{

    try{
      Response response;
      if(requestBody == null){
        response = await dio.put(url, options: options(isAuthRequired));
      }else{
        response = await dio.put(url, data: requestBody, options: options(isAuthRequired));
      }

      return response.data;
    }catch (error){
      return null;
    }
  }


  /// PATCH API
  Future<dynamic> patch ({required String url, Object? requestBody, bool isAuthRequired = false}) async{

    try{
      Response response;
      if(requestBody == null){
        response = await dio.patch(url, options: options(isAuthRequired));
      }else{
        response = await dio.patch(url, data: requestBody, options: options(isAuthRequired));
      }

      return response.data;
    }catch (error){
      return null;
    }
  }



  /// DELETE API
  Future<dynamic> delete ({required String url, Object? requestBody, bool isAuthRequired = false}) async{

    try{
      Response response;
      if(requestBody == null){
        response = await dio.delete(url, options: options(isAuthRequired));
      }else{
        response = await dio.delete(url, data: requestBody, options: options(isAuthRequired));
      }

      return response.data;
    }catch (error){
      return null;
    }
  }



  /// MULTIPART API
  Future<dynamic> uploadFile ({required String url, required Object requestBody, bool isAuthRequired = false}) async{
    Options option = Options(headers: {"Content-Type": "multipart/form-data"});

    try{
      Response response = await dio.post(url, data: requestBody, options: option);

      return response.data;
    }catch (error){
      return null;
    }
  }


}