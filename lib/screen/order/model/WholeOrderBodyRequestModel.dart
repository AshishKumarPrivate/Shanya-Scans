import 'OrderItem.dart';

class OrderModel {
  final String email;
  final String address;
  final int phoneNumber;
  final int altPhoneNumber;
  final List<PatientOrder> orderDetails;

  OrderModel({
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.altPhoneNumber,
    required this.orderDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "address": address,
      "phoneNumber": phoneNumber,
      "altPhoneNumber": altPhoneNumber,
      "orderDetails": orderDetails.map((patient) => patient.toJson()).toList(),
    };
  }
}

class PatientOrder {
  final String patientName;
  final int patientAge;
  final String patientGender;
  final List<OrderItem> tests;

  PatientOrder({
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.tests,
  });

  Map<String, dynamic> toJson() {
    return {
      "patientName": patientName,
      "patientAge": patientAge,
      "patientGender": patientGender,
      "tests": tests.map((test) => test.toJson()).toList(),
    };
  }
}
