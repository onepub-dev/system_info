import 'dart:io';

import 'package:system_info2/src/platform/memory_windows.dart';
import 'package:system_info2/system_info2.dart';
import 'package:test/test.dart';

void main() {
  final cases = <WindowsMemoryMetric, List<Object>>{
    WindowsMemoryMetric.freePhysical: [
      'Win32_OperatingSystem',
      'FreePhysicalMemory',
      2048 * 1024
    ],
    WindowsMemoryMetric.freeVirtual: [
      'Win32_OperatingSystem',
      'FreeVirtualMemory',
      2048 * 1024
    ],
    WindowsMemoryMetric.totalPhysical: [
      'Win32_ComputerSystem',
      'TotalPhysicalMemory',
      2048
    ],
    WindowsMemoryMetric.totalVirtual: [
      'Win32_OperatingSystem',
      'TotalVirtualMemorySize',
      2048 * 1024
    ],
    WindowsMemoryMetric.processVirtual: ['Win32_Process', 'VirtualSize', 2048],
  };
  for (final entry in cases.entries) {
    test('${entry.key.name}: queries CIM without WMIC and preserves units', () {
      var calls = 0;
      final value = getWindowsMemory(entry.key, processId: 4321,
          run: (executable, arguments) {
        calls++;
        expect(executable, 'powershell.exe');
        expect(arguments.take(4),
            ['-NoLogo', '-NoProfile', '-NonInteractive', '-Command']);
        expect(arguments.last,
            contains('Get-CimInstance -ClassName ${entry.value[0]}'));
        expect(arguments.last,
            contains('.${entry.value[1]} | ConvertTo-Json -Compress'));
        expect(arguments.last, contains(r"$ErrorActionPreference = 'Stop'"));
        expect(arguments.last, contains('-ErrorAction Stop'));
        if (entry.key == WindowsMemoryMetric.processVirtual) {
          expect(arguments.last, contains('-Filter "ProcessId = 4321"'));
        } else {
          expect(arguments.last, isNot(contains('-Filter')));
        }
        return '2048\r\n';
      });
      expect(value, entry.value[2]);
      expect(calls, 1);
    });
  }
  test('current Dart process is selected, not the PowerShell child', () {
    getWindowsMemory(WindowsMemoryMetric.processVirtual, run: (_, args) {
      expect(args.last, contains('ProcessId = $pid'));
      return '1024';
    });
  });
  test('accepts decimal string and zero without lossy double conversion', () {
    for (final value in [0, 17179869184, int.parse('9007199254740993')]) {
      expect(
          getWindowsMemory(WindowsMemoryMetric.totalPhysical,
              run: (_, __) => '"$value"'),
          value);
    }
  });
  test('missing executable, failed command, and bad data are explicit errors',
      () {
    for (final output in <String?>[
      null,
      '',
      'error',
      'null',
      '{}',
      '[]',
      '[123]',
      'true',
      '1.5',
      '-1',
      '"-1"',
      '"1.5"',
      '"1,024"',
      '""',
      '"18446744073709551615"',
      '9223372036854775807',
    ]) {
      expect(
          () => getWindowsMemory(WindowsMemoryMetric.freePhysical,
              run: (_, __) => output),
          throwsStateError,
          reason: '$output');
    }
  });
  test('public Windows memory queries return plausible values without WMIC',
      () {
    final total = SysInfo.getTotalPhysicalMemory();
    final free = SysInfo.getFreePhysicalMemory();
    final available = SysInfo.getAvailablePhysicalMemory();
    final virtualTotal = SysInfo.getTotalVirtualMemory();
    final virtualFree = SysInfo.getFreeVirtualMemory();
    expect(total, greaterThan(0));
    expect(free, inInclusiveRange(0, total));
    expect(available, inInclusiveRange(0, total));
    expect(virtualTotal, greaterThan(0));
    expect(virtualFree, inInclusiveRange(0, virtualTotal));
    expect(SysInfo.getVirtualMemorySize(), greaterThan(0));
  }, skip: !Platform.isWindows);
}
