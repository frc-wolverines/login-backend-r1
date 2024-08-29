class Time {
  Time({required this.hour, required this.minute});

  int hour;
  int minute;

  ///Creates a Time object representing the current time
  factory Time.now() {
    return Time(hour: DateTime.now().hour, minute: DateTime.now().minute);
  }

  ///Finds the difference in a Time object between x1 and x2
  static Time difference(Time x1, Time x2) {
    int hours = x1.hour  - x2.hour - 1;
    int minutes = x1.minute % 100 + (60 - x2.minute % 100);

    if(minutes >= 60) {
      hours++;
      minutes -= 60;
    }

    return Time(hour: hours, minute: minutes);
  }

  ///Converts a valid time format (hour:minute) string into a Time object
  static Time from(String string) {
    return Time(hour: int.parse("${string[0]}${string[1]}"), minute: int.parse("${string[3]}${string[4]}")); //expected format - hh:mm
  }

  ///Converts a Time object into a readable hour:minute string
  String string() {
    return "${fixDigit(hour)}:${fixDigit(minute)}";
  }

  ///Formats a single digit int to be consistant with a double digit int
  String fixDigit(int x) {
    return x >= 10 ? x.toString() : "0${x.toString()}";
  }

  void add(Time time) {
    hour += time.hour;
    minute += time.minute;

    if(minute >= 60) {
      hour++;
      minute -= 60;
    }
  }
}