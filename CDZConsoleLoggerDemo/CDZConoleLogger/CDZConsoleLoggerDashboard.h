//
//  CDZLogConsoleDashboard.h
//  CDZLogConsole
//
//  Created by Nemocdz on 2017/8/1.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDZConsoleLogger.h"
#import "CDZConsoleLoggerMessage.h"

@interface CDZConsoleLoggerDashboard : UIWindow
+ (instancetype)sharedDashboard;
//显示window
- (void)show;
//隐藏window
- (void)hide;
//内部的logger
@property (nonatomic, weak) CDZConsoleLogger *logger;
//是否是最小化，最小化为20高度
@property (nonatomic, assign, getter=isMini) BOOL mini;
@end
