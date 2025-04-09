import 'package:flutter/material.dart';
import 'package:shanya_scans/base_widgets/loading_indicator.dart';
import 'package:shanya_scans/deliveryBoy/model/DeliveryOrderLIstModel.dart';
import 'package:shanya_scans/deliveryBoy/screen/widget/DelliveryOrderCard.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/responsive_helper.dart';
import '../../base_widgets/common/default_common_app_bar.dart';
import '../controller/DeliveryOrdersProvider.dart';

class DeliveryOrderListScreen extends StatefulWidget {
  final String status;

  const DeliveryOrderListScreen({Key? key, required this.status})
      : super(key: key);

  @override
  _DeliveryOrderListScreenState createState() =>
      _DeliveryOrderListScreenState();
}

class _DeliveryOrderListScreenState extends State<DeliveryOrderListScreen> {
  DateTime? _selectedDate;
  late DeliveryOrdersProvider orderProvider;
  bool _showDateSelector = false;
  bool _isLoading = false;
  bool _isInit = true;

  void _onDateSelected(DateTime selectedDate) async{
    // setState(() {
    //   _selectedDate = selectedDate;
    // });

    setState(() {
      _isLoading = true;
      _selectedDate = selectedDate;
    });

    // Simulate a slight loading delay for UX
    await Future.delayed(Duration(milliseconds: 300));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement initState
    super.didChangeDependencies();
    if (_isInit) {
      orderProvider = Provider.of<DeliveryOrdersProvider>(context, listen: false);
      _fetchInitialOrders();
      _isInit = false;
    }
  }
  Future<void> _fetchInitialOrders() async {
    setState(() => _isLoading = true);
    await orderProvider.fetchDeliveryBoyOrderList(widget.status);
    setState(() => _isLoading = false);
  }



  /// 🔹 Filters orders by date (only for "completed" status)
  List<OrderDetails> _filterOrdersByDate(List<OrderDetails> orders) {
    if (widget.status != "completed" || _selectedDate == null) {
      return orders; // ✅ Show all orders by default
    }

    String formattedSelectedDate =DateFormat('yyyy-MM-dd').format(_selectedDate!);
    return orders.where((order) {
      String orderDate = DateFormat('yyyy-MM-dd') .format(DateTime.parse(order.bookingDate.toString()));
      return orderDate == formattedSelectedDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<OrderDetails> filteredOrders = _filterOrdersByDate(orderProvider.orderList);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(activityName: "Your Orders",backgroundColor: AppColors.deliveryPrimary,),
      body:  SafeArea(
        child: Column(
          children: [
            if (widget.status == "completed") _buildFilterButton(),
            if (_showDateSelector) _buildDateSelector(),
            // 🔹 Show only when toggled
            Expanded(
              child:  _isLoading
                  ? Center(child: loadingIndicator(color: AppColors.deliveryPrimary))
                  :filteredOrders.isEmpty
                  ? _buildNoOrdersWidget()
                  : RefreshIndicator(
                backgroundColor: Colors.white, // ✅ Set your desired background color here

                color: AppColors.deliveryPrimary,
                onRefresh: () async {
                  await orderProvider.fetchDeliveryBoyOrderList(widget.status);
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
        ),
      ),
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
              overrideStyle: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 12),
                  color: Colors.black),
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
                overrideStyle: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 12),
                    color: Colors.black),
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
              border: Border.all(color: AppColors.primary, width: 1),
              // color: Colors.blueAccent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
            dayStrStyle: TextStyle(
              color: AppColors.primary,
            ),
            dayNumStyle: TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.bold),
            monthStrStyle: TextStyle(
              color: AppColors.primary,
            ),
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
