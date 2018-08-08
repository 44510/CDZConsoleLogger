# CDZConsoleLogger
This is a small and beautiful logger on the phone at debug.

## Demo Preview

![](https://ws4.sinaimg.cn/large/0069RVTdgy1fu2ucms2hug30hk0vg4h0.gif)

## Changelog

## Installation

### Manual

Add "CDZConsoleLogger" files to your project

### CocoaPods

Add ``pod 'CDZConsolelogger'`` in your Podfile

## Usage

``#import "CDZConsoleLoggerDashboard.h"``

If you want to show Dashboard.

```objective-c
[CDZConsoleLoggerDashboard sharedDashboard].mini = YES;//or NO
[[CDZConsoleLoggerDashboard sharedDashboard] show];
```

If you want to hide Dashboard outside can use code, also you can use the **Close** button on the Dashboard.

```objective-c
[[CDZConsoleLoggerDashboard sharedDashboard] hide];
```

Log something  you want. First init message, and than log it.

```objective-c
CDZConsoleLoggerMessage *message = [CDZConsoleLoggerMessage.alloc init];
message.mesaage = @"[CDZConsoleLogger]this is a log message";
message.level = CDZConsoleLoggerLevelDebug;

[[CDZConsoleLoggerDashboard sharedDashboard].logger logMessage:message];
```

## Articles

## Requirements

iOS 8.0 Above

## TODO

## Contact

- Open a issue
- QQ：757765420
- Email：nemocdz@gmail.com
- Weibo：[@Nemocdz](http://weibo.com/nemocdz)

## License

CDZConsoleLogger is available under the MIT license. See the LICENSE file for more info.