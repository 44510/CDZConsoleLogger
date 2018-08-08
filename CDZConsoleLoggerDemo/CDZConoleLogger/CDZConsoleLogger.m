//
//  CDZConsoleLoggerConsoleLogger.m
//  CDZConsoleLoggerConsole
//
//  Created by Nemocdz on 2017/7/31.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "CDZConsoleLogger.h"
#import "CDZConsoleLoggerMessage.h"
#import "CDZConsoleLoggerCell.h"
#import "CDZConsoleLoggerCellItem.h"
#import "CDZConsoleLoggerTableView.h"

static NSString * const CDZConsoleLoggerCellIdentifer = @"CDZConsoleLoggerConsoleCell";

@interface CDZConsoleLogger()
@property (nonatomic, strong) NSArray <CDZConsoleLoggerCellItem *> *visualCellItems;
@property (nonatomic, strong) NSMutableArray <CDZConsoleLoggerCellItem *> *rawCellItems;
@property (nonatomic, strong) NSMutableArray <CDZConsoleLoggerCellItem *> *bufferCellItems;
@property (nonatomic, strong) NSMutableSet <id<CDZConsoleLoggerFilter>> *filters;
@property (nonatomic, strong) dispatch_queue_t consoleQueue;
@property (nonatomic, strong) NSDate *lastUpdateDate;
@property (nonatomic, assign, getter=isUpdateScheduled) BOOL updateScheduled;
@end


@implementation CDZConsoleLogger

- (instancetype)init{
    if (self = [super init]) {
        _visualCellItems = [NSArray array];
        _bufferCellItems = [NSMutableArray array];
        _lastUpdateDate = [NSDate date];
        _maxMessageNumber = 100;
        _minUpdateInterval = 0.3;
        _rawCellItems = [NSMutableArray array];
        _filters = [NSMutableSet set];
        _consoleQueue = dispatch_queue_create("com.nemocdz.CDZConsoleLoggerConsoleQueue", NULL);
    }
    return self;
}

#pragma mark - About Filters

- (void)addFilter:(id<CDZConsoleLoggerFilter>)fiter{
    if (fiter) {
        [self.filters addObject:fiter];
    }
}

- (void)removeFilter:(id<CDZConsoleLoggerFilter>)filter{
    if (filter) {
        [self.filters removeObject:filter];
    }
}

- (void)removeAllFilters{
    [self.filters removeAllObjects];
}


- (void)updateConsoleFromFilters{
    dispatch_async(self.consoleQueue, ^{
        __block NSArray *filteredAllCellItems = [self.rawCellItems copy];
        
        //过滤所有数据
        [self.filters enumerateObjectsUsingBlock:^(id<CDZConsoleLoggerFilter>  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(enableFilter)] && [obj respondsToSelector:@selector(filterItemsOfRawItems:)]) {
                if ([obj enableFilter]) {
                    filteredAllCellItems= [obj filterItemsOfRawItems:filteredAllCellItems];
                }
            }
        }];
        
        self.visualCellItems = filteredAllCellItems;
        dispatch_sync(dispatch_get_main_queue(), ^ {
            [self.consoleView reloadData];
        });
    });
}


- (void)logMessage:(CDZConsoleLoggerMessage *)message{
    if (!message) {
        return;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(consoleLogger:currentLog:)]) {
        [self.delegate consoleLogger:self currentLog:message];
    }
    
    CDZConsoleLoggerCellItem *item = [CDZConsoleLoggerCellItem.alloc init];
    item.log = message;
    item.logTime = [NSDate date];
    __weak typeof(self) weakSelf = self;
    item.selectionHandler = ^(CDZConsoleLoggerCellItem *aItem, NSIndexPath *indexPath) {
        //点击后切换状态，局部刷新
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (aItem.style == CDZConsoleLoggerCellStyleNormal) {
            aItem.style = CDZConsoleLoggerCellStyleExpanded;
        }
        else if (aItem.style == CDZConsoleLoggerCellStyleExpanded){
            aItem.style = CDZConsoleLoggerCellStyleNormal;
        }
        [strongSelf.consoleView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //增加到剪贴板
        [UIPasteboard generalPasteboard].string = [strongSelf formatLog:aItem];
    };
    dispatch_async(self.consoleQueue, ^{
        [self updateCellItem:item];
    });
}



- (void)addMarkAtDate:(NSDate *)date{
    if (!date) {
        date = [NSDate date];
    }
    
    CDZConsoleLoggerCellItem *item = [CDZConsoleLoggerCellItem.alloc init];
    item.logTime = date;
    item.style = CDZConsoleLoggerCellStyleMarked;
    dispatch_async(self.consoleQueue, ^{
        
        [self updateCellItem:item];
    });
}

- (void)clearConsole{
    self.visualCellItems = @[];
    self.rawCellItems = [NSMutableArray array];
    [self.consoleView reloadData];
}

- (void)updateCellItem:(CDZConsoleLoggerCellItem *)item{
    //先插入缓存数据中
    [self.bufferCellItems insertObject:item atIndex:0];
    
    //如果已有挂起任务，则返回
    if (self.isUpdateScheduled) {
        return;
    }
    
    //判断时间距离上次更新时间
    NSTimeInterval timeToWaitForNextUpdate = self.minUpdateInterval + self.lastUpdateDate.timeIntervalSinceNow;
    //时间过短挂起
    if (timeToWaitForNextUpdate > 0){
        self.updateScheduled = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeToWaitForNextUpdate * NSEC_PER_SEC)), self.consoleQueue, ^ {
            [self updateConsoleFromBuffer];
            self.updateScheduled = NO;
        });
    }
    //直接更新
    else{
        [self updateConsoleFromBuffer];
    }
}

- (void)updateRawCellItemsFromBuffer{
    NSArray *tmp = [self.rawCellItems copy];
    [self.rawCellItems removeAllObjects];
    [self.rawCellItems addObjectsFromArray:[self.bufferCellItems copy]];
    [self.rawCellItems addObjectsFromArray:tmp];
    
    NSInteger maxRemovedItmesCount = (NSInteger)(self.rawCellItems.count - self.maxMessageNumber);
    if (maxRemovedItmesCount > 0){
        [self.rawCellItems removeObjectsInRange:NSMakeRange(self.maxMessageNumber, maxRemovedItmesCount)];
    }
    
    //清除缓冲数据
    [self.bufferCellItems removeAllObjects];
}



- (void)updateConsoleFromBuffer{
    NSInteger removedItemsCount = 0;
    NSInteger insteredItemsCount = 0;
    NSInteger keepItemsCount = 0;
    
    //将缓冲的数据进行过滤
    __block NSArray *filteredBufferCellItems = [self.bufferCellItems copy];
    [self.filters enumerateObjectsUsingBlock:^(id<CDZConsoleLoggerFilter>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(enableFilter)] && [obj respondsToSelector:@selector(filterItemsOfRawItems:)]) {
            if ([obj enableFilter]) {
                filteredBufferCellItems = [obj filterItemsOfRawItems:filteredBufferCellItems];
            }
        }
    }];
    
    //合并到即将显示的数据中
    NSMutableArray *resultCellItems = [NSMutableArray arrayWithCapacity:self.visualCellItems.count + filteredBufferCellItems.count];
    [resultCellItems addObjectsFromArray:filteredBufferCellItems];
    [resultCellItems addObjectsFromArray:self.visualCellItems];
    
    //计算是否超过最大数据数量
    NSInteger overMaxRemovedCount = (NSInteger)(resultCellItems.count - self.maxMessageNumber);
    removedItemsCount = MAX(overMaxRemovedCount, 0);
    if (overMaxRemovedCount > 0) {
        [resultCellItems removeObjectsInRange:NSMakeRange(self.maxMessageNumber, removedItemsCount)];
    }
    
    //计算需要插入和保持的
    insteredItemsCount = MIN(filteredBufferCellItems.count, self.maxMessageNumber);
    keepItemsCount = resultCellItems.count - insteredItemsCount;
    
    
    // Remove paths
    NSMutableArray *removePaths = [NSMutableArray arrayWithCapacity:removedItemsCount];
    if (removedItemsCount > 0){
        for (NSInteger i = resultCellItems.count - removedItemsCount; i < resultCellItems.count; i++){
            [removePaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    
    // Insert paths
    NSMutableArray * insertPaths = [NSMutableArray arrayWithCapacity:insteredItemsCount];
    if (insteredItemsCount > 0) {
        for (NSInteger i = 0; i < insteredItemsCount; i++){
            [insertPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    
    self.visualCellItems = [resultCellItems copy];
    //更新所有元数据
    [self updateRawCellItemsFromBuffer];
    
    dispatch_sync(dispatch_get_main_queue(), ^ {
        //完全刷新
        if (keepItemsCount == 0){
            [self.consoleView reloadData];
        }
        //局部刷新
        else{
            [self updateWithRemovePaths:[removePaths copy] insertPaths:[insertPaths copy]];
        }
    });
}



- (void)updateWithRemovePaths:(NSArray <NSIndexPath *> *)removePaths insertPaths:(NSArray <NSIndexPath *> *)insertPaths{
    @try{
        if (!insertPaths.count && !removePaths.count) {
            return;
        }
        [self.consoleView beginUpdates];
        if (insertPaths.count > 0){
            [self.consoleView insertRowsAtIndexPaths:insertPaths withRowAnimation:UITableViewRowAnimationFade];
        }

        if (removePaths.count  > 0){
            [self.consoleView deleteRowsAtIndexPaths:removePaths withRowAnimation:UITableViewRowAnimationFade];
            
        }
        [self.consoleView endUpdates];
    }
    @catch (NSException * exception){
        [self.consoleView reloadData];
    }
}


//格式化log，剪贴板使用等
- (NSString *)formatLog:(CDZConsoleLoggerCellItem *)cellItem{
    NSMutableString *formatMessage = [NSMutableString stringWithFormat:@"[%@][%@][%@:%lu]||_msg=%@", CDZConsoleLoggerNameOfLogLevel(cellItem.log.level), CDZConsoleLoggerDateStringFromDate(cellItem.logTime), cellItem.log.funcName, cellItem.log.line, cellItem.log.mesaage];
    [cellItem.log.userInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:NSString.class] && [obj isKindOfClass:NSString.class]) {
            [formatMessage appendString:[NSString stringWithFormat:@"||%@=%@",key, obj]];
        }
    }];
    return formatMessage;
}



- (CDZConsoleLoggerCellItem *)tableView:(UITableView *)tableView itemAtIndex:(NSIndexPath *)indexPath{
    if (self.visualCellItems.count > indexPath.row) {
        return self.visualCellItems[indexPath.row];
    }
    return nil;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CDZConsoleLoggerCellItem *item  = [self tableView:tableView itemAtIndex:indexPath];
    if (item.selectionHandler) {
        item.selectionHandler(item,indexPath);
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.consoleView.cellClass respondsToSelector:@selector(tableView:rowHeightForItem:)]) {
        return [self.consoleView.cellClass tableView:tableView rowHeightForItem:[self tableView:tableView itemAtIndex:indexPath]];
    }
    return 44;
}




#pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell<CDZConsoleLoggerCell> *cell = [tableView dequeueReusableCellWithIdentifier:CDZConsoleLoggerCellIdentifer];
    if (!cell && self.consoleView.cellClass) {
        cell = [self.consoleView.cellClass.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CDZConsoleLoggerCellIdentifer];
    }
    
    CDZConsoleLoggerCellItem *item = [self tableView:tableView itemAtIndex:indexPath];
    
    if (item && [cell respondsToSelector:@selector(configWithCellItem:)]) {
        [cell configWithCellItem:item];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.visualCellItems ? self.visualCellItems.count : 0;
}

@end


