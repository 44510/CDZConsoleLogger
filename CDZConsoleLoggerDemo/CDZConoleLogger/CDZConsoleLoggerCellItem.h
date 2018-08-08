//
//  CDZConsoleLoggerConsoleCellItem.h
//  CDZConsoleLoggerConsole
//
//  Created by Nemocdz on 2017/8/1.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CDZConsoleLoggerMessage;

typedef NS_ENUM(NSUInteger, CDZConsoleLoggerCellStyle) {
    CDZConsoleLoggerCellStyleNormal,
    CDZConsoleLoggerCellStyleMarked,
    CDZConsoleLoggerCellStyleExpanded,
};

@interface CDZConsoleLoggerCellItem : NSObject
@property (nonatomic, strong) CDZConsoleLoggerMessage *log;
@property (nonatomic, assign) CDZConsoleLoggerCellStyle style;
@property (nonatomic, strong) NSDate *logTime;
@property (nonatomic, copy) void(^selectionHandler)(CDZConsoleLoggerCellItem *aItem, NSIndexPath *indexPath);

@end
