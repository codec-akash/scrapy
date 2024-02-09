import 'package:intl/intl.dart';

class DateTimeUtil {
  static String dateFormat(DateTime val) {
    return DateFormat('dd-MM-yyyy').format(val);
  }

  static String dateFormatToDateTime(DateTime val) {
    DateFormat format = DateFormat('MMM dd, yyyy');
    return format.format(val);
  }

  static String dateTimeSeperatorFormat(DateTime val) {
    DateFormat format = DateFormat('EE dd MMM | hh:mm a');
    return format.format(val);
  }
}
