import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CommonController extends GetxController {

  
  String getTime(String dateTime) {
    List months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    DateTime dateTimes = DateTime.parse(dateTime);
    DateTime datetimeNow = DateTime.parse(DateTime.now().toString());
    var month = months[dateTimes.month];
    var parsedTime = DateFormat('hh:mm a').format(dateTimes);
    if (dateTimes.hour <= datetimeNow.hour &&
        dateTimes.day == datetimeNow.day &&
        dateTimes.year == datetimeNow.year &&
        dateTimes.month == datetimeNow.month) {
      if (datetimeNow.hour - dateTimes.hour <= 0) {
        var totalMinutes = datetimeNow.minute - dateTimes.minute;
        return '$totalMinutes minutes';
      } else {
        var totalHours = datetimeNow.hour - dateTimes.hour;
        return '$totalHours hours';
      }
    }

    // ignore: prefer_interpolation_to_compose_strings
    return '${'$parsedTime ${dateTimes.day} ' + month},${dateTimes.year}';
  }
}
