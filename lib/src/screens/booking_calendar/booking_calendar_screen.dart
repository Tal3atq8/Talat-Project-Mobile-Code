import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/screens/booking_calendar/booking_calendar_controller.dart';
import 'package:talat/src/screens/seeAll_activity/see_popular_activities.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../utils/common_widgets.dart';
import '../../utils/preference/preference_keys.dart';
import '../../utils/preference/preferences.dart';

class BookingCalendar extends StatefulWidget {
  BookingCalendar({Key? key}) : super(key: key);

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  // String ammount = Get.arguments;
  final controller = Get.find<BookingCalendarController>();
  String date = "-";
  List<int>? daysOfWeek = [1, 2, 3];

  DateTimeRange? selectedDateRange;
  DateTime? startDate;
  DateTime? endDate;

  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime.now(),
    if (activityDetailItem.value.typeOfActivity == 'Day') DateTime.now(),
  ];

  Duration initialTimer = const Duration();

  bool webview = false;

  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now();

  String? totalDays;

  @override
  void initState() {
    super.initState();
    preSelectedDate(isInit: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: CustomAppbarNoSearchBar(title: toLabelValue(ConstantStrings.selectBookingText)),
      body: GetBuilder<BookingCalendarController>(builder: (controller) {
        return Center(
          child: SizedBox(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: Get.height * 0.45,
                  child: Obx(() {
                    print(controller.availableDays.length);
                    if (controller.availableDays.isNotEmpty && !controller.availableDays.contains(startDate)) {
                      startDate = null;
                      endDate = null;
                      controller.diffrerence = 1;
                    }
                    return controller.isCalenderLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                            color: ColorConstant.appThemeColor,
                          ))
                        : (activityDetailItem.value.typeOfActivity == 'Day')
                            ? SfDateRangePicker(
                                onSelectionChanged:
                                    (DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
                                  print(
                                      "dateRangePickerSelectionChangedArgs ====> ${dateRangePickerSelectionChangedArgs.value}");
                                  List<DateTime> dates = [];
                                  controller.listOfDate.value = [];
                                  startDate = null;
                                  endDate = null;
                                  controller.showContainer(false);
                                  controller.selectedPeopleNumber.value = 1;
                                  if (dateRangePickerSelectionChangedArgs.value.startDate != null &&
                                      dateRangePickerSelectionChangedArgs.value.endDate != null) {
                                    for (int i = 0;
                                        i <=
                                            dateRangePickerSelectionChangedArgs.value.endDate
                                                .difference(dateRangePickerSelectionChangedArgs.value.startDate)
                                                .inDays;
                                        i++) {
                                      dates.add(DateTime(
                                              dateRangePickerSelectionChangedArgs.value.startDate.year,
                                              dateRangePickerSelectionChangedArgs.value.startDate.month,
                                              dateRangePickerSelectionChangedArgs.value.startDate.day)
                                          .add(Duration(days: i)));
                                    }
                                  }

                                  if (dates.isNotEmpty) {
                                    startDate = dates.first;
                                    endDate = dates.last;

                                    List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
                                      List<DateTime> days = [];
                                      for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
                                        days.add(startDate.add(Duration(days: i)));
                                      }
                                      return days;
                                    }

                                    List<DateTime> days = getDaysInBetween(startDate!, endDate!);

                                    if (controller.listOfDate.isEmpty) {
                                      for (var day in days) {
                                        controller.listOfDate.add(day.toString().split(' ')[0]);
                                      }
                                    } else {
                                      controller.listOfDate.clear();
                                      for (var day in days) {
                                        controller.listOfDate.add(day.toString().split(' ')[0]);
                                      }
                                    }

                                    if (dates.isNotEmpty) {
                                      controller.diffrerence = dates.last.difference(dates.first).inDays + 1;
                                      controller.startDateStr = DateFormat('yyyy-MM-dd').format(startDate!);
                                      controller.endDateStr = DateFormat('yyyy-MM-dd').format(endDate!);
                                      if (activityDetailItem.value.discountedPrice == 0) {
                                        controller.totalAmount.value =
                                            (double.parse(activityDetailItem.value.initialPrice.toString()) *
                                                    controller.diffrerence *
                                                    controller.selectedPeopleNumber.value)
                                                .toString();
                                      } else {
                                        controller.totalAmount.value =
                                            (double.parse(activityDetailItem.value.discountedPrice.toString()) *
                                                    controller.diffrerence *
                                                    controller.selectedPeopleNumber.value)
                                                .toString();
                                      }
                                    } else {
                                      if (activityDetailItem.value.discountedPrice == 0) {
                                        controller.totalAmount.value =
                                            (double.parse(activityDetailItem.value.initialPrice.toString()) *
                                                    controller.diffrerence *
                                                    controller.selectedPeopleNumber.value)
                                                .toString();
                                      } else {
                                        controller.totalAmount.value =
                                            (double.parse(activityDetailItem.value.discountedPrice.toString()) *
                                                    controller.diffrerence *
                                                    controller.selectedPeopleNumber.value)
                                                .toString();
                                      }
                                    }

                                    Duration diff = dates.first.difference(dates.last);
                                    totalDays = diff.inDays.toString();

                                    setState(() {
                                      _rangeDatePickerValueWithDefaultValue = dates;
                                      controller.showContainer.value = true;
                                    });
                                  }
                                  if ((dateRangePickerSelectionChangedArgs.value.startDate != null &&
                                      dateRangePickerSelectionChangedArgs.value.endDate != null)) {
                                    checkSlotAvailability();
                                  }
                                },
                                selectionMode: DateRangePickerSelectionMode.range,
                                selectableDayPredicate: (DateTime dateTime) {
                                  return controller.availableDays.contains(dateTime);
                                },
                                rangeSelectionColor: ColorConstant.appThemeColor.withOpacity(.1),
                                selectionColor: ColorConstant.appThemeColor,
                                startRangeSelectionColor: ColorConstant.appThemeColor,
                                todayHighlightColor: ColorConstant.appThemeColor,
                                yearCellStyle: DateRangePickerYearCellStyle(
                                    todayTextStyle: TextStyle(color: ColorConstant.appThemeColor),
                                    textStyle: TextStyle(color: ColorConstant.appThemeColor)),
                                monthCellStyle: DateRangePickerMonthCellStyle(
                                    todayTextStyle: TextStyle(color: ColorConstant.appThemeColor)),
                                rangeTextStyle: TextStyle(color: ColorConstant.appThemeColor),
                                enablePastDates: false,
                                endRangeSelectionColor: ColorConstant.appThemeColor,
                                initialSelectedRange:
                                    PickerDateRange(DateTime.now(), DateTime.now().add(const Duration(days: 1))),
                              )
                            : SfDateRangePicker(
                                onSelectionChanged:
                                    (DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
                                  DateTime _selectedDate = dateRangePickerSelectionChangedArgs.value;
                                  controller.listOfDate.value = [];
                                  controller.selectedPeopleNumber.value = 1;
                                  startDate = _selectedDate;
                                  controller.startDateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

                                  setState(() {
                                    _rangeDatePickerValueWithDefaultValue = [_selectedDate];
                                    controller.isAllSlotAvailable(false);
                                    controller.getTimeSlots().then((value) {
                                      if (controller.getTimeSlotsResponseModel.value.result!.isNotEmpty) {
                                        controller.selectedTimeSlot.value = 0;
                                        controller.isAllSlotAvailable(true);
                                        controller.isAllSlotLoading(false);
                                        if (activityDetailItem.value.typeOfActivity == "Day") {
                                          controller.checkAvailableBookingSlot();
                                        }
                                      } else {
                                        controller.isAllSlotAvailable(false);
                                        controller.isAllSlotLoading(false);
                                      }
                                    });
                                    controller.showContainer.value = true;
                                  });
                                  // checkSlotAvailability();
                                },
                                initialSelectedDate: startDate ?? DateTime.now(),
                                selectionMode: DateRangePickerSelectionMode.single,
                                selectableDayPredicate: (DateTime dateTime) {
                                  return controller.availableDays.contains(dateTime);
                                },
                                rangeSelectionColor: ColorConstant.appThemeColor.withOpacity(.1),
                                selectionColor: ColorConstant.appThemeColor,
                                startRangeSelectionColor: ColorConstant.appThemeColor,
                                todayHighlightColor: ColorConstant.appThemeColor,
                                yearCellStyle: DateRangePickerYearCellStyle(
                                    todayTextStyle: TextStyle(color: ColorConstant.appThemeColor),
                                    textStyle: TextStyle(color: ColorConstant.appThemeColor)),
                                monthCellStyle: DateRangePickerMonthCellStyle(
                                    todayTextStyle: TextStyle(color: ColorConstant.appThemeColor)),
                                rangeTextStyle: TextStyle(color: ColorConstant.appThemeColor),
                                enablePastDates: false,
                                endRangeSelectionColor: ColorConstant.appThemeColor,
                                initialSelectedRange:
                                    PickerDateRange(DateTime.now(), DateTime.now().add(const Duration(days: 1))),
                              );
                  }),
                ),
                if (activityDetailItem.value.typeOfActivity == "Day")
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: ColorConstant.lightTextGrayColor.withOpacity(.3)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${toLabelValue(ConstantsLabelKeys.note)}: ',
                            style:
                                TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorConstant.blackColor),
                          ),
                          SizedBox(
                            width: Get.width * .71,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    toLabelValue(ConstantsLabelKeys.double_tap_note),
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.normal, color: ColorConstant.blackColor),
                                  ),
                                  // Text(
                                  //   toLabelValue(
                                  //       ConstantsLabelKeys.correct_ifo_lbl),
                                  //   maxLines: 3,
                                  //   style: TextStyle(
                                  //       fontSize: 12,
                                  //       fontWeight: FontWeight.normal,
                                  //       color: ColorConstant.blackColor),
                                  // ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${toLabelValue("selected_item")} :',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorConstant.blackColor),
                      ),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Text(
                          ' ${activityDetailItem.value.itemName}',
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: ColorConstant.blackColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Divider(thickness: 1, height: 1, color: ColorConstant.lightTextGrayColor),

                //  Expanded(child: SizedBox()),
                if (activityDetailItem.value.typeOfActivity == 'Time' &&
                    (startDate != null && startDate.toString() != ""))
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () {
                        if (controller
                                .getTimeSlotsResponseModel.value.result?[controller.selectedTimeSlot.value].timeSlot !=
                            null) {
                          _showDialog(
                              CustomPickerWidget(
                                controller: controller,
                              ),
                              context);
                        }
                      },
                      child: Obx(() {
                        if (controller.showLoader.isTrue) {
                          return Container();
                        } else {
                          if (controller.getTimeSlotsResponseModel.value.result != null &&
                              controller.getTimeSlotsResponseModel.value.result!.isNotEmpty &&
                              controller.getTimeSlotsResponseModel.value.result?[controller.selectedTimeSlot.value]
                                      .timeSlot !=
                                  null) {
                            return SizedBox(
                              // height: Get.height * 0.3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "${toLabelValue("select_time_slot")} : ${controller.getTimeSlotsResponseModel.value.result?[controller.selectedTimeSlot.value].timeSlot}"),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    size: 40,
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Text(toLabelValue("no_slots_available"));
                          }
                        }
                      }),
                    ),
                  ),
                Obx(
                  () => AnimatedContainer(
                    duration: const Duration(milliseconds: 10),
                    height: controller.showContainer.value ? Get.height * .3 : 0,
                    color: ColorConstant.whiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Divider(thickness: 1, height: 1, color: ColorConstant.lightTextGrayColor),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(
                            providerName.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: activityDetailItem.value.typeOfActivity == 'Day' ? 20 : 0,
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Row(
                            children: [
                              Text(
                                (startDate == null && endDate == null) ? "" : '${toLabelValue("your_booking_date")} : ',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                (startDate == null && endDate == null)
                                    ? ""
                                    : (selectedStartDate == selectedEndDate)
                                        ? DateFormat('d MMM yyyy').format(startDate ?? DateTime.now())
                                        : '  ${toLabelValue(ConstantStrings.from_date_label)} ${startDate == null ? "" : DateFormat('d MMM yyyy').format(startDate ?? DateTime.now())}   ${toLabelValue(ConstantStrings.to_date_label)}   ${endDate == null ? "" : DateFormat('d MMM yyyy').format(endDate ?? DateTime.now())}',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.normal, color: ColorConstant.appThemeColor),
                              ),
                            ],
                          ),
                        ),
                        if (activityDetailItem.value.typeOfActivity == 'Time')
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0, right: 16),
                            child: Row(
                              children: [
                                Text(
                                  '${toLabelValue(ConstantStrings.your_booking_date)} : ',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  DateFormat('d MMM yyyy').format(startDate ?? DateTime.now()),
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.normal, color: ColorConstant.appThemeColor),
                                ),
                              ],
                            ),
                          ),
                        if (startDate != null &&
                            activityDetailItem.value.noOfPeople.toString() != '0' &&
                            controller.showContainer.value)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(toLabelValue(
                                    //     ConstantStrings.adults)),
                                    Text(toLabelValue(ConstantStrings.adult_age_message)),
                                  ],
                                ),
                                Row(children: [
                                  CounterButton(
                                      isAdd: false,
                                      onButtonTap: () {
                                        if (controller.selectedPeopleNumber.value > 1) {
                                          controller.selectedPeopleNumber.value =
                                              controller.selectedPeopleNumber.value - 1;
                                          if (activityDetailItem.value.discountedPrice == 0) {
                                            controller.totalAmount.value =
                                                (double.parse(activityDetailItem.value.initialPrice.toString()) *
                                                        controller.diffrerence *
                                                        controller.selectedPeopleNumber.value)
                                                    .toString();
                                          } else {
                                            controller.totalAmount.value =
                                                (double.parse(activityDetailItem.value.discountedPrice.toString()) *
                                                        controller.diffrerence *
                                                        controller.selectedPeopleNumber.value)
                                                    .toString();
                                          }
                                        }
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Obx(() {
                                      return SizedBox(
                                        width: 18,
                                        child: Text(controller.selectedPeopleNumber.value.toString(),
                                            textAlign: TextAlign.center),
                                      );
                                    }),
                                  ),
                                  CounterButton(
                                      isAdd: true,
                                      onButtonTap: () {
                                        if (activityDetailItem.value.typeOfActivity == "Day") {
                                          if (int.parse(controller
                                                      .checkAvailableBookingSlotModel.value.result?.first.availableSlot
                                                      .toString() ??
                                                  '0') >
                                              controller.selectedPeopleNumber.value) {
                                            controller.selectedPeopleNumber.value =
                                                controller.selectedPeopleNumber.value + 1;
                                          }
                                        } else {
                                          if (controller.getTimeSlotsResponseModel.value.result != null) {
                                            for (var element in controller.getTimeSlotsResponseModel.value.result!) {
                                              if (element.id ==
                                                      controller.getTimeSlotsResponseModel.value
                                                          .result?[controller.selectedTimeSlot.value].id &&
                                                  activityDetailItem.value.noOfPeople.toString() != '0') {
                                                if (int.parse(element.availableSlot.toString() ?? '0') >
                                                    controller.selectedPeopleNumber.value) {
                                                  controller.selectedPeopleNumber.value =
                                                      controller.selectedPeopleNumber.value + 1;
                                                }
                                              }
                                            }
                                          }
                                        }
                                        if (activityDetailItem.value.discountedPrice == 0) {
                                          controller.totalAmount.value =
                                              (double.parse(activityDetailItem.value.initialPrice.toString()) *
                                                      controller.diffrerence *
                                                      controller.selectedPeopleNumber.value)
                                                  .toString();
                                        } else {
                                          controller.totalAmount.value =
                                              (double.parse(activityDetailItem.value.discountedPrice.toString()) *
                                                      controller.diffrerence *
                                                      controller.selectedPeopleNumber.value)
                                                  .toString();
                                        }
                                      }),
                                ])
                              ],
                            ),
                          ),
                        ListTile(
                            title: Text(
                              activityDetailItem.value.discountedPrice == 0
                                  ? activityDetailItem.value.initialPrice == 0
                                      ? toLabelValue(ConstantsLabelKeys.label_free)
                                      : '${generalSetting?.result?.first.currency ?? ''} ${controller.totalAmount.value}'
                                  : '${generalSetting?.result?.first.currency ?? ''} ${controller.totalAmount.value}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: activityDetailItem.value.initialPrice == 0
                                      ? ColorConstant.greenColor
                                      : ColorConstant.appThemeColor),
                            ),
                            subtitle: Text(
                              '${controller.diffrerence} ${toLabelValue(ConstantStrings.days_label)}',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal, color: ColorConstant.lightTextGrayColor),
                            ),
                            trailing: controller.showLoader.value
                                ? SizedBox(width: Get.width * 0.1, child: const CommonLoading())
                                : controller.isAllSlotLoading.value
                                    ? const CircularProgressIndicator()
                                    : GetBuilder<BookingCalendarController>(
                                        builder: (controller) {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: ColorConstant.appThemeColor,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: ColorConstant.whiteColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: controller.isAllSlotAvailable.value
                                                ? () {
                                                    Get.toNamed(AppRouteNameConstant.checkoutBookingScreen);
                                                  }
                                                : null,
                                            child: Text(
                                              toLabelValue(ConstantStrings.confirmBooking),
                                              style: TextStyle(
                                                  color: ColorConstant.whiteColor, fontWeight: FontWeight.w600),
                                            ),
                                          );
                                        },
                                      ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showDialog(Widget child, BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  void checkSlotAvailability({bool? isInit}) async {
    controller.dateSlotId.value = '';
    selectedStartDate.value = controller.startDateStr;
    selectedEndDate.value = controller.endDateStr;

    selectedSlot.value =
        controller.getTimeSlotsResponseModel.value.result?[controller.selectedTimeSlot.value].timeSlot ?? "";

    String? userId = await SharedPref.getString(PreferenceConstants.userId);

    await TalatService().checkSlotAvailability({
      ConstantStrings.userTypeKey: '1',
      ConstantStrings.userIdKey: userId,
      ConstantStrings.deviceTypeKey: '1',
      ConstantStrings.deviceTokenKey: controller.token,
      ConstantStrings.userIdKey: controller.userId,
      "item_id": activityDetailItem.value.itemId,
      "item_price": (activityDetailItem.value.discountedPrice == 0 || activityDetailItem.value.discountedPrice == null)
          ? activityDetailItem.value.initialPrice
          : activityDetailItem.value.discountedPrice,
      "start_date": controller.startDateStr,
      "end_date": controller.endDateStr,
      "time_slot_id": controller.getTimeSlotsResponseModel.value.result?[controller.selectedTimeSlot.value].id ?? '',
      "type_of_activity": activityDetailItem.value.typeOfActivity == "Day" ? 1 : 2,
    }).then((value) async {
      controller.isAllSlotLoading(true);

      int availableSlot = 0;

      if (json.decode(value.toString())["code"].toString() == '200') {
        try {
          debugPrint(" Slot Availability ==========> $value");
          debugPrint(" Slot Availability json.decode ==========> ${json.decode(value.toString())["result"]}");
          if (json.decode(value.toString())["result"] != null) {
            if (activityDetailItem.value.typeOfActivity == "Time") {
              print('Time response ===================>>> ${json.decode(value.toString())["result"]["availablility"]}');
              if (json.decode(value.toString())["result"]["availablility"] == "Available") {
                isFromCalendar.value = "1";
                controller.isAllSlotAvailable(true);
                controller.isAllSlotLoading(false);
                if (activityDetailItem.value.typeOfActivity == "Day") {
                  controller.checkAvailableBookingSlot();
                } else {
                  controller.showContainer(true);
                  controller.update();
                }
              } else {
                controller.isAllSlotAvailable(false);
                controller.isAllSlotLoading(false);
                if (json.decode(value.toString())["result"]["availablility"] == "Not Available") {
                  if (isInit == null || (isInit != null && !isInit)) {
                    CommonWidgets().showToastMessage("slot_not_available", isShortToast: true);
                  }
                }
              }
            } else {
              if (json.decode(value.toString())["result"].length > 0) {
                for (int i = 0; i < json.decode(value.toString())["result"].length; i++) {
                  if (json.decode(value.toString())["result"][i]["availablility"] == "Available") {
                    availableSlot = availableSlot + 1;
                    if (controller.dateSlotId.value == "") {
                      controller.dateSlotId.value = "${json.decode(value.toString())["result"][i]["id"]}";
                    } else {
                      if (!controller.dateSlotId.value
                          .contains('${json.decode(value.toString())["result"][i]["id"]}')) {
                        controller.dateSlotId.value =
                            "${controller.dateSlotId.value},${json.decode(value.toString())["result"][i]["id"]}";
                      }
                    }
                    isFromCalendar.value = "1";
                    try {} catch (e) {
                      debugPrint(e.toString());
                    }
                  } else {
                    if (json.decode(value.toString())["result"][i]["availablility"] == "Not Available") {
                      controller.isAllSlotAvailable(false);
                      controller.isAllSlotLoading(false);
                      if (isInit == null || (isInit != null && !isInit)) {
                        CommonWidgets().showToastMessage("slot_not_available", isShortToast: true);
                      }
                    }
                  }
                  if (availableSlot > 0) {
                    controller.isAllSlotAvailable(true);
                    controller.isAllSlotLoading(false);
                    controller.update();
                    // if (activityDetailItem.value.typeOfActivity == "Day") {
                    //   controller.checkAvailableBookingSlot();
                    // }
                  }
                }
              } else {
                controller.isAllSlotAvailable(false);
                controller.isAllSlotLoading(false);
              }
            }
          } else {
            controller.isAllSlotAvailable(false);
            controller.isAllSlotLoading(false);
            if (value.data["message"] == "something_went_wrong") {
              Get.offAllNamed(AppRouteNameConstant.tabScreen);
              CommonWidgets().showToastMessage(value.data["message"]);
            } else {
              if (isInit == null || (isInit != null && !isInit)) {
                CommonWidgets().showToastMessage("slot_not_available", isShortToast: true);
              }
            }
          }
          if (controller.isAllSlotAvailable.isTrue) {
            print("START DATE = ${selectedStartDate}");
            print("END DATE = ${selectedEndDate}");
            if (selectedEndDate.isNotEmpty && selectedStartDate.isNotEmpty) {
              if (selectedStartDate != selectedEndDate) {
                controller.totalAmount.value = (int.parse(controller.totalAmount.value) * 2).toString();
              }
            }
          }
          controller.update();
        } catch (e) {
          // controller.isAllSlotAvailable(false);
          controller.isAllSlotLoading(false);
        }
      } else if (json.decode(value.toString())["code"].toString() == '-1') {
        controller.isAllSlotLoading(false);
        controller.isAllSlotAvailable(false);
        CommonWidgets().showToastMessage(json.decode(value.toString())["message"].toString());

        language = await SharedPref.getString(PreferenceConstants.laguagecode);

        await SharedPref.clearSharedPref();
        await SharedPref.setString(PreferenceConstants.laguagecode, language);
        Get.offAllNamed(AppRouteNameConstant.tabScreen);
      }
    });
  }

  void preSelectedDate({bool? isInit}) {
    List<DateTime> dates = [];
    dates.add(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));

    if (activityDetailItem.value.typeOfActivity == 'Day') {
      dates.add(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(days: 1)));
      // controller.listOfDate.value = [];

      startDate = dates[0];
      endDate = dates[1];
      List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
        List<DateTime> days = [];
        for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
          days.add(startDate.add(Duration(days: i)));
        }
        return days;
      }

      List<DateTime> days = getDaysInBetween(startDate!, endDate!);

      if (controller.listOfDate.isEmpty) {
        for (var day in days) {
          controller.listOfDate.add(day.toString().split(' ')[0]);
        }
      } else {
        controller.listOfDate.clear();
        for (var day in days) {
          controller.listOfDate.add(day.toString().split(' ')[0]);
        }
      }

      if (dates.length > 1) {
        controller.diffrerence = dates[1].difference(dates[0]!).inDays + 1;
        controller.startDateStr = DateFormat('yyyy-MM-dd').format(startDate!);
        controller.endDateStr = DateFormat('yyyy-MM-dd').format(endDate!);
        if (activityDetailItem.value.discountedPrice == 0) {
          controller.totalAmount.value = (double.parse(activityDetailItem.value.initialPrice.toString()) *
                  controller.diffrerence *
                  controller.selectedPeopleNumber.value)
              .toString();
        } else {
          controller.totalAmount.value = (double.parse(activityDetailItem.value.discountedPrice.toString()) *
                  controller.diffrerence *
                  controller.selectedPeopleNumber.value)
              .toString();
        }
      }

      Duration diff = dates[0].difference(dates[1]);
      totalDays = diff.inDays.toString();

      setState(() {
        _rangeDatePickerValueWithDefaultValue = dates;
        controller.showContainer.value = true;
      });
      checkSlotAvailability(isInit: isInit);
    } else if (activityDetailItem.value.typeOfActivity == 'Time') {
      DateTime _selectedDate = dates.first;
      controller.listOfDate.value = [];

      startDate = _selectedDate;
      controller.startDateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

      setState(() {
        _rangeDatePickerValueWithDefaultValue = [_selectedDate];
        controller.getTimeSlots().then((value) {
          if (controller.getTimeSlotsResponseModel.value.result != null &&
              controller.getTimeSlotsResponseModel.value.result!.isNotEmpty) {
            controller.selectedTimeSlot.value = 0;
            checkSlotAvailability(isInit: isInit);
          }
        });
        controller.showContainer.value = true;
        controller.update();
      });
    }
  }
}

class CounterButton extends StatelessWidget {
  final bool isAdd;
  final VoidCallback onButtonTap;

  const CounterButton({
    super.key,
    required this.isAdd,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.0),
            shape: BoxShape.circle,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(100.0),
            onTap: onButtonTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isAdd ? Icons.add : Icons.remove,
                color: Colors.black,
              ),
            ),
          ),
        ));
  }
}

class CustomPickerWidget extends StatelessWidget {
  final BookingCalendarController controller;

  const CustomPickerWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 32.0,
      onSelectedItemChanged: (value) {
        controller.selectedTimeSlot.value = value;
      },
      // backgroundColor: Colors.black,
      scrollController: FixedExtentScrollController(initialItem: controller.selectedTimeSlot.value),

      children: List<Widget>.generate(controller.getTimeSlotsResponseModel.value.result?.length ?? 0, (index) {
        var result = controller.getTimeSlotsResponseModel.value.result?[index];
        return Text(result?.timeSlot ?? '');
      }),
    );
  }
}

class CheckoutDetailModel {
  final String? serviceProviderName;
  final String? price;
  final String? startDate;
  final String? endDate;
  final String? timeSlot;
  final String? lat;
  final String? lng;
  final String? specialInstruction;

  CheckoutDetailModel(
      {this.serviceProviderName,
      this.price,
      this.startDate,
      this.endDate,
      this.timeSlot,
      this.lat,
      this.lng,
      this.specialInstruction});
}
