//
//  CDZConsoleLoggergMessage.m
//  CDZConsoleLogger
//
//  Created by Nemocdz on 2017/7/31.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "CDZConsoleLoggerMessage.h"

NSString *CDZConsoleLoggerNameOfLogLevel(CDZConsoleLoggerLevel level){
    switch (level) {
        case CDZConsoleLoggerLevelFatal:
            return @"Fatal";
            break;
        case CDZConsoleLoggerLevelWarn:
            return @"Warn";
            break;
        case CDZConsoleLoggerLevelInfo:
            return @"Info";
            break;
        case CDZConsoleLoggerLevelTrace:
            return @"Trace";
            break;
        case CDZConsoleLoggerLevelDebug:
            return @"Debug";
            break;
        default:
            return @"Debug";
            break;
    }
}

UIColor *CDZConsoleLoggerTextColorOfLogLevel(CDZConsoleLoggerLevel level){
    switch (level) {
        case CDZConsoleLoggerLevelFatal:
            return UIColor.redColor;
            break;
        case CDZConsoleLoggerLevelWarn:
            return UIColor.orangeColor;
            break;
        case CDZConsoleLoggerLevelInfo:
            return UIColor.greenColor;
            break;
        case CDZConsoleLoggerLevelTrace:
            return UIColor.blueColor;
            break;
        case CDZConsoleLoggerLevelDebug:
            return UIColor.whiteColor;
            break;
        default:
            return UIColor.whiteColor;
            break;
    }
}

NSString *CDZConsoleLoggerDateStringFromDate(NSDate *date){
    NSDateFormatter *format = [NSDateFormatter.alloc init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [format stringFromDate:date];
}

@implementation CDZConsoleLoggerMessage

@end
