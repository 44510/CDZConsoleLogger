
//
//  CDZConsoleLoggerConsoleLoggerLevelFilter.m
//  CDZConsoleLoggerConsole
//
//  Created by Nemocdz on 2017/8/1.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "CDZConsoleLoggerLevelFilter.h"
#import "CDZConsoleLoggerCellItem.h"


@interface CDZConsoleLoggerLevelFilter ()
@property (nonatomic, strong) NSMutableSet<NSNumber *> *levels;
@end

@implementation CDZConsoleLoggerLevelFilter

+ (instancetype)allLevelFilter{
    CDZConsoleLoggerLevelFilter *filter = [CDZConsoleLoggerLevelFilter.alloc init];
    [filter addAllLevels];
    return filter;
}

- (instancetype)init{
    if (self = [super init]) {
        _levels = [NSMutableSet set];
        _enable = YES;
    }
    return self;
}

- (void)addAllLevels{
    //[self removeAllLevels];
    [self addLevel:CDZConsoleLoggerLevelDebug];
    [self addLevel:CDZConsoleLoggerLevelTrace];
    [self addLevel:CDZConsoleLoggerLevelInfo];
    [self addLevel:CDZConsoleLoggerLevelWarn];
    [self addLevel:CDZConsoleLoggerLevelFatal];
}

- (void)addLevel:(CDZConsoleLoggerLevel)level{
    [self.levels addObject:@(level)];
}

- (void)removeLevel:(CDZConsoleLoggerLevel)level{
    [self.levels removeObject:@(level)];
}

- (void)removeAllLevels{
    [self.levels removeAllObjects];
}

- (BOOL)isFilterItem:(CDZConsoleLoggerCellItem *)item{
    if (!item) {
        return NO;
    }
    
    if (item.style == CDZConsoleLoggerCellStyleMarked) {
        return YES;
    }
    
    NSNumber *level = @(item.log.level);
    if ([self.levels containsObject:level]) {
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
