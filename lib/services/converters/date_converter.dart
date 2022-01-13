import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class DateConverter{
  static String convertToLongDate(Timestamp date) {
    return DateFormat('dd MMM yyyy kk:mm').format(date.toDate());
  }

  static String convertToShortDate(Timestamp date) {
    return DateFormat('dd MMM yy').format(date.toDate());
  }
}