// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:io';

import 'package:path/path.dart' as pathos;

import 'file_utils.dart';
import 'fluent.dart';

String? exec(String executable, List<String> arguments,
    {bool runInShell = false}) {
  try {
    final result =
        Process.runSync(executable, arguments, runInShell: runInShell);
    if (result.exitCode == 0) {
      return result.stdout.toString();
    }
  } catch (e) {
    //
  }

  return null;
}

String? resolveLink(String path) {
  while (true) {
    if (!FileUtils.testfile(path, 'link')) {
      break;
    }

    try {
      // ignore: parameter_assignments
      path = Link(path).resolveSymbolicLinksSync();
    } catch (e) {
      return null;
    }
  }

  return path;
}

void parseLdConf(String path, List<String> paths, Set<String> processed) {
  final _path = resolveLink(path);
  if (_path == null) {
    return;
  }

  final file = File(_path);
  if (!file.existsSync()) {
    return;
  }

  final dir = pathos.dirname(_path);
  for (var line in file.readAsLinesSync()) {
    line = line.trim();
    final index = line.indexOf('#');
    if (index != -1) {
      line = line.substring(0, index);
    }

    if (line.isEmpty) {
      continue;
    }

    var include = false;
    if (line.startsWith('include ')) {
      line = line.substring(8);
      include = true;
    }

    if (pathos.isRelative(line)) {
      line = pathos.join(dir, line);
    }

    if (include) {
      for (final path in FileUtils.glob(line)) {
        if (!processed.contains(path)) {
          processed.add(path);
          parseLdConf(path, paths, processed);
        }
      }
    } else {
      paths.add(line);
    }
  }
}

String? _wmicGetValue(String section, List<String> fields,
    {List<String>? where}) {
  final arguments = <String>[section];
  if (where != null) {
    arguments
      ..add('where')
      ..addAll(where);
  }

  arguments
    ..add('get')
    ..addAll(fields.join(', ').split(' '))
    ..add('/VALUE');
  return exec('wmic', arguments);
}

List<Map<String, String>>? wmicGetValueAsGroups(
    String section, List<String> fields,
    {List<String>? where}) {
  final string = _wmicGetValue(section, fields, where: where);
  return (fluent(string)
        ..stringToList()
        ..listToGroups('='))
      .groupsValue;
}

Map<String, String>? wmicGetValueAsMap(String section, List<String> fields,
    {List<String>? where}) {
  final string = _wmicGetValue(section, fields, where: where);
  return (fluent(string)
        ..stringToList()
        ..listToMap('='))
      .mapValue as Map<String, String>?;
}

String? _statFsGetValue(String mountPoint, List<String> fields) {
  final format = fields.map((f) => '$f=%$f').join('\n');
  return exec('stat', ['-f', '-c', format, mountPoint]);
}

Map<String, String>? statFsGetValueAsMap(
    String mountPoint, List<String> fields) {
  final string = _statFsGetValue(mountPoint, fields);
  return (fluent(string)
        ..stringToList()
        ..listToMap('='))
      .mapValue as Map<String, String>?;
}

Never notSupportedError() {
  throw UnsupportedError('Unsupported operating system.');
}
