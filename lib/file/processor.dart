import 'dart:convert';
import 'dart:io';

import 'package:login_v2/data_type/member/member.dart';
import 'package:login_v2/data_type/member/member_simple.dart';
import 'package:login_v2/data_type/roster/roster.dart';
import 'package:login_v2/util/format_utils.dart';

class FileProcessor {
  static File todayLogFile = File('sample/data/logs/${nowStringWithHiphen()}.json');
  static File rosterFile = File('sample/data/roster.json');
  static Directory memberDirectory = Directory('sample/data/members');

  ///Creates the roster instance which will be used to store basic member information
  ///<br /> If it does exists, does nothing
  static void startRoster() {
    if(rosterFile.existsSync()) return;
    rosterFile.createSync(recursive: true);
    rosterFile.writeAsStringSync(jsonify(Roster.empty().list()));
  }
  
  ///Creates a new member file and adds them to the roster.
  ///<br /> If it does exists, does nothing
  static void newMember(String name) {
    if(rosterFile.readAsStringSync().contains(name)) return;
    Member member = Member.create(name);
    File("${memberDirectory.path}/${member.id}.json").createSync(recursive: true);
    File("${memberDirectory.path}/${member.id}.json").writeAsStringSync(jsonify(member.map()));

    dynamic cachedRoster = jsonDecode(rosterFile.readAsStringSync());
    Roster roster = Roster(members: List<dynamic>.from(cachedRoster)
      .map((i) => SimpleMember.from(i))
      .toList()
    );
    roster.add(member.simplify());
    rosterFile.writeAsStringSync(jsonify(roster.list()));
  }

  ///Removes member from roster and deletes their file
  ///<br /> If it doesn't exist, does nothing
  static void removeMember(String name) {
    if(!rosterFile.readAsStringSync().contains(name)) return;
  
    dynamic cachedRoster = jsonDecode(rosterFile.readAsStringSync());
    Roster roster = Roster(members: List<dynamic>.from(cachedRoster)
      .map((i) => SimpleMember.from(i))
      .toList()
    );

    SimpleMember member = roster.findByName(name);
    roster.removeById(member.id);

    rosterFile.writeAsStringSync(jsonify(roster.list()));
    File("${memberDirectory.path}/${member.id}.json").deleteSync();
  }
}