import 'package:intl/intl.dart';

class DateTimeHelper{
  static String formatDateTime(String datetime) {
    List arr = datetime.split(" ");
    String time = arr[1];
    List datebrk = arr[0].split("-");
    String day = datebrk[2];
    String month = DateFormat('MMM').format(DateTime(0, int.parse(datebrk[1])));
    String year = datebrk[0];

    return "$day $month $year $time";
  }

  static String closingTime(String datetime) {
    List arr = datetime.split(" ");
    String time = arr[1];

    return "$time";
  }

  static String utcFormatDate(String date) {
    DateTime dt = DateTime.parse(date);
    String res = DateFormat('yMMMd').format(dt);
    return res;
  }
}