//
//  CDZLogConsoleCellItem.m
//  CDZLogConsole
//
//  Created by Nemocdz on 2017/8/1.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "CDZConsoleLoggerCellItem.h"
#import "CDZConsoleLoggerMessage.h"

@implementation CDZConsoleLoggerCellItem

- (instancetype)init{
    if (self = [super init]) {
        self.log = [CDZConsoleLoggerMessage.alloc init];
        self.style = CDZConsoleLoggerCellStyleNormal;
        self.selectionHandler = ^(CDZConsoleLoggerCellItem *aItem, NSIndexPath *indexPath) {NSLog(@"cell is tap");};
    }
    return self;
}

@end
