import 'dart:io';

import 'package:system_info2/src/platform/kernel.dart';
import 'package:system_info2/system_info2.dart';
import 'package:test/test.dart';

void main() {
  test('Windows AMD64 and Unix x86_64 map to the same architecture', () {
    expect(processorToArchitecure['AMD64'], ProcessorArchitecture.x86_64);
    expect(processorToArchitecure['x86_64'], ProcessorArchitecture.x86_64);
    expect(processorToArchitecure['arm64'], ProcessorArchitecture.arm64);
    expect(processorToArchitecure['unrecognized'], isNull);
  });
  test('native Windows AMD64 resolves through public API', () {
    expect(SysInfo.rawKernelArchitecture, 'AMD64');
    expect(SysInfo.kernelArchitecture, ProcessorArchitecture.x86_64);
    expect(SysInfo.kernelBitness, 64);
  },
      skip: !Platform.isWindows ||
          (Platform.environment['PROCESSOR_ARCHITEW6432'] ??
                  Platform.environment['PROCESSOR_ARCHITECTURE']) !=
              'AMD64');
}
