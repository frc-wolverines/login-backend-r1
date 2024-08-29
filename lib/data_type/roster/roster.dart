import 'package:login_v2/data_type/member/member.dart';
import 'package:login_v2/data_type/member/member_simple.dart';

class Roster {
  Roster({required this.members});

  List<SimpleMember> members;

  factory Roster.from(List<Map<String, dynamic>> maps) {
    List<SimpleMember> members = List.empty(growable: true);
    for(final i in maps) {
      members.add(SimpleMember.from(i));
    }
    return Roster(members: members);
  }

  factory Roster.empty() {
    return Roster(members: List<SimpleMember>.empty(growable: true));
  }

  void removeByName(String name) {
    members.remove(findByName(name));
  }

  void removeById(int id) {
    members.remove(findById(id));
  }

  void add(SimpleMember member) {
    members.add(member);
  }

  bool containsMemberWithId(int id) {
    for(final i in members) {
      if(i.id == id) {
        return true;
      }
    }
    return false;
  }

  bool containsMemberWithName(String name) {
    for(final i in members) {
      if(i.name == name) {
        return true;
      }
    }
    return false;
  }

  SimpleMember findByName(String name) {
    for(final i in members) {
      if(i.name == name) {
        return i;
      }
    }
    return Member.empty().simplify();
  }

  SimpleMember findById(int id) {
    for(final i in members) {
      if(i.id == id) {
        return i;
      }
    }
    return Member.empty().simplify();
  }

  String getNameOf(int id) {
    for(final i in members) {
      if(i.id == id) {
        return i.name;
      }
    }
    return "";
  }

  int getIdOf(String name) {
    for(final i in members) {
      if(i.name == name) {
        return i.id;
      }
    }
    return 0;
  }

  List<Map<String, dynamic>> list() {
    List<Map<String, dynamic>> maps = List.empty(growable: true);
    for(final i in members) {
      maps.add(i.map());
    }
    return maps;
  }
}