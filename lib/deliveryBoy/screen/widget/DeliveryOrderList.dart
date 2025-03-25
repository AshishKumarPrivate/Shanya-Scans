import 'package:flutter/material.dart';
import 'package:healthians/base_widgets/loading_indicator.dart';
import 'package:healthians/deliveryBoy/model/DeliveryOrderLIstModel.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/responsive_helper.dart';
import '../../controller/DeliveryOrdersProvider.dart';
import 'DelliveryOrderCard.dart';

class DeliveryOrderList extends StatefulWidget {
  final String status;

  const DeliveryOrderList({Key? key, required this.status}) : super(key: key);

  @override
  _DeliveryOrderListState createState() => _DeliveryOrderListState();
}

class _DeliveryOrderListState extends State<DeliveryOrderList> {
  DateTime? _selectedDate;
  late DeliveryOrdersProvider orderProvider;
  bool _showDateSelector = false; // Toggle for showing the date selector

  /// 🔹 Selects the date and filters the list **locally** without API calls
  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  /// 🔹 Filters orders by date (only for "completed" status)
  List<OrderDetails> _filterOrdersByDate(List<OrderDetails> orders) {
    if (widget.status != "completed" || _selectedDate == null) {
      return orders; // ✅ Show all orders by default
    }

    String formattedSelectedDate =
        DateFormat('yyyy-MM-dd').format(_selectedDate!);
    return orders.where((order) {
      String orderDate = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(order.bookingDate.toString()));
      return orderDate == formattedSelectedDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    orderProvider = Provider.of<DeliveryOrdersProvider>(context);

    if (orderProvider.isLoading) {
      return loadingIndicator(color: AppColors.deliveryPrimary);
    }

    List<OrderDetails> filteredOrders =
        _filterOrdersByDate(orderProvider.orderList);

    return Column(
      children: [
        if (widget.status == "completed") _buildFilterButton(),
        if (_showDateSelector) _buildDateSelector(),
        // 🔹 Show only when toggled
        Expanded(
          child: filteredOrders.isEmpty
              ? _buildNoOrdersWidget()
              : RefreshIndicator(
                  onRefresh: () async {
                    await orderProvider
                        .fetchDeliveryBoyOrderList(widget.status);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric( horizontal: 0, vertical: 0),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: index == 0 ? 12 : 5,
                          bottom: index == filteredOrders.length - 1 ? 15 : 5,
                        ),
                        child: DeliveryOrderCard(order: filteredOrders[index]),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  /// **🔘 Filter Button (Toggles Date Selector)**
  Widget _buildFilterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Filter orders by date",
            style: AppTextStyles.bodyText1(
              context,
              overrideStyle:
                  TextStyle(fontSize: ResponsiveHelper.fontSize(context, 12),color: Colors.black),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _showDateSelector = !_showDateSelector;
              });
            },
            icon: Icon(Icons.filter_alt_outlined, size: 15),
            label: Text(
              _showDateSelector ? "Filter" : "Filter",
              style: AppTextStyles.bodyText1(
                context,
                overrideStyle:
                TextStyle(fontSize: ResponsiveHelper.fontSize(context, 12),color: Colors.black),
              ),
            ),
            style: OutlinedButton.styleFrom(
              // backgroundColor: AppColors.deliveryPrimary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              // 🔹 Smaller padding
              minimumSize: Size(60, 20),
              // 🔹 Minimum size set for compactness-
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **📅 Conditionally Visible Date Selector**
  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: EasyDateTimeLine(
        initialDate: _selectedDate ?? DateTime.now(),
        onDateChange: (date) {
          _onDateSelected(date);
        },
        activeColor: AppColors.deliveryPrimary,
        headerProps: EasyHeaderProps(
          selectedDateFormat: SelectedDateFormat.fullDateDMonthAsStrY,
          monthPickerType: MonthPickerType.dropDown,
        ),
        dayProps: EasyDayProps(
          todayStyle: DayStyle(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary,width: 1),
              // color: Colors.blueAccent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
            dayStrStyle: TextStyle(color: AppColors.primary, ),
            dayNumStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            monthStrStyle: TextStyle(color: AppColors.primary,),
          ),
          activeDayStyle: DayStyle(
            decoration: BoxDecoration(
              color: AppColors.deliveryPrimary,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  /// **🛑 No Orders Widget**
  Widget _buildNoOrdersWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "No Orders Found",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
