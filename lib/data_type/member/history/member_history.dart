import 'package:login_v2/data_type/member/history/member_history_entry.dart';

class MemberHistory {
  MemberHistory({required this.entries});

  List<MemberHistoryEntry> entries;

  factory MemberHistory.from(List<Map<String, dynamic>> list) {
    List<MemberHistoryEntry> entries = List.empty(growable: true);
    for(final i in list) {
      entries.add(MemberHistoryEntry.from(i));
    }
    return MemberHistory(entries: entries);
  }

  factory MemberHistory.empty() {
    return MemberHistory(entries: List<MemberHistoryEntry>.empty(growable: true));
  }

  List<Map<String, dynamic>> list() {
    List<Map<String, dynamic>> maps = List.empty(growable: true);
    for(final i in entries) {
      maps.add(i.map());
    }
    return maps;
  }
}