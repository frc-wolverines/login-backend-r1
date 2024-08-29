import 'dart:convert';

///Converts a JSON parsable object into a correctly formatted JSON string
String jsonify(dynamic object) {
  final encoder = JsonEncoder.withIndent("    ");
  return encoder.convert(object);
}

///Returns a string with the format: DD-MM-YYYY using today's date 
String nowStringWithHiphen() {
  final String month = DateTime.now().month.toString().length == 1 ? "0${DateTime.now().month}" : "${DateTime.now().month}";
  final String day = DateTime.now().day.toString().length == 1 ? "0${DateTime.now().day}" : "${DateTime.now().day}";

  return "$day-$month-${DateTime.now().year}";
}

///Returns a string with the format: DD-MM-YYYY using the given date
String dateStringWithHiphen(DateTime date) {
  final String month = date.month.toString().length == 1 ? "0${date.month}" : "${date.month}";
  final String day = date.day.toString().length == 1 ? "0${date.day}" : "${date.day}";

  return "$day-$month-${date.year}";
}