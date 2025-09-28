import 'processor_architecture.dart';

/// Describes a processor core.
class CoreInfo {
  final ProcessorArchitecture architecture;

  final String name;

  final int socket;

  final String vendor;

  CoreInfo(
      {this.architecture = ProcessorArchitecture.unknown,
      this.name = '',
      this.socket = 0,
      this.vendor = ''});
}
