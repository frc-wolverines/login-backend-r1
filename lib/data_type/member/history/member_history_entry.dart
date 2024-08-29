import 'package:login_v2/data_type/log/log_entry.dart';
import 'package:login_v2/data_type/log/log_entry_simple.dart';

class MemberHistoryEntry {
  MemberHistoryEntry({required this.type, required this.description, required this.date, this.logEntry});

  final MemberHistoryEntryType type;
  SimpleLogEntry? logEntry;
  String description;
  final DateTime date;

  factory MemberHistoryEntry.from(Map<String, dynamic> map) {
    final type = MemberHistoryEntryType.from(map['type']);
    final DateTime date = DateTime.parse(map['datetime']);
    final description = map['description'];
    if (type == MemberHistoryEntryType.log) {
      final SimpleLogEntry entry = SimpleLogEntry.from(map['log']);
      return MemberHistoryEntry(type: type, description: description, date: date, logEntry: entry);
    }
    return MemberHistoryEntry(type: type, description: description, date: date);
  }

  factory MemberHistoryEntry.creation() {
    final type = MemberHistoryEntryType.creation;
    final DateTime date = DateTime.now();
    final description = "Member was added to the roster";
    return MemberHistoryEntry(type: type, description: description, date: date);
  }

  factory MemberHistoryEntry.removal() {
    final type = MemberHistoryEntryType.creation;
    final DateTime date = DateTime.now();
    final description = "Member was removed from the roster";
    return MemberHistoryEntry(type: type, description: description, date: date);
  }

  factory MemberHistoryEntry.log(LogEntry log) {
    final type = MemberHistoryEntryType.creation;
    final DateTime date = DateTime.now();
    final description = "Log data";
    final SimpleLogEntry entry = log.simplify();
    return MemberHistoryEntry(type: type, description: description, date: date, logEntry: entry);
  }

  Map<String, dynamic> map() {
    if(type == MemberHistoryEntryType.log) {
      return {
        'type': type.numeric(),
        'description': description,
        'datetime': date.toString(),
        'log': logEntry!.map()
      };
    }

    return {
      'type': type.numeric(),
      'description': description,
      'datetime': date.toString()
    };
  }
}

enum MemberHistoryEntryType {
  creation,
  log,
  removal; 

  int numeric() {
    return switch (this) {
      MemberHistoryEntryType.creation => 0,
      MemberHistoryEntryType.log => 1,
      MemberHistoryEntryType.removal => 2
    };
  }

  static MemberHistoryEntryType from(int numeric) {
    return switch (numeric) {
      0 => MemberHistoryEntryType.creation,
      1 => MemberHistoryEntryType.log,
      2 => MemberHistoryEntryType.removal,
      int() => MemberHistoryEntryType.creation
    };
  }
}