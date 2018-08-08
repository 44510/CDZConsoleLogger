//
//  CDZConsoleLoggerMessage.h
//  CDZConsoleLogger
//
//  Created by Nemocdz on 2017/7/31.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CDZConsoleLoggerLevel) {
    CDZConsoleLoggerLevelFatal,
    CDZConsoleLoggerLevelWarn,
    CDZConsoleLoggerLevelInfo,
    CDZConsoleLoggerLevelTrace,
    CDZConsoleLoggerLevelDebug,
};

FOUNDATION_EXTERN NSString *CDZConsoleLoggerNameOfLogLevel(CDZConsoleLoggerLevel level);
FOUNDATION_EXTERN UIColor *CDZConsoleLoggerTextColorOfLogLevel(CDZConsoleLoggerLevel level);
FOUNDATION_EXTERN NSString *CDZConsoleLoggerDateStringFromDate(NSDate* date);



@interface CDZConsoleLoggerMessage : NSObject

@property (nonatomic, copy) NSString *mesaage;
@property (nonatomic, assign) CDZConsoleLoggerLevel level;
@property (nonatomic, copy, nullable) NSString *fileName;
@property (nonatomic, assign) NSUInteger line;
@property (nonatomic, copy, nullable) NSString *funcName;
@property (nonatomic, copy, nullable) NSDictionary *userInfo;

@end

NS_ASSUME_NONNULL_END
