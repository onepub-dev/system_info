import 'dart:collection';
import 'dart:io';

import 'package:globbing/glob_lister.dart';

import 'file_path.dart';

class FileList extends Object with ListMixin<String> {
  static final bool _isWindows = Platform.isWindows;

  final Directory directory;

  late bool _caseSensitive;

  late List<String> _files;

  void Function(String path)? _notify;

  late String _pattern;

  /// Creates file list.
  ///
  /// Parameters:
  ///  [directory]
  ///   Directory whic will be listed.
  ///  [pattern]
  ///   Glob pattern of this file list.
  ///  [caseSensitive]
  ///   True, if the pattern is case sensitive; otherwise false.
  ///  [notify]
  ///   Function that is called whenever an item is added.
  FileList(this.directory, String pattern,
      {bool? caseSensitive, void Function(String path)? notify}) {
    if (caseSensitive == null) {
      if (_isWindows) {
        caseSensitive = false;
      } else {
        caseSensitive = true;
      }
    }

    _caseSensitive = caseSensitive;
    _notify = notify;
    _pattern = FilePath.expand(pattern);
    _files = _getFiles();
  }

  /// Returns the length.
  @override
  int get length => _files.length;

  /// Sets the length;
  @override
  set length(int length) {
    throw UnsupportedError('length=');
  }

  @override
  String operator [](int index) => _files[index];

  @override
  void operator []=(int index, String value) {
    throw UnsupportedError('[]=');
  }

  bool _exists(String path) {
    if (!Directory(path).existsSync()) {
      if (!File(path).existsSync()) {
        if (!Link(path).existsSync()) {
          return false;
        }
      }
    }

    return true;
  }

  List<String> _getFiles() {
    final lister = GlobLister(_pattern,
        caseSensitive: _caseSensitive,
        exists: _exists,
        isDirectory: _isDirectory,
        isWindows: _isWindows,
        list: _list);
    return lister.list(directory.path, notify: _notify) ?? <String>[];
  }

  bool _isDirectory(String path) => Directory(path).existsSync();

  List<String> _list(String path, bool? followLinks) {
    List<String> result;
    try {
      result = Directory(path)
          .listSync(followLinks: followLinks ?? true)
          .map((e) => e.path)
          .toList();
    } catch (e) {
      result = <String>[];
    }

    return result;
  }
}
