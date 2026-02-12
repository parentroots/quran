import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';

class CalendarController extends GetxController {
  final Rx<DateTime> selectedGregorianDate = DateTime.now().obs;
  final Rx<HijriCalendar> selectedHijriDate = HijriCalendar.now().obs;

  final RxList<String> bengaliHijriMonths = [
    'মহররম',
    'সফর',
    'রবিউল আউয়াল',
    'রবিউস সানি',
    'জমাদিউল আউয়াল',
    'জমাদিউস সানি',
    'রজব',
    'শাবান',
    'রমজান',
    'শাওয়াল',
    'জিলকদ',
    'জিলহজ্জ'
  ].obs;

  void updateDate(DateTime date) {
    selectedGregorianDate.value = date;
    selectedHijriDate.value = HijriCalendar.fromDate(date);
  }

  String getBengaliHijriMonth() {
    return bengaliHijriMonths[selectedHijriDate.value.hMonth - 1];
  }
}
