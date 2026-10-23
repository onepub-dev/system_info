import 'dart:io';

import '../fluent.dart';
import '../utils.dart';
import 'memory_macos.dart';
import 'memory_windows.dart';

int getFreePhysicalMemory() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
      final data = (fluent(exec('cat', ['/proc/meminfo']))
            ..trim()
            ..stringToMap(':'))
          .mapValue;
      final value = (fluent(data['MemFree'])
            ..split(' ')
            ..elementAt(0)
            ..parseInt())
          .intValue;
      return value * 1024;
    case 'macos':
      return getFreeVirtualMemory();
    case 'windows':
      return getWindowsMemory(WindowsMemoryMetric.freePhysical);
    default:
      notSupportedError();
  }
}

int getAvailablePhysicalMemory() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
      final data = (fluent(exec('cat', ['/proc/meminfo']))
            ..trim()
            ..stringToMap(':'))
          .mapValue;
      final value = (fluent(data['MemAvailable'])
            ..split(' ')
            ..elementAt(0)
            ..parseInt())
          .intValue;
      return value * 1024;
    case 'macos':
      return getFreeVirtualMemory();
    case 'windows':
      return getWindowsMemory(WindowsMemoryMetric.freePhysical);
    default:
      notSupportedError();
  }
}

int getFreeVirtualMemory() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
      final data = (fluent(exec('cat', ['/proc/meminfo']))
            ..trim()
            ..stringToMap(':'))
          .mapValue;
      final physical = (fluent(data['MemFree'])
            ..split(' ')
            ..elementAt(0)
            ..parseInt())
          .intValue;
      final swap = (fluent(data['SwapFree'])
            ..split(' ')
            ..elementAt(0)
            ..parseInt())
          .intValue;
      return (physical + swap) * 1024;
    case 'macos':
      final data = (fluent(exec('vm_stat', []))
            ..trim()
            ..stringToMap(':'))
          .mapValue;
      final free = (fluent(data['Pages free'])
            ..replaceAll('.', '')
            ..parseInt())
          .intValue;
      final pageSize = (fluent(exec('sysctl', ['-n', 'hw.pagesize']))
            ..trim()
            ..parseInt())
          .intValue;
      return free * pageSize;
    case 'windows':
      return getWindowsMemory(WindowsMemoryMetric.freeVirtual);
    default:
      notSupportedError();
  }
}

int getTotalPhysicalMemory() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
      final data = (fluent(exec('cat', ['/proc/meminfo']))
            ..trim()
            ..stringToMap(':'))
          .mapValue;
      final value = (fluent(data['MemTotal'])
            ..split(' ')
            ..elementAt(0)
            ..parseInt())
          .intValue;
      return value * 1024;
    case 'macos':
      return getMacOsTotalPhysicalMemory();
    case 'windows':
      return getWindowsMemory(WindowsMemoryMetric.totalPhysical);
    default:
      notSupportedError();
  }
}

int getTotalVirtualMemory() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
      final data = (fluent(exec('cat', ['/proc/meminfo']))
            ..trim()
            ..stringToMap(':'))
          .mapValue;
      final physical = (fluent(data['MemTotal'])
            ..split(' ')
            ..elementAt(0)
            ..parseInt())
          .intValue;
      final swap = (fluent(data['SwapTotal'])
            ..split(' ')
            ..elementAt(0)
            ..parseInt())
          .intValue;
      return (physical + swap) * 1024;
    case 'macos':
      final data = (fluent(exec('vm_stat', []))
            ..trim()
            ..stringToMap(':'))
          .mapValue;
      final free = (fluent(data['Pages free'])
            ..replaceAll('.', '')
            ..parseInt())
          .intValue;
      final active = (fluent(data['Pages active'])
            ..replaceAll('.', '')
            ..parseInt())
          .intValue;
      final inactive = (fluent(data['Pages inactive'])
            ..replaceAll('.', '')
            ..parseInt())
          .intValue;
      final speculative = (fluent(data['Pages speculative'])
            ..replaceAll('.', '')
            ..parseInt())
          .intValue;
      final wired = (fluent(data['Pages wired down'])
            ..replaceAll('.', '')
            ..parseInt())
          .intValue;
      final pageSize = (fluent(exec('sysctl', ['-n', 'hw.pagesize']))
            ..trim()
            ..parseInt())
          .intValue;
      return (free + active + inactive + speculative + wired) * pageSize;
    case 'windows':
      return getWindowsMemory(WindowsMemoryMetric.totalVirtual);
    default:
      notSupportedError();
  }
}

int getVirtualMemorySize() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
    case 'macos':
      final data = (fluent(exec('ps', ['-o', 'vsz', '-p', '$pid']))
            ..trim()
            ..stringToList())
          .listValue;
      final size = (fluent(data.elementAt(1))..parseInt()).intValue;
      return size * 1024;
    case 'windows':
      return getWindowsMemory(WindowsMemoryMetric.processVirtual);
    default:
      notSupportedError();
  }
}
