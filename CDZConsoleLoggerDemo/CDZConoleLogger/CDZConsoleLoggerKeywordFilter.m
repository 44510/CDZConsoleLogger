//
//  CDZConsoleLoggerConsoleLoggerKeywordFilter.m
//  CDZConsoleLoggerConsole
//
//  Created by Nemocdz on 2017/8/1.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "CDZConsoleLoggerKeywordFilter.h"
#import "CDZConsoleLoggerCellItem.h"
#import "CDZConsoleLoggerMessage.h"

@interface CDZConsoleLoggerKeywordFilter ()

@end

@implementation CDZConsoleLoggerKeywordFilter

- (instancetype)init{
    if (self = [super init]) {
        _enable = YES;
        _keyword = @"";
    }
    return self;
}

- (BOOL)isFilterItem:(CDZConsoleLoggerCellItem *)item{
    if (!item.log.mesaage.length) {
        return NO;
    }
    
    if (item.style == CDZConsoleLoggerCellStyleMarked) {
        return YES;
    }

    
    if ([item.log.mesaage containsString:self.keyword] || !self.keyword.length) {
        return YES;
    }
    else{
        return NO;
    }
}

- (NSArray <CDZConsoleLoggerCellItem *>*)filterItemsOfRawItems:(NSArray <CDZConsoleLoggerCellItem *> *)rawItems{
    NSMutableArray<CDZConsoleLoggerCellItem *> *filterItems = [NSMutableArray array];
    [rawItems enumerateObjectsUsingBlock:^(CDZConsoleLoggerCellItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isFilterItem:obj]) {
            [filterItems addObject:obj];
        }
    }];
    return [filterItems copy];
}

- (BOOL)enableFilter{
    return self.isEnable;
}

@end
