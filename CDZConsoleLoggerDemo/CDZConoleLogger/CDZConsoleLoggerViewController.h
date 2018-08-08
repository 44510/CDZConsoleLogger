//
//  CDZLogConsoleViewController.h
//  CDZLogConsole
//
//  Created by Nemocdz on 2017/7/31.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDZConsoleLoggerViewController;
@class CDZConsoleLogger;
@class CDZConsoleLoggerMessage;
@class CDZConsoleLoggerTableView;

@protocol CDZConsoleLoggerViewControllerDelegate <NSObject>

@optional
/**
 当前logger

 @param viewController 当前VC
 @param logger logger
 */
- (void)consoleViewController:(CDZConsoleLoggerViewController *)viewController currentLogger:(CDZConsoleLogger *)logger;


/**
 当前日志输出

 @param viewController 当前VC
 @param logMessage 日志
 */
- (void)consoleViewController:(CDZConsoleLoggerViewController *)viewController currentLogMessage:(CDZConsoleLoggerMessage *)logMessage;
@end


@interface CDZConsoleLoggerViewController : UIViewController

@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) CDZConsoleLoggerTableView *consoleView;
@property (nonatomic, weak) id<CDZConsoleLoggerViewControllerDelegate> delegate;

@end
