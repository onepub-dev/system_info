import 'dart:io';

import 'package:system_info2/src/platform/memory_macos.dart';
import 'package:system_info2/system_info2.dart';
import 'package:test/test.dart';

void main() {
  test('hw.memsize is already bytes and never queries a page size', () {
    var calls = 0;
    final bytes = getMacOsTotalPhysicalMemory(run: (executable, arguments) {
      calls++;
      expect(executable, 'sysctl');
      expect(arguments, ['-n', 'hw.memsize']);
      return '17179869184\n';
    });
    expect(bytes, 17179869184);
    expect(calls, 1);
  });
  test('preserves zero sentinel for unavailable or malformed sysctl', () {
    for (final output in <String?>[null, '', 'invalid']) {
      expect(getMacOsTotalPhysicalMemory(run: (_, __) => output), 0);
    }
  });
  test('public total matches native sysctl', () {
    final result = Process.runSync('sysctl', ['-n', 'hw.memsize']);
    expect(result.exitCode, 0);
    expect(SysInfo.getTotalPhysicalMemory(),
        int.parse(result.stdout.toString().trim()));
  }, skip: !Platform.isMacOS);
}
