import 'package:login_v2/data_type/log/log_entry.dart';
import 'package:login_v2/data_type/member/member_simple.dart';
import 'package:login_v2/data_type/time.dart';

class Log {
  Log({required this.entries, required this.opened, required this.closed, required this.total});

  final Time opened;
  Time closed;
  Time total;
  List<LogEntry> entries;

  factory Log.from(Map<String, dynamic> map) {
    final Time opened = Time.from(map['opened']);
    final Time closed = Time.from(map['closed']);
    final Time total = Time.from(map['total']);

    List<LogEntry> entries = List.empty(growable: true);
    for(final i in map['entries']) {
      entries.add(LogEntry.from(i));
    }
    return Log(entries: entries, opened: opened, closed: closed, total: total);
  }

  factory Log.open() {
    final Time opened = Time.now();
    final Time closed = Time.from("00:00");
    final Time total = Time.from("00:00");
    List<LogEntry> entries = List.empty(growable: true);
    return Log(entries: entries, opened: opened, closed: closed, total: total);
  }

  factory Log.empty() {
    return Log(entries: List<LogEntry>.empty(growable: true), opened: Time.from("00:00"), closed: Time.from("00:00"), total: Time.from("00:00"));
  }

  void login(SimpleMember member) {
    entries.add(LogEntry.login(member));
  }

  void logout(SimpleMember member) {
    for(final i in entries) {
      if(i.id == member.id) {
        i.logout();
      }
    }
  }

  void close() {
    closed = Time.now();
    total = Time.difference(closed, opened);
    for(final i in entries) {
      i.logout();
    }
  }

  bool has(SimpleMember member) {
    for(final i in entries) {
      if (i.id == member.id) {
        return true;
      }
    }
    return false;
  }

  Map<String, dynamic> map() {
    List<Map<String, dynamic>> maps = List.empty(growable: true);
    for(final i in entries) {
      maps.add(i.map());
    }
    return {
      'opened': opened.string(),
      'closed': closed.string(),
      'total': total.string(),
      'entries': maps
    };
  }
}