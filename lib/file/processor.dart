import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:login_v2/data_type/log/log.dart';
import 'package:login_v2/data_type/member/history/member_history_entry.dart';
import 'package:login_v2/data_type/member/member.dart';
import 'package:login_v2/data_type/member/member_simple.dart';
import 'package:login_v2/data_type/roster/roster.dart';
import 'package:login_v2/util/format_utils.dart';

class MemberProcessor {
  static File rosterFile = File('sample/data/roster.json');
  static Directory memberDirectory = Directory('sample/data/members');

  ///Creates the roster instance which will be used to store basic member information
  ///<br/>If it does exists, does nothing
  static void startRoster() {
    if(rosterFile.existsSync()) return;
    rosterFile.createSync(recursive: true);
    rosterFile.writeAsStringSync(jsonify(Roster.empty().list()));
  }

  ///Returns a Roster object representing the stored Roster
  static Roster getRoster() {
    if(!rosterFile.existsSync()) return Roster.empty();
    return Roster.from(jsonDecode(rosterFile.readAsStringSync()));
  }
  
  ///Creates a new member file and adds them to the roster.
  ///<br/>If it does exists, does nothing
  static void newMember(String name) {
    if(rosterFile.readAsStringSync().contains(name)) return;
    dynamic cachedRoster = jsonDecode(rosterFile.readAsStringSync());
    Roster roster = Roster(members: List<dynamic>.from(cachedRoster)
      .map((i) =>SimpleMember.from(i))
      .toList()
    );

    Member member = Member.create(name, assignId());
    member.addHistory(MemberHistoryEntry.creation());
    File("${memberDirectory.path}/${member.id}.json").createSync(recursive: true);
    File("${memberDirectory.path}/${member.id}.json").writeAsStringSync(jsonify(member.map()));

    roster.add(member.simplify());
    rosterFile.writeAsStringSync(jsonify(roster.list()));
  }

  ///Removes member from roster
  ///<br/>If it doesn't exist, does nothing
  static void removeMember(String name) {
    if(!rosterFile.readAsStringSync().contains(name)) return;
  
    dynamic cachedRoster = jsonDecode(rosterFile.readAsStringSync());
    Roster roster = Roster(members: List<dynamic>.from(cachedRoster)
      .map((i) =>SimpleMember.from(i))
      .toList()
    );

    SimpleMember member = roster.findByName(name);
    roster.removeById(member.id);

    rosterFile.writeAsStringSync(jsonify(roster.list()));

    Member memberData = Member.from(jsonDecode(File("${memberDirectory.path}/${member.id}.json").readAsStringSync()));
    memberData.addHistory(MemberHistoryEntry.removal());
    File("${memberDirectory.path}/${member.id}.json").deleteSync();
    File("${memberDirectory.path}/r${member.id}.json").createSync(recursive: true);
    File("${memberDirectory.path}/r${member.id}.json").writeAsStringSync(jsonify(memberData.map()));
  }

  ///Returns the removal status of a member given their id
  ///<br/>Works by detecting if that id has a "r" prefix to it's file name
  static bool hasBeenRemoved(int id) {
    return File("${memberDirectory.path}/r$id.json").existsSync();
  }

  static int assignId() {
    int num = Random().nextInt(1000000);
    if(!File("${memberDirectory.path}/$num.json").existsSync() || !File("${memberDirectory.path}/r$num.json").existsSync()) return num;
    return assignId();
  }
}

class LogProcessor {
  static Directory logDirectory = Directory('sample/data/logs');
  static File todayLogFile = File('${logDirectory.path}/${nowStringWithHiphen()}.json');
  static Directory memberDirectory = Directory('sample/data/members');

  ///Creates a new log file with no entries
  ///<br/>If it does exist, does nothing
  static void openLog() {
    if(todayLogFile.existsSync()) return;
    todayLogFile.createSync(recursive: true);
    todayLogFile.writeAsStringSync(jsonify(Log.open().map()));
  }

  ///Closes the current day's log
  ///<br/>If it doesn't exist, does nothing
  static void closeLog() {
    if(!todayLogFile.existsSync()) return;
    Log log = Log.from(
      jsonDecode(todayLogFile.readAsStringSync())
    );

    for (final i in log.entries) {
      Member member = Member.from(
        jsonDecode(File("${memberDirectory.path}/${i.id}.json").readAsStringSync())
      );
      member.addHistory(MemberHistoryEntry.log(i));
      File("${memberDirectory.path}/${i.id}.json").writeAsStringSync(jsonify(member.map()));
    }

    log.close();
    todayLogFile.writeAsStringSync(jsonify(log.map()));
  }

  ///Adds a login entry to today's log containing a member identifier
  ///<br/>If log doesn't exist, does nothing
  static void loginMember(SimpleMember member) {
    if(!todayLogFile.existsSync()) return;
    Log log = Log.from(
      jsonDecode(todayLogFile.readAsStringSync())
    );
    if(log.has(member)) return;
    log.login(member);
    todayLogFile.writeAsStringSync(jsonify(log.map()));
  }

  ///Modifies a log entry of today's log to logout that member
  ///<br/>If log doesn't exist, does nothing
  static void logoutMember(SimpleMember member) {
    if(!todayLogFile.existsSync()) return;
    Log log = Log.from(
      jsonDecode(todayLogFile.readAsStringSync())
    );
    if(!log.has(member)) return;
    log.logout(member);
    todayLogFile.writeAsStringSync(jsonify(log.map()));
  }

  ///Returns a Log object representing stored Log data for today
  ///<br/>If log doesn't exist, does nothing
  static Log getToday() {
    if(!todayLogFile.existsSync()) return Log.empty();
    return Log.from(jsonDecode(todayLogFile.readAsStringSync()));
  }

  ///Returns a Log object representing stored Log data for the given date
  ///<br/>If log doesn't exist, does nothing
  static Log getLog(String date) {
    if(!File("${logDirectory.path}/$date.json").existsSync()) return Log.empty();
    return Log.from(jsonDecode(File("${logDirectory.path}/$date.json").readAsStringSync()));
  }
}