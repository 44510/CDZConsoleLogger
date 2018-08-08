//
//  CDZLogConsoleLoggerKeywordFilter.h
//  CDZLogConsole
//
//  Created by Nemocdz on 2017/8/1.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDZConsoleLogger.h"


@interface CDZConsoleLoggerKeywordFilter : NSObject<CDZConsoleLoggerFilter>

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign, getter=isEnable) BOOL enable;

@end
