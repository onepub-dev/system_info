import 'dart:io';

import '../fluent.dart';
import '../utils.dart';

int getTotalStorage() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
      final mountPoint = Platform.operatingSystem == 'android' ? '/data' : '/';
      final data = statFsGetValueAsMap(mountPoint, ['S', 'b'])!;
      final blockSize = (fluent(data['S'])..parseInt()).intValue;
      final blocksTotal = (fluent(data['b'])..parseInt()).intValue;
      return blockSize * blocksTotal;
    case 'windows':
      final data = wmicGetValueAsMap('logicaldisk', ['Size'])!;
      return (fluent(data['Size'])..parseInt()).intValue;
    default:
      notSupportedError();
  }
}

int getFreeStorage() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
      final mountPoint = Platform.operatingSystem == 'android' ? '/data' : '/';
      final data = statFsGetValueAsMap(mountPoint, ['S', 'a'])!;
      final blockSize = (fluent(data['S'])..parseInt()).intValue;
      final blocksFree = (fluent(data['a'])..parseInt()).intValue;
      return blockSize * blocksFree;
    case 'windows':
      final data = wmicGetValueAsMap('logicaldisk', ['FreeSpace'])!;
      return (fluent(data['FreeSpace'])..parseInt()).intValue;
    default:
      notSupportedError();
  }
}
