import 'dart:convert';
import 'dart:io';

import '../utils.dart';

/// WMI properties keep their original units; only the OS properties are KiB.
enum WindowsMemoryMetric {
  freePhysical('Win32_OperatingSystem', 'FreePhysicalMemory', 1024),
  freeVirtual('Win32_OperatingSystem', 'FreeVirtualMemory', 1024),
  totalPhysical('Win32_ComputerSystem', 'TotalPhysicalMemory', 1),
  totalVirtual('Win32_OperatingSystem', 'TotalVirtualMemorySize', 1024),
  processVirtual('Win32_Process', 'VirtualSize', 1);

  final String className;
  final String property;
  final int byteMultiplier;

  const WindowsMemoryMetric(this.className, this.property, this.byteMultiplier);
}

/// Queries local CIM using Windows PowerShell, without requiring WMIC.
/// Throws StateError when the command or its numeric result is unavailable.
int getWindowsMemory(
  WindowsMemoryMetric metric, {
  String? Function(String, List<String>) run = exec,
  int? processId,
}) {
  final filter = metric == WindowsMemoryMetric.processVirtual
      ? ' -Filter "ProcessId = ${processId ?? pid}"'
      : '';
  final command = r"$ErrorActionPreference = 'Stop'; "
      '(Get-CimInstance -ClassName ${metric.className}$filter '
      '-ErrorAction Stop).${metric.property} | ConvertTo-Json -Compress';
  final output = run('powershell.exe', [
    '-NoLogo',
    '-NoProfile',
    '-NonInteractive',
    '-Command',
    command,
  ]);
  if (output == null) {
    throw StateError('Windows memory query failed for ${metric.property}. '
        'Windows PowerShell and the local CIM provider must be available.');
  }

  Object? decoded;
  try {
    decoded = jsonDecode(output.trim());
  } on FormatException {
    throw StateError('Invalid Windows memory result for ${metric.property}.');
  }
  // Accept integer JSON and decimal strings without lossy double conversion.
  final value = decoded is int
      ? decoded
      : decoded is String && RegExp(r'^\d+$').hasMatch(decoded)
          ? int.tryParse(decoded)
          : null;
  if (value == null ||
      value < 0 ||
      value > 0x7fffffffffffffff ~/ metric.byteMultiplier) {
    throw StateError('Invalid Windows memory result for ${metric.property}.');
  }
  return value * metric.byteMultiplier;
}
