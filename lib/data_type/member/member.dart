import 'package:login_v2/data_type/member/history/member_history.dart';
import 'package:login_v2/data_type/member/history/member_history_entry.dart';
import 'package:login_v2/data_type/member/member_simple.dart';

class Member {
  Member({required this.name, required this.id, required this.history});

  String name;
  final int id;
  MemberHistory history;

  factory Member.create(String memberName, int identifier) {
    final name = memberName;
    final id = identifier;
    return Member(name: name, id: id, history: MemberHistory.empty());
  }

  factory Member.from(Map<String, dynamic> map) {
    final name = map['name'];
    final id = map['id'];
    final history = MemberHistory.from(map['history']);
    return Member(name: name, id: id, history: history);
  }

  factory Member.empty() {
    return Member(name: "", id: 0, history: MemberHistory.empty());
  }

  void addHistory(MemberHistoryEntry entry) {
    history.entries.add(entry);
  }

  Map<String, dynamic> map() {
    return {
      'name': name,
      'id': id,
      'history': history.list()
    };
  }

  SimpleMember simplify() {
    return SimpleMember(name: name, id: id);
  }
}