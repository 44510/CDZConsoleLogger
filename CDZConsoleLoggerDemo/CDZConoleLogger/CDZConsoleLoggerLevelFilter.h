//
//  CDZLogConsoleLoggerLevelFilter.h
//  CDZLogConsole
//
//  Created by Nemocdz on 2017/8/1.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDZConsoleLogger.h"
#import "CDZConsoleLoggerMessage.h"

@interface CDZConsoleLoggerLevelFilter : NSObject<CDZConsoleLoggerFilter>

+ (instancetype)allLevelFilter;

- (void)addLevel:(CDZConsoleLoggerLevel)level;
- (void)removeLevel:(CDZConsoleLoggerLevel)level;

- (void)addAllLevels;
- (void)removeAllLevels;

@property (nonatomic, assign, getter=isEnable) BOOL enable;

@end
