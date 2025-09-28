class ProcessorArchitecture {
  static const arm64 = ProcessorArchitecture('ARM64');

  static const arm = ProcessorArchitecture('ARM');

  static const ia64 = ProcessorArchitecture('IA64');

  static const mips = ProcessorArchitecture('MIPS');

  static const x86 = ProcessorArchitecture('X86');

  static const x86_64 = ProcessorArchitecture('X86_64');

  static const unknown = ProcessorArchitecture('UNKNOWN');

  final String name;

  const ProcessorArchitecture(this.name);

  @override
  String toString() => name;
}
