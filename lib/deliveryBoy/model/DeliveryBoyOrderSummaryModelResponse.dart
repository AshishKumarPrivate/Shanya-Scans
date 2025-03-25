class DeliveryBoyOrderSummaryModelResponse {
  bool? success;
  Data? data;

  DeliveryBoyOrderSummaryModelResponse({this.success, this.data});

  DeliveryBoyOrderSummaryModelResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalBookings;
  int? todayTotalBookings;
  int? ongoingBookings;
  int? completedBookings;
  int? todayOngoingBookings;
  int? todayCompletedBookings;

  Data(
      {this.totalBookings,
        this.todayTotalBookings,
        this.ongoingBookings,
        this.completedBookings,
        this.todayOngoingBookings,
        this.todayCompletedBookings});

  Data.fromJson(Map<String, dynamic> json) {
    totalBookings = json['totalBookings'];
    todayTotalBookings = json['todayTotalBookings'];
    ongoingBookings = json['ongoingBookings'];
    completedBookings = json['completedBookings'];
    todayOngoingBookings = json['todayOngoingBookings'];
    todayCompletedBookings = json['todayCompletedBookings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalBookings'] = this.totalBookings;
    data['todayTotalBookings'] = this.todayTotalBookings;
    data['ongoingBookings'] = this.ongoingBookings;
    data['completedBookings'] = this.completedBookings;
    data['todayOngoingBookings'] = this.todayOngoingBookings;
    data['todayCompletedBookings'] = this.todayCompletedBookings;
    return data;
  }
}
