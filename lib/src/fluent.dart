//, strict_raw_type

import 'dart:io';

Fluent fluent(Object? value) => Fluent(value);

class Fluent {
  dynamic value;

  Fluent(this.value);

  List<Map<String, String>>? get groupsValue {
    if (value is List<Map<String, String>>) {
      return value as List<Map<String, String>>?;
    }

    return <Map<String, String>>[];
  }

  int get intValue {
    if (value is int) {
      return value as int;
    }

    return 0;
  }

  // Fluent api requires dynamic type
  // ignore: strict_raw_type
  List get listValue {
    if (value is List) {
      return value as List;
    }

    return <dynamic>[];
  }

  // Fluent api requires dynamic type
  // ignore: strict_raw_type
  Map get mapValue {
    if (value is Map) {
      return value as Map;
    }

    return <dynamic, dynamic>{};
  }

  String get stringValue {
    if (value is String) {
      return value as String;
    }

    return '';
  }

  Fluent operator [](Object key) {
    try {
      // Fluent api requires dynamic type
      // ignore: avoid_dynamic_calls
      value = value[key];
    } catch (e) {
      value = null;
    }
    return this;
  }

  void elementAt(int index, [Object? defaultValue]) {
    try {
      // Fluent api requires dynamic type
      // ignore: avoid_dynamic_calls
      value = value[index];
    } catch (e) {
      value = null;
    }

    if (value == null && defaultValue != null) {
      value = defaultValue;
    }
  }

  void exec(String executable, List<String> arguments,
      {bool runInShell = false}) {
    try {
      final result =
          Process.runSync(executable, arguments, runInShell: runInShell);
      if (result.exitCode == 0) {
        value = result.stdout.toString();
      }
    } catch (e) {
      value = null;
    }
  }

  void last() {
    if (value is Iterable) {
      // Fluent api requires dynamic type
      // ignore: avoid_dynamic_calls
      value = value.last;
    } else {
      value = null;
    }
  }

  void listToGroups(String separator) {
    final result = <Map<String, String>>[];
    if (value is! List) {
      value = result;
      return;
    }

    final list = value as List;
    Map<String, String>? map;
    for (final element in list) {
      final string = element.toString();
      final index = string.indexOf(separator);
      if (index != -1) {
        if (map == null) {
          map = {};
          result.add(map);
        }

        final key = string.substring(0, index).trim();
        final value = string.substring(index + 1).trim();
        if (map.containsKey(key)) {
          map = {};
          result.add(map);
        }

        map[key] = value;
      } else {
        map = null;
      }
    }

    value = result;
  }

  void listToMap(String separator) {
    if (value is! List) {
      value = <String, String>{};
      return;
    }

    final list = value as List;
    final map = <String, String>{};
    for (final element in list) {
      final string = element.toString();
      final index = string.indexOf(separator);
      if (index != -1) {
        final key = string.substring(0, index).trim();
        final value = string.substring(index + 1).trim();
        map[key] = value;
      }
    }

    value = map;
  }

  void parseInt([int defaultValue = 0]) {
    if (value == null) {
      value = defaultValue;
    } else {
      value = int.tryParse(value.toString()) ?? defaultValue;
    }
  }

  void replaceAll(String from, String replace) {
    value = value.toString().replaceAll(from, replace);
  }

  void split(String separtor) {
    value = value.toString().split(separtor);
  }

  void stringToList() {
    if (value == null) {
      value = <String>[];
      return;
    }

    var string = value.toString();
    string = string.replaceAll('\r\n', '\n');
    //string = string.replaceAll('\r', '\n');
    value = string.split('\n');
  }

  void stringToMap(String separator) {
    stringToList();
    listToMap(separator);
  }

  void trim() {
    value = value.toString().trim();
  }
}
