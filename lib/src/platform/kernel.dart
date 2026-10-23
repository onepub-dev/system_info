import 'dart:io';

import 'package:path/path.dart' as pathos;

import '../file_utils.dart';
import '../fluent.dart';
import '../processor_architecture.dart';
import '../utils.dart';
import 'operating_system.dart';
import 'userspace.dart';

int getKernelBitness() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
      if (getUserSpaceBitness() == 64) {
        return 64;
      }

      final paths = <String>[];
      final path = resolveLink('/etc/ld.so.conf');
      if (path != null) {
        parseLdConf(path, paths, <String>{});
      }

      paths
        ..add('/lib')
        ..add('/lib64');
      for (final path in paths) {
        final files = FileUtils.glob(pathos.join(path, 'libc.so.*'));
        for (final filePath in files) {
          final resolvedFilePath = resolveLink(filePath);
          if (resolvedFilePath == null) {
            continue;
          }

          final file = File(resolvedFilePath);
          if (file.existsSync()) {
            final fileType =
                (fluent(exec('file', ['-b', file.path]))..trim()).stringValue;
            if (fileType.startsWith('ELF 64-bit')) {
              return 64;
            }
          }
        }
      }

      return 32;
    case 'macos':
      if ((fluent(exec('uname', ['-m']))..trim()).stringValue == 'x86_64') {
        return 64;
      }

      return 32;
    case 'windows':
      final wow64 =
          fluent(Platform.environment['PROCESSOR_ARCHITEW6432']).stringValue;
      if (wow64.isNotEmpty) {
        return 64;
      }

      switch (Platform.environment['PROCESSOR_ARCHITECTURE']) {
        case 'AMD64':
        case 'IA64':
          return 64;
      }

      return 32;
    default:
      notSupportedError();
  }
}

/// Converts the value return by [getRawKernelArchitecture] into an
/// high level type.
/// Note that we only support a limited set of raw architecture types
/// as per the [ProcessorArchitecture] enum.
ProcessorArchitecture getKernalArchitecture() {
  var processorArchitecture =
      processorToArchitecure[getRawKernelArchitecture()];
  return processorArchitecture ??= ProcessorArchitecture.unknown;
}

/// Returns the low level kernel archtecture as reported by the OS
///
/// The following list was taken from https://stackoverflow.com/questions/45125516/possible-values-for-uname-m
///
/// Thanks to Jonathon Reinhart for compiling the list!
///
/// Current known values are:
///
/// alpha
/// arc
/// arm
/// aarch64_be (arm64)
/// aarch64 (arm64)
/// armv7l
/// armv8b (arm64 compat)
/// armv8l (arm64 compat)
/// blackfin
/// c6x
/// cris
/// frv
/// h8300
/// hexagon
/// ia64
/// m32r
/// m68k
/// metag
/// microblaze
/// mips (native or compat)
/// mips64 (mips)
/// mn10300
/// nios2
/// openrisc
/// parisc (native or compat)
/// parisc64 (parisc)
/// ppc (powerpc native or compat)
/// ppc64 (powerpc)
/// ppcle (powerpc native or compat)
/// ppc64le (powerpc)
/// s390 (s390x compat)
/// s390x
/// score
/// sh
/// sh64 (sh)
/// sparc (native or compat)
/// sparc64 (sparc)
/// tile
/// unicore32
/// i386 (x86)
/// i686 (x86 compat)
/// x86_64 (x64)
/// xtensa
String getRawKernelArchitecture() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
    case 'macos':
      return (fluent(exec('uname', ['-m']))..trim()).stringValue;
    case 'windows':
      final wow64 =
          fluent(Platform.environment['PROCESSOR_ARCHITEW6432']).stringValue;
      if (wow64.isNotEmpty) {
        return wow64;
      }

      return fluent(Platform.environment['PROCESSOR_ARCHITECTURE']).stringValue;
    default:
      notSupportedError();
  }
}

String getKernelName() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
    case 'macos':
      return (fluent(exec('uname', ['-s']))..trim()).stringValue;
    case 'windows':
      return fluent(Platform.environment['OS']).stringValue;
    default:
      notSupportedError();
  }
}

String getKernelVersion() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
    case 'macos':
      return (fluent(exec('uname', ['-r']))..trim()).stringValue;
    case 'windows':
      return getOperatingSystemVersion();
    default:
      notSupportedError();
  }
}

final processorToArchitecure = <String, ProcessorArchitecture>{
// 'alpha', ProcessorArchitecture.alpah,
// 'arc'
  'arm': ProcessorArchitecture.arm,
  // Returned by Apple Silicon M2 when running uname -m
  'arm64': ProcessorArchitecture.arm64,
  'aarch64_be': ProcessorArchitecture.arm64,
  'aarch64': ProcessorArchitecture.arm64,
  'armv7l': ProcessorArchitecture.arm,
  'armv8b': ProcessorArchitecture.arm64,
  'armv8l': ProcessorArchitecture.arm64,
// 'blackfin'
// 'c6x'
// 'cris'
// 'frv'
// 'h8300'
// 'hexagon'
  'ia64': ProcessorArchitecture.ia64,
// 'm32r'
// 'm68k'
// 'metag'
// 'microblaze'
  'mips': ProcessorArchitecture.mips,
  'mips64': ProcessorArchitecture.mips,
// 'mn10300'
// 'nios2'
// 'openrisc'
// 'parisc' (native or compat)
// 'parisc64' (parisc)
// 'ppc' (powerpc native or compat)
// 'ppc64' (powerpc)
// 'ppcle' (powerpc native or compat)
// 'ppc64le' (powerpc)
// 's390' (s390x compat)
// 's390x'
// 'score'
// 'sh'
// 'sh64' (sh)
// 'sparc' (native or compat)
// 'sparc64' (sparc)
// 'tile'
// 'unicore32'
  'i386': ProcessorArchitecture.x86,
  'i686': ProcessorArchitecture.x86,
  // Windows PROCESSOR_ARCHITECTURE / PROCESSOR_ARCHITEW6432.
  'AMD64': ProcessorArchitecture.x86_64,
  'x86_64': ProcessorArchitecture.x86_64
// 'xtensa'
};
