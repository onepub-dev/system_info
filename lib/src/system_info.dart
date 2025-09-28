import 'core_info.dart';
import 'platform/cpu.dart';
import 'platform/kernel.dart';
import 'platform/memory.dart' as pm;
import 'platform/operating_system.dart';
import 'platform/storage.dart' as stg;
import 'platform/user.dart';
import 'platform/userspace.dart';
import 'processor_architecture.dart';

abstract class SysInfo {
  SysInfo._internal();

  /// Returns the architecture of the kernel by obtaining
  /// the [rawKernelArchitecture]
  /// and converting it to a high level ProcessorArchitecture.
  ///
  ///     print(SysInfo.kernelArchitecture);
  ///     => ProcessorArchitecture.x86
  static final ProcessorArchitecture kernelArchitecture =
      getKernalArchitecture();

  /// Returns the raw architecture of the kernel as reported by the OS
  ///
  ///     print(SysInfo.rawKernelArchitecture);
  ///     => i686
  static final String rawKernelArchitecture = getRawKernelArchitecture();

  /// Returns the bintness of kernel.
  ///
  ///     print(SysInfo.kernelBitness);
  ///     => 32
  static final int kernelBitness = getKernelBitness();

  /// Returns the name of kernel.
  ///
  ///     print(SysInfo.kernelName);
  ///     => Linux
  static final String kernelName = getKernelName();

  /// Returns the version of kernel.
  ///
  ///     print(SysInfo.kernelVersion);
  ///     => 32
  static final String kernelVersion = getKernelVersion();

  /// Returns the name of operating system.
  ///
  ///     print(SysInfo.operatingSystemName);
  ///     => Ubuntu
  static final String operatingSystemName = getOperatingSystemName();

  /// Returns the version of operating system.
  ///
  ///     print(SysInfo.operatingSystemVersion);
  ///     => 14.04
  static final String operatingSystemVersion = getOperatingSystemVersion();

  /// Returns the information about the processors.
  ///
  ///     print(SysInfo.processors.first.vendor);
  ///     => GenuineIntel
  static final List<CoreInfo> cores = getCores();

  /// Returns the path of user home directory.
  ///
  ///     print(SysInfo.userDirectory);
  ///     => /home/andrew
  static final String userDirectory = getUserDirectory();

  /// Returns the identifier of current user.
  ///
  ///     print(SysInfo.userId);
  ///     => 1000
  static final String userId = getUserId();

  /// Returns the name of current user.
  ///
  ///     print(SysInfo.userName);
  ///     => 'Andrew'
  static final String userName = getUserName();

  /// Returns the bitness of the user space.
  ///
  ///     print(SysInfo.userSpaceBitness);
  ///     => 32
  static final int userSpaceBitness = getUserSpaceBitness();

  /// Returns the amount of free physical memory in bytes.
  ///
  /// This is the amount of physical memory that is unused (or empty).
  /// This is different from available memory, often lesser
  ///
  ///     print(SysInfo.getFreePhysicalMemory());
  ///     => 3755331584
  static int getFreePhysicalMemory() => pm.getFreePhysicalMemory();

  /// Returns the amount of available physical memory in bytes.
  ///
  /// This is the amount of physical memory that can be used by the system.
  /// Most "diagnostic apps" show this as the "free memory"
  ///
  ///    print(SysInfo.getAvailablePhysicalMemory());
  ///    => 3755331584
  static int getAvailablePhysicalMemory() => pm.getAvailablePhysicalMemory();

  /// Returns the amount of free virtual memory in bytes.
  ///
  ///     print(SysInfo.getFreeVirtualMemory());
  ///     => 3755331584
  static int getFreeVirtualMemory() => pm.getFreeVirtualMemory();

  /// Returns the amount of total physical memory in bytes.
  ///
  ///     print(SysInfo.getTotalPhysicalMemory());
  ///     => 3755331584
  static int getTotalPhysicalMemory() => pm.getTotalPhysicalMemory();

  /// Returns the amount of total virtual memory in bytes.
  ///
  ///     print(SysInfo.getTotalVirtualMemory());
  ///     => 3755331584
  static int getTotalVirtualMemory() => pm.getTotalVirtualMemory();

  /// Returns the amount of virtual memory in bytes used by the proccess.
  ///
  ///     print(SysInfo.getVirtualMemorySize());
  ///     => 123456
  static int getVirtualMemorySize() => pm.getVirtualMemorySize();

  /// Returns the total storage in bytes.
  ///
  ///    print(SysInfo.getTotalStorage());
  ///    => 510745636864
  static int getTotalStorage() => stg.getTotalStorage();

  /// Returns the free storage in bytes.
  ///
  ///   print(SysInfo.getFreeStorage());
  ///   => 255868657664
  static int getFreeStorage() => stg.getFreeStorage();
}
