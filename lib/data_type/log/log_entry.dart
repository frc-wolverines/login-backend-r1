import 'package:login_v2/data_type/log/log_entry_simple.dart';
import 'package:login_v2/data_type/member/member.dart';
import 'package:login_v2/data_type/member/member_simple.dart';
import 'package:login_v2/data_type/time.dart';

class LogEntry {
  LogEntry({required this.id, required this.loginTime, required this.logoutTime, required this.totalTime, required this.present});

  final int id;
  Time loginTime;
  Time logoutTime;
  Time totalTime;
  bool present;

  factory LogEntry.from(Map<String, dynamic> map) {
    final id = map['id'] as int;
    final login = Time.from(map['login']);
    final Time logout = Time.from(map['logout']);
    final Time time = Time.from(map['time']);
    final present = map['present'] as bool;

    return LogEntry(id: id, loginTime: login, logoutTime: logout, totalTime: time, present: present);
  }

  factory LogEntry.login(SimpleMember member) {
    final id = member.id;
    final Time login = Time.now();
    final Time logout = Time.from("00:00");
    final Time time = Time.from("00:00");
    final present = true;

    return LogEntry(id: id, loginTime: login, logoutTime: logout, totalTime: time, present: present);
  }

  void logout() {
    logoutTime = Time.now();
    totalTime = Time.difference(logoutTime, loginTime);
    present = false;
  }

  Map<String, dynamic> map() {
    return {
      'id': id,
      'login': loginTime.string(),
      'logout': logoutTime.string(),
      'time': totalTime.string(),
      'present': present
    };
  }

  SimpleLogEntry simplify() {
    return SimpleLogEntry(loginTime: loginTime, logoutTime: logoutTime, totalTime: totalTime, present: present, id: id);
  }
}