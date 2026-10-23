system_info2
=====

A fork of system_info as the original maintainer no longer wishes to do so.

Thanks to onepub.dev for allowing me the time and resources to support this package.

Provides easy access to useful information about the system (architecture, bitness, kernel, memory, operating system, CPU, user).

system_info2 lets you discover specific hardware characteristics of the OS you are running on includeing:

* kernelArchitecture
* Kernel bitness          
* Kernel name             
* Kernel version          
* Operating system name   
* Operating system version
* User directory          
* User id                 
* User name               
* User space bitness      

**Basic examples:**

```dart
if (SysInfo.operatingSystemName == "Ubuntu") {
  log.info("We love Ubuntu users");
}
```

## Documentation

You can find the manual at: 

[sysinfo.onepub.dev](https://sysinfo.onepub.dev)

## Windows memory queries

Memory getters use local PowerShell `Get-CimInstance` queries, so WMIC is not
required. Windows PowerShell (`powershell.exe`) must be on PATH, with the
CimCmdlets module and local WMI/CIM service/providers available. Queries run
without profiles or interactive prompts and do not require remote WinRM.
Each synchronous getter starts a PowerShell process; these calls can be slow
and should not be used in a tight polling loop or on a latency-sensitive UI path.

The public methods still return bytes. `FreePhysicalMemory`, `FreeVirtualMemory`,
and `TotalVirtualMemorySize` from `Win32_OperatingSystem` are converted from KiB;
`Win32_ComputerSystem.TotalPhysicalMemory` and the current Dart process's
`Win32_Process.VirtualSize` are already bytes. Available and free physical memory
retain the same Windows meaning. Virtual memory retains the WMI property semantics
(it is not a measurement of the Dart heap).

If PowerShell/CIM fails, is blocked by policy, or returns missing/invalid data,
memory getters now throw `StateError` instead of silently reporting zero. A valid
zero result is still returned as zero. No execution-policy bypass or WMIC fallback
is used. Other Windows information queries may still depend on WMIC.

Property definitions: [operating system](https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-operatingsystem),
[computer system](https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-computersystem),
and [process](https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-process).

Run `dart test` for fixture regression coverage. Tests marked for Windows or macOS
also exercise the public API on those operating systems; skips on Linux do not
constitute native-platform verification.
