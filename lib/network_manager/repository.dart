import 'package:dio/dio.dart';
import 'package:shanya_scans/deliveryBoy/model/ChangeOrderStatusModelResponse.dart';
import 'package:shanya_scans/deliveryBoy/model/DeliveryBoyOrderDetailModel.dart';
import 'package:shanya_scans/deliveryBoy/model/DeliveryBoyOrderSummaryModelResponse.dart';
import 'package:shanya_scans/deliveryBoy/model/DeliveryBoyProfileSummaryModelResponse.dart';
import 'package:shanya_scans/deliveryBoy/model/DeliveryLoginModelResponse.dart';
import 'package:shanya_scans/screen/auth/model/LoginModel.dart';
import 'package:shanya_scans/screen/auth/model/UpdateProfileModel.dart';
import 'package:shanya_scans/screen/nav/nav_home/frquently_pathalogy_test/model/FrequentlyPathalogyTagListModel.dart';
import 'package:shanya_scans/screen/nav/nav_home/health_concern/model/HealthConcernPacakageTagModel.dart';
import 'package:shanya_scans/screen/nav/nav_home/slider/mdel/HomeBanner1ModelResponse.dart';
import 'package:shanya_scans/screen/nav/nav_home/slider/mdel/HomeBanner2ModelResponse.dart';
import 'package:shanya_scans/screen/order/model/CreateOrder2ModelResponse.dart';
import 'package:shanya_scans/screen/order/model/MyOrderHistoryListModel.dart';
import 'package:shanya_scans/screen/packages/model/PackageListByTabIdModel.dart';
import 'package:shanya_scans/screen/packages/model/TopSellingPackagesListModel.dart';
import 'package:shanya_scans/screen/profile/model/enquiry_need_help_model.dart';
import 'package:shanya_scans/screen/profile/termsConditionPrivacyPollicy/terms_conditions_privacy_refund_policy_model.dart';
import 'package:shanya_scans/screen/service/model/HomeServiceDetailModel.dart';
import 'package:shanya_scans/screen/service/model/HomeServiceListModel.dart';
import 'package:shanya_scans/screen/service/model/ServiceDetailRateListModel.dart';

import '../deliveryBoy/model/DeliveryOrderLIstModel.dart';
import '../screen/auth/model/CreateUser.dart';
import '../screen/auth/model/ListModel.dart';
import '../screen/auth/model/ObjectModel.dart';
import '../screen/auth/model/OtpVerifyModel.dart';
import '../screen/auth/model/SignUpModel.dart';
import '../screen/checkout/model/payment_checkout_model.dart';
import '../screen/nav/nav_home/health_concern/model/HealthConcernDetailModel.dart';
import '../screen/nav/nav_lab/model/PathalogyTestListDetailModel.dart';
import '../screen/nav/nav_lab/model/PathalogyTestListModel.dart';
import 'dio_helper.dart';

class Repository {
  static final DioHelper _dioHelper = DioHelper();

  // static const String baseUrl = "https://5h8cr5kr-5000.inc1.devtunnels.ms/";
   static const String baseUrl = "https://db.shanyascans.com";


  // &&&&&&&&&&& testing api Start here &&&&&&&&&&&&&&&&

  //GET API
  Future<ObjectModel> objectModelApiResponse() async {
    Map<String, dynamic> response = await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    return ObjectModel.fromJson(response);
  }

  //GET API
  Future<List<ListModel>> listModelApiResponse() async {
    List<dynamic> response =
        await _dioHelper.get(url: 'https://jsonplaceholder.typicode.com/posts');
    // Map<String, dynamic> response = await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    return List<ListModel>.from(response.map((e) => ListModel.fromJson(e)));
  }

  //POST API
  Future<CreateUserMdel> createUser(Object reqBody) async {
    var response = await _dioHelper.post(
        url: 'https://reqres.in/api/users', requestBody: reqBody);

    print("API Response22222222: ${response}"); // Debugging
    // Map<String, dynamic> response = await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    return CreateUserMdel.fromJson(response);
  }

  // ******************************  Shanya Scans API  **************************************
  Future<SignUpModel> userSignUp(Map<String, dynamic> requestBody) async {
    try {
      print("📤 Sending Signup Request: $requestBody");

      Map<String, dynamic>? response = await _dioHelper.post(
        url: '$baseUrl/api/v1/user/register',
        requestBody: requestBody,
      );

      if (response == null) {
        print("❌ API returned null response!");
        return SignUpModel(success: false, message: "No response from server");
      }
      print("✅ Signup API Response: $response");

      // ✅ Handle API returning `success: false`
      // if (response["success"] == false) {
      //   return SignUpModel(success: false, message: response["message"] ?? "Signup failed");
      // }

      if (response is Map<String, dynamic>) {
        // 🟢 Response is in expected format
        return SignUpModel.fromJson(response);
      } else if (response is String) {
        // 🔴 String error (like "Bad Request")
        return SignUpModel(success: false, message: "response");
      } else {
        // 🔴 Unexpected format
        return SignUpModel(success: false, message: "Unexpected error occurred.");
      }
      // ✅ Convert API response into Model
      return SignUpModel.fromJson(response);
    } catch (e) {

      print("❌ Error parsing signup response: $e");
      return SignUpModel(success: false, message: "Parsing failed: ${e.toString()}");

    }
    // }
    // on DioException catch (e) {
    //   final statusCode = e.response?.statusCode;
    //   final responseData = e.response?.data;
    //
    //   print("❌ DioException caught: Status Code = $statusCode");
    //   print("❌ DioException Data = $responseData");
    //
    //   if (statusCode == 400) {
    //     return SignUpModel(success: false, message: "User already exists");
    //   } else if (statusCode == 401) {
    //     return SignUpModel(success: false, message: "Unauthorized access");
    //   } else if (statusCode == 403) {
    //     return SignUpModel(success: false, message: "Forbidden: Access denied");
    //   } else if (statusCode == 404) {
    //     return SignUpModel(success: false, message: "API endpoint not found");
    //   } else if (statusCode == 409) {
    //     return SignUpModel(success: false, message: "Conflict: Duplicate data");
    //   } else if (statusCode == 500) {
    //     return SignUpModel(success: false, message: "Server error. Please try again later");
    //   } else {
    //     // Handle all other status codes and fallback cases
    //     String fallbackMessage = "Something went wrong";
    //
    //     try {
    //       if (responseData is Map && responseData.containsKey("message")) {
    //         fallbackMessage = responseData["message"];
    //       }
    //     } catch (_) {}
    //
    //     return SignUpModel(success: false, message: fallbackMessage);
    //   }
    // } catch (e) {
    //   print("❌ Unexpected Error: $e");
    //   return SignUpModel(success: false, message: "Unexpected error occurred");
    // }
  }

  // user login
  Future<LoginModel> userLogin(Map<String, dynamic> requestBody) async {
    try {
      // ✅ API Call
      Map<String, dynamic>? response = await _dioHelper.post(
        url: '$baseUrl/api/v1/user/login',
        requestBody: requestBody,
      );

      // ✅ Debug Response
      print("✅ Login API Raw Response: $response");

      if (response == null) {
        print("❌ Login API returned null response!");
        return LoginModel(success: false, message: "No response from server");
      }

      // ✅ Check if API returns success: false
      if (response["success"] == false) {
        String errorMessage = response["message"] ?? "Login failed!";
        return LoginModel(success: false, message: errorMessage);
      }

      // ✅ Return Parsed Model
      return LoginModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response != null) {
        print("❌ Login API Error: ${e.response?.data}");
        return LoginModel(
          success: false,
          message: e.response?.data["message"] ?? "Something went wrong",
        );
      } else {
        print("❌ Network Error: ${e.message}");
        return LoginModel(success: false, message: "No Internet Connection");
      }
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return LoginModel(success: false, message: "Unexpected error occurred");
    }
  }

  // Forget Password
  Future<Map<String, dynamic>> forgetPassword(Map<String, dynamic> requestBody) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.post(
        url: '$baseUrl/api/v1/user/forgot-password',
        requestBody: requestBody,
      );

      print("✅ Forget Password API Response: $response");

      if (response == null) {
        return {"success": false, "message": "No response from server"};
      }

      return {
        "success": response["success"] ?? false,
        "message": response["message"] ?? "Something went wrong"
      };
    } on DioException catch (e) {
      return {
        "success": false,
        "message": e.response?.data["message"] ?? "Something went wrong"
      };
    } catch (e) {
      return {"success": false, "message": "Reset code not sent to email"};
    }
  }

  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> requestBody) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.post(
        url: '$baseUrl/api/v1/user/reset-password',
        requestBody: requestBody,
      );

      print("✅ Forget Password API Response: $response");

      if (response == null) {
        return {"success": false, "message": "No response from server"};
      }

      return {
        "success": response["success"] ?? false,
        "message": response["message"] ?? "Something went wrong"
      };
    } on DioException catch (e) {
      return {
        "success": false,
        "message": e.response?.data["message"] ?? "Something went wrong"
      };
    } catch (e) {
      return {"success": false, "message": "Unexpected error occurred"};
    }
  }

  // order history
  Future<UpdateProfileModel> updateProfile(
      String userId, Object requestBody) async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response = await _dioHelper.put(
        url: '$baseUrl/api/v1/user/profile/$userId', requestBody: requestBody);
    return UpdateProfileModel.fromJson(response);
  }

  // user otp verification
  Future<OtpVerifyModel> verifyOtp(Object requestBody) async {
    Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/user/verify', requestBody: requestBody);

    print("VerifyOtp Api Response: ${response}"); // Debugging
    return OtpVerifyModel.fromJson(response);
    // return LogInModel.fromJson(response);
  }

  Future<String> resendOtp(Object requestBody) async {
    Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/user/resend-verification',
        requestBody: requestBody);

    print("resendOtp Api Response: ${response}"); // Debugging
    return response["message"];
    // return LogInModel.fromJson(response);
  }

  //GET API
  Future<HomeServiceListModel> getHomeServiceModelResponse() async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/service/detail/service');
    return HomeServiceListModel.fromJson(response);
  }

  //GET API
  Future<HomeServiceDetailModel> getHomeServiceDetailResponse(
      String serviceSlug) async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response = await _dioHelper.get(
        url: '$baseUrl/api/v1/service/detail/specific/$serviceSlug');
    return HomeServiceDetailModel.fromJson(response);
  }

  // POST API
  Future<ServiceDetailRateListModel> getServiceDetailRateList(
      String slug) async {
    Map<String, dynamic> response = await _dioHelper.get(
        url: '$baseUrl/api/v1/test/service/scan/${slug}');
        // url: '$baseUrl/api/v1/test/single/name', requestBody: requestBody);

    print("ServiceDetailRateListModel Api Response: ${response}"); // Debugging
    return ServiceDetailRateListModel.fromJson(response);
    // return LogInModel.fromJson(response);
  }

  // &&&&&&&&&&& Health Concern  &&&&&&&&&
  // home health concern list
  Future<HealthConcernPackageTagModel> getHealthConcerListTag() async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/package/tag');
    return HealthConcernPackageTagModel.fromJson(response);
  }

  // home health concern list Detail
  Future<HealthConcernDetailModel> getHealthConcernDetail(
      String healthConcernSlug) async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response = await _dioHelper.get(
        url: '$baseUrl/api/v1/package/more/${healthConcernSlug}');
    return HealthConcernDetailModel.fromJson(response);
  }

// &&&&&&&&&&& Frequently Lab Test  &&&&&&&&&
  //GET API
  Future<FrequentlyTagListModel> getFrequentlyLabTestListResponse() async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/pathology/tag');
    return FrequentlyTagListModel.fromJson(response);
  }

// &&&&&&&&&&& Package List  &&&&&&&&&
  // package home  tab  list
  Future<PackageListByTabIdModel> getPackageListResponse() async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/package/tag');
    return PackageListByTabIdModel.fromJson(response);
  }

  Future<PackageListByTabIdModel> getNavPackageListResponse() async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/package');
    return PackageListByTabIdModel.fromJson(response);
  }

// package list by tab clck
  // Future<PackageListDetailModel> getPackageListByTabClikResponse(
  //     String packageSlug) async {
  //   // var response =
  //   //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
  //   Map<String, dynamic> response =
  //       await _dioHelper.get(url: '$baseUrl/api/v1/package/more/$packageSlug');
  //   return PackageListDetailModel.fromJson(response);
  // }
  // package list by tab click
  Future<PackageListByTabIdModel> getPackageListByTabResponse(
      Object requestBody) async {
    Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/package/tag/package', requestBody: requestBody);

    return PackageListByTabIdModel.fromJson(response);
    // return LogInModel.fromJson(response);
  }

  Future<TopSellingPackagesListModel> getTopSellingPackageListResponse(
      Object requestBody) async {
    Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/package/tag/package', requestBody: requestBody);

    return TopSellingPackagesListModel.fromJson(response);
    // return LogInModel.fromJson(response);
  }

// &&&&&&&&&&& bottom nav Scans List  &&&&&&&&&
// Bottom nav Scans list

  Future<PathalogyTestListModel> getNavLabScanResponse({int page = 1, int limit = 10}) async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/pathology/pagination?page=$page&limit=$limit');
    return PathalogyTestListModel.fromJson(response);
  }

// Bottom nav Scans list Detail

  Future<PathalogyScansListDetailModel> getNavLabScanDetailResponse(
      String pathalogySlug) async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/pathology/${pathalogySlug}');
    return PathalogyScansListDetailModel.fromJson(response);
  }

// &&&&&&&&&&& Home Banner List  &&&&&&&&&
//GET API
  Future<HomeBanner1ModelResponse> getHomeBanner2ModelResponse() async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/banner/banner2');
    return HomeBanner1ModelResponse.fromJson(response);
  }

  Future<HomeBanner2ModelResponse> getHomeBanner1ModelResponse() async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/banner/banner1');
    return HomeBanner2ModelResponse.fromJson(response);
  }

// &&&&&&&&&&& Terms &b condition , privacy policy , refund polciy   &&&&&&&&&

  // terms & Conditions
  Future<TermsConditionsPrivacyRefundPolicyModel> getTermAndConditions() async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/utlis/term-condition');
    return TermsConditionsPrivacyRefundPolicyModel.fromJson(response);
  }

  // Privacy Policy
  Future<TermsConditionsPrivacyRefundPolicyModel> getPrivacyPolicy() async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/utlis/privacy-policy');
    return TermsConditionsPrivacyRefundPolicyModel.fromJson(response);
  }

  // Refund Policy
  Future<TermsConditionsPrivacyRefundPolicyModel> getRefundPolicy() async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/utlis/refund-cancellation');
    return TermsConditionsPrivacyRefundPolicyModel.fromJson(response);
  }


  // order history
  Future<MyOrderHistoryListModel> getOrderHistoryResponse(String userId) async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
        await _dioHelper.get(url: '$baseUrl/api/v1/user/order/${userId}');
    return MyOrderHistoryListModel.fromJson(response);
  }

  Future<EnquiryNeedHelpModel> sendEnquiry(Object requestBody) async {
    Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/contact', requestBody: requestBody);

    return EnquiryNeedHelpModel.fromJson(response);
    // return LogInModel.fromJson(response);
  }
/////////&&&&&&&&&&&7 PAYMENT &&&&&&&&&&&&&&&&&&&&&
  /// RAZER PAYMENT
  Future<Map<String, dynamic>> getRazorPaymentKey() async {
    try {
      Map<String, dynamic> response = await _dioHelper.get(
        url: '$baseUrl/api/v1/payment/key',
      );

      return {
        "success": response["success"] ?? false,
        "message": response["message"] ?? "Something went wrong",
        "key": response["key"],
      };
    } on DioException catch (e) {
      return {
        "success": false,
        "message": e.response?.data["message"] ?? "Something went wrong",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Unexpected error occurred",
      };
    }
  }

  Future<PaymentCheckoutModel?> createRazerPayOrder(Object requestBody) async {
    try {
      Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/payment/checkout',
        requestBody: requestBody,
      );

      if (response['success']) {
        return PaymentCheckoutModel.fromJson(response);
      }
    } catch (e) {
      print('Error creating order: $e');
    }
    return null;
  }

  Future<bool> verifyPayment( Object requestBody ) async {
    try {
      // final response = await _dio.post(ApiConstants.verifyPayment, data: {
      //   "razorpay_payment_id": paymentId,
      //   "razorpay_order_id": orderId,
      //   "razorpay_signature": signature,
      // });
      Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/payment/status',
        requestBody: requestBody,
      );
      return response['success'];
    } catch (e) {
      print('Error verifying payment: $e');
    }
    return false;
  }
  // &&&&&&&&&&&&&&&& ORDER API &&&&&&&&&&&&&&&&&&&&&&&&&&
  Future<CreateOrder2ModelResponse> createOrderResponse(
      Object requestBody) async {
    Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/order', requestBody: requestBody);

    return CreateOrder2ModelResponse.fromJson(response);
    // return LogInModel.fromJson(response);
  }

  // ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨  Shanya Scans Delivery Boy API   ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨

  // user login
  Future<DeliveryLoginModelResponse> deliveryBoyLogin(Map<String, dynamic> requestBody) async {
    try {
      // ✅ API Call
      Map<String, dynamic>? response = await _dioHelper.post(
        url: '$baseUrl/api/v1/collection/login',
        requestBody: requestBody,
      );

      // ✅ Debug Response
      print("✅ Login API Raw Response: $response");

      if (response == null) {
        print("❌ Login API returned null response!");
        return DeliveryLoginModelResponse(success: false, message: "No response from server");
      }

      // ✅ Check if API returns success: false
      if (response["success"] == false) {
        String errorMessage = response["message"] ?? "Login failed!";
        return DeliveryLoginModelResponse(success: false, message: errorMessage);
      }

      // ✅ Return Parsed Model
      return DeliveryLoginModelResponse.fromJson(response);
    } on DioException catch (e) {
      if (e.response != null) {
        print("❌ Login API Error: ${e.response?.data}");
        return DeliveryLoginModelResponse(
          success: false,
          message: e.response?.data["message"] ?? "Something went wrong",
        );
      } else {
        print("❌ Network Error: ${e.message}");
        return DeliveryLoginModelResponse(success: false, message: "No Internet Connection");
      }
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return DeliveryLoginModelResponse(success: false, message: "Unexpected error occurred");
    }
  }

  // order list
  Future<DeliveryBoyOrderListModel> getDeliveryBoyOrderList(String deliveryBoyId) async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
    await _dioHelper.get(url: '$baseUrl/api/v1/collection/detail/${deliveryBoyId}');
    return DeliveryBoyOrderListModel.fromJson(response);
  }

  Future<DeliveryBoyOrderDetailModel> getDeliveryBoyOrderDetail(String orderId) async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
    await _dioHelper.get(url: '$baseUrl/api/v1/order/home-collection/${orderId}');
    return DeliveryBoyOrderDetailModel.fromJson(response);
  }

  //POST API
  Future<ChangeOrderStatusModelResponse> changeOrderStatus(Object requestBody,String orderId) async {
    Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/order/change-status/${orderId}', requestBody: requestBody);

    return ChangeOrderStatusModelResponse.fromJson(response);
  }

  Future<DeliveryBoyOrderSummaryModelResponse> getDeliveryBoyOrderSummary(String deliveryBoyId) async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
    await _dioHelper.get(url: '$baseUrl/api/v1/collection/summary/${deliveryBoyId}');
    return DeliveryBoyOrderSummaryModelResponse.fromJson(response);
  }

  Future<DeliveryBoyProfileSummaryModelResponse> getDeliveryBoyProfileSummary(String deliveryBoyId) async {
    // var response =
    //     await _dioHelper.get(url: 'https://reqres.in/api/users?page=2');
    Map<String, dynamic> response =
    await _dioHelper.get(url: '$baseUrl/api/v1/collection/detail/${deliveryBoyId}');
    return DeliveryBoyProfileSummaryModelResponse.fromJson(response);
  }

  Future<Map<String, dynamic>> sendFcmToken(Object requestBody) async {

    try{
      Map<String, dynamic> response = await _dioHelper.post(
          url: '$baseUrl/api/v1/collection/fcm/token', requestBody: requestBody);

      print("✅ Send fcm token API Response: $response");

      return {
        "success": response["success"] ?? false,
        "message": response["message"] ?? "Something went wrong"
      };
    }on DioException catch (e) {
      return {
        "success": false,
        "message": e.response?.data["message"] ?? "Something went wrong"
      };
    } catch (e) {
      return {"success": false, "message": "Unexpected error occurred"};
    }

    // return FirebaseModel.fromJson(response);
  }


}
