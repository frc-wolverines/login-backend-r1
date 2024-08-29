import 'package:login_v2/data_type/log/log_entry.dart';
import 'package:login_v2/data_type/time.dart';

class SimpleLogEntry extends LogEntry {
  SimpleLogEntry({required super.loginTime, required super.logoutTime, required super.totalTime, required super.present, required super.id});

  factory SimpleLogEntry.from(Map<String, dynamic> map) {
    final id = 0;
    final login = Time.from(map['login']);
    final Time logout = Time.from(map['logout']);
    final Time time = Time.from(map['time']);
    final present = map['present'] as bool;

    return SimpleLogEntry(loginTime: login, logoutTime: logout, totalTime: time, present: present, id: id);
  }

  @override
  Map<String, dynamic> map() {
    return {
      'login': loginTime.string(),
      'logout': logoutTime.string(),
      'time': totalTime.string(),
      'present': present
    };
  }
}