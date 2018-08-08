//
//  CDZConsoleLoggerConsoleView.m
//  CDZConsoleLoggerConsole
//
//  Created by Nemocdz on 2017/7/31.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "CDZConsoleLoggerTableView.h"
#import "CDZConsoleLogger.h"
#import "CDZConsoleLoggerCell.h"

@interface CDZConsoleLoggerTableView ()
@end

@implementation CDZConsoleLoggerTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        self.logger = [CDZConsoleLogger.alloc init];
        self.cellClass = [CDZConsoleLoggerCell class];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


- (void)setLogger:(CDZConsoleLogger *)logger{
    _logger = logger;
    logger.consoleView = self;
    self.dataSource = logger;
    self.delegate = logger;
}


@end
