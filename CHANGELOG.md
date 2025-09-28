# 4.1.0
- Merge pull request #14 from GabrielTorelo/feat/storage_information
- chore(example): adding the storage data to the example
- feat(system_info): provides and comments functions to get data from storage
- feat(storage): creates functions to get total storage and available storage
- feat(utils): creates function to obtain 'StatFs' values and convert to map
- Merge pull request #11 from dev-kasibhatla/system_info3-compatibility
- Add getAvailablePhysicalMemory()

# 4.0.0
- upgraded to support dart 3.0
- removed dependency on deprecated file_utils package by coping
 the required classes into system_info.

# 3.0.2
- Updated to kernel.dart processorToArchitecure map

# 3.0.1
- breaking: changed SysInfo.kernelArchitecture to return a ProcessorArchitecture rather than a string as it provides a more useful abstraction. 
- Introduced the new SysInfo.rawKernelArchitecture which provides the same value as the original SysInfo.kernelArchitecture.

# 3.0.0
- Breaking Change: removed all classes/methods marked as @deprecated in 2.x.
  To make your life easier be sure to remove all deprecated warnings before upgrading to
  3.x
- Breaking change, `ProcessorArchitecture.aarch64` renamed to `ProcessorArchitecture.arm64`
- significant refactoring of the code base by breaking out code into seperate dart
 files to improve readability.
# 2.0.4
- fixed getFreePhysicalMemory - big thanks to @jingluoguo for the patch

# 2.0.3
- removed trailing slashes of homepage and documenation.
- fix of the readme.

# 2.0.2
- released the manual and updated the readme to point to it.
- made processors redundant and replaced with cores. 
- Applied lint hard and fixed incorrect camel case usage.

# 2.0.1
Acknowledged onepub.dev's support.

# 2.0.0
Forked an created a supported release.

- 1.0.1
- 1.0.1
- 1.0.0
- Merge pull request #3 from bsutton/master
- Corrected the version no.
- migrate to nnbd
- 0.1.3
- 0.1.2
- 0.1.1
- 0.1.0
- 0.0.16
- 0.0.15
- Merge pull request #1 from martinsik/master
- fixed _getKernelBitness for "macos"
- 0.0.14
- 0.0.12
- 0.0.12
- 0.0.12
- 0.0.11
- 0.0.11
- 0.0.10
- 0.0.9
- 0.0.9
- 0.0.8
- 0.0.7
- 0.0.6
- 0.0.6
- 0.0.5
- 0.0.5
- 0.0.4
- 0.0.3
- 0.0.2
- 0.0.1
- Initial commit

## 1.0.1

- This package is no longer supported because it was flagged by Google Dart developers as being published by an unknown person. Publisher Unknown. As a normal person, I believe that hardly anyone would want to use software from unknown publishers.

## 1.0.0

- The source code has been migrated to null safety. Thanks to the author of this work, Brett Sutton (github.com/bsutton).

## 0.1.3

- Minor changes in processor architecture recognition

## 0.1.2

- The source code has been modified in accordance with Google’s guidelines about the effectiveness of the Dart language

## 0.1.1

- To avoid downgrading the rating on https://pub.dartlang.org, the source code has been changed to fit Google’s ever-changing recommendations on what a good (pedantic) source code should be.

## 0.1.0

- Adaptation to Dart 2.0

## 0.0.16

- Fixed bug in detection of `user space bitness` on Mac OS X

## 0.0.15

- Fixed bug in detection of `bitness of kernel` on Mac OS X

## 0.0.14

- Added statistics `getVirtualMemorySize()` about the current memory usage by the current process

## 0.0.12

- Breaking change, `ProcessorArchitecture.ARM64` renamed to `ProcessorArchitecture.AARCH64`

## 0.0.11

- Fixed bug in detection of `kernel architecture` on Windows. More universal algorithm independent from the architecture name, allows detect any architecture (X86/ AMD64/ IA64/ etc)
- Impoved detection of `bitness of kernel` on Windows. Added suport of `IA64`
- Impoved detection of `bitness of user space` on Windows. Added suport of `IA64`

## 0.0.10

- Implemented `getFreePhysicalMemory()` and `getTotalVirtualMemory()` on Mac OS X

## 0.0.9

- Fixed bug in detection of `bitness of kernel` on Linux

## 0.0.8

- Detection of `bitness of kernel` on Linux are based on the found file formats of `libc.so.*`

## 0.0.7

- Partial support of `processor architecture` statistics

## 0.0.6

- Renamed method `physicalMemoryFreeSize()` to `getFreePhysicalMemory()`
- Renamed method `physicalMemoryTotalSize()` to `getTotalPhysicalMemory()`
- Renamed method `virtualMemoryFreeSize()` to `getFreeVirtualMemory()`
- Renamed method `virtualMemoryTotalSize()` to `getTotalVirtualMemory()`

## 0.0.5

- Partial support of `phycical memory` and `virtual memory` statistics

## 0.0.4

- Fixed a bug when parsing comments in the file `/boot/config` on Linux

## 0.0.3

- Changed the algorithm for detecting the number of physical processor sockets on Windows

## 0.0.1

- Initial release

