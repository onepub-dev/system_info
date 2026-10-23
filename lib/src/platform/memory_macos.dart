import '../utils.dart';

/// sysctl reports hw.memsize in bytes, independent of the hardware page size.
int getMacOsTotalPhysicalMemory({
  String? Function(String, List<String>) run = exec,
}) =>
    int.tryParse(run('sysctl', ['-n', 'hw.memsize'])?.trim() ?? '') ?? 0;
