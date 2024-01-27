import 'package:intl/intl.dart';

String date12format(DateTime date) {
  var hour12Format = DateFormat("yyyy-MM-dd h:mm a");
  final formatedDate = hour12Format.format(date);
  return formatedDate;
}
