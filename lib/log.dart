// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart' show DateFormat;

class YimLog {
  factory YimLog() {
    return _singleton;
  }
  static YimLog get instance => _singleton;
  static final YimLog _singleton = YimLog._internal();

  YimLog._internal();
  File? _logFile;
  File? _sessionLogFile;
  String? _sessionIdentity;
  StreamController? _streamController;
  Stream? get logStream => _streamController?.stream;
  final List<String> _waitInsertLogQueue = [];

  Future clearLogFile() async {
    var logDir = await _getLogDir();
    if (await logDir.exists()) {
      for (var item in logDir.listSync()) {
        if (FileSystemEntity.isFileSync(item.path)) {
          item.deleteSync();
        } else {
          if ((_logFile != null && dirname(_logFile!.path) != item) && _sessionLogFile != null && dirname(_sessionLogFile!.path) != item) {
            item.deleteSync(recursive: true);
          }
        }
      }
    }
  }

  bool _needInsert = false;
  void _setNeedInsert() {
    if (_needInsert == false) {
      _needInsert = true;
      Future.delayed(const Duration(seconds: 1), () async {
        String insertLog = _waitInsertLogQueue.join("\n\n\n");
        _needInsert = false;
        await _logFile?.writeAsString(insertLog, mode: FileMode.writeOnlyAppend, encoding: utf8);
        await _sessionLogFile?.writeAsString(insertLog, mode: FileMode.writeOnlyAppend, encoding: utf8);
      });
    }
  }

  void _insertLog(String log) {
    _waitInsertLogQueue.add(log);
    _setNeedInsert();
  }

  Future init() async {
    _streamController = StreamController.broadcast();
    _sessionIdentity = "${DateTime.now().microsecondsSinceEpoch.toString()}${Random().nextInt(100000)}";
    await _reloadFile();
    var now = DateTime.now();
    Future.delayed(DateTime(now.year, now.month, now.day).add(const Duration(days: 1)).difference(now), () {
      _reloadFile();
    });
    logStream!.listen((event) async {
      _insertLog("$event");
    });
  }

  Future _reloadFile() async {
    _logFile = await _getTodayLogFile();
    _sessionLogFile = await _getSessionLogFile();
  }

  Future<Directory> _getLogDir() async {
    var dir = await getApplicationDocumentsDirectory();
    var logDir = Directory(join(dir.path, "log"));
    if ((await logDir.exists() == false)) await logDir.create();
    return logDir;
  }

  Future<File> _getTodayLogFile() async {
    var logDir = await _getLogDir();
    var todayLogDir = Directory(join(logDir.path, DateFormat('yyyy-MM-dd').format(DateTime.now())));
    if (todayLogDir.existsSync() == false) todayLogDir.createSync();
    var logFile = File(join(todayLogDir.path, "${DateFormat('yyyy-MM-dd').format(DateTime.now())}.txt"));
    if ((await logFile.exists()) == false) await logFile.create();
    return logFile;
  }

  Future<File> _getSessionLogFile() async {
    var logDir = await _getLogDir();
    var todayLogDir = Directory(join(logDir.path, DateFormat('yyyy-MM-dd').format(DateTime.now())));
    if (todayLogDir.existsSync() == false) todayLogDir.createSync();
    var logFile = File(join(todayLogDir.path, "$_sessionIdentity.txt"));
    if ((await logFile.exists()) == false) await logFile.create();

    return logFile;
  }

  Future<String?> getTodayLog() async => await _logFile?.readAsString();
  Future<String?> getSessionLog() async => await _sessionLogFile?.readAsString();
  Future clearTodayLog() async => await _logFile?.writeAsString("", mode: FileMode.writeOnly);
  Future clearSessionLog() async => await _sessionLogFile?.writeAsString("", mode: FileMode.writeOnly);

  void debugLog(Object txt, {bool jsonFormart = false}) {
    String outputText = "$txt";
    if (jsonFormart) outputText = formartJsonText(txt);
    outputText = "【debug】【${DateFormat('HH:mm:ss').format(DateTime.now())}】$outputText";
    _streamController?.sink.add(outputText);
    if (kDebugMode) debugPrint(outputText, wrapWidth: 1024);
  }

  void errorLog(Object txt, {bool jsonFormart = false}) {
    String outputText = "$txt";
    if (jsonFormart) outputText = formartJsonText(txt);
    outputText = "【error】【${DateFormat('HH:mm:ss').format(DateTime.now())}】$outputText";
    _streamController?.sink.add(outputText);
    if (kDebugMode) debugPrint(outputText, wrapWidth: 1024);
  }

  String formartJsonText(Object txt) {
    String outputText = "$txt";
    try {
      if (txt is String) {
        outputText = const JsonEncoder.withIndent("     ").convert(jsonDecode(txt));
      } else {
        outputText = const JsonEncoder.withIndent("     ").convert(txt);
      }
    } catch (e) {
      outputText = "$txt";
    }
    return outputText;
  }

  void dispose() {
    _streamController!.close();
  }
}

void debugLog(Object txt, {bool jsonFormart = false}) => YimLog().debugLog(txt, jsonFormart: jsonFormart);

void errorLog(Object txt, {bool jsonFormart = false}) => YimLog().errorLog(txt, jsonFormart: jsonFormart);
