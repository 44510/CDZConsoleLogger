//
//  CDZLogConsoleView.h
//  CDZLogConsole
//
//  Created by Nemocdz on 2017/7/31.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDZConsoleLogger;

@interface CDZConsoleLoggerTableView : UITableView
@property (nonatomic, strong) CDZConsoleLogger *logger;
@property (nonatomic, assign) Class cellClass;

@end
