//
//  CDZLogConsoleLogger.h
//  CDZLogConsole
//
//  Created by Nemocdz on 2017/7/31.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class CDZConsoleLoggerTableView;
@class CDZConsoleLoggerCellItem;
@class CDZConsoleLogger;
@class CDZConsoleLoggerMessage;

//过滤器，可以筛选显示的log
@protocol CDZConsoleLoggerFilter <NSObject>
@optional
/**
 从原始数据过滤出合适的数据

 @param rawItems 原始数据
 @return 过滤后数据
 */
- (NSArray <CDZConsoleLoggerCellItem *>*)filterItemsOfRawItems:(NSArray <CDZConsoleLoggerCellItem *> *)rawItems;

@required
/**
 判断是否合适

 @param item 元数据
 @return 是否合适
 */
- (BOOL)isFilterItem:(CDZConsoleLoggerCellItem *)item;

//是否开启
- (BOOL)enableFilter;

@end

@protocol CDZConsoleLoggerDelegate <NSObject>
@optional

/**
 当前输出日志，可供其它类使用

 @param logger logger
 @param logMessage log消息
 */
- (void)consoleLogger:(CDZConsoleLogger *)logger currentLog:(CDZConsoleLoggerMessage *)logMessage;

@end

@interface CDZConsoleLogger : NSObject<UITableViewDataSource,UITableViewDelegate>

//记录log
- (void)logMessage:(CDZConsoleLoggerMessage *)message;

//增加一个mark消息
- (void)addMarkAtDate:(NSDate *)date;

//清除控制台
- (void)clearConsole;

//增加一个过滤器
- (void)addFilter:(id<CDZConsoleLoggerFilter>)fiter;

//移除一个过滤器
- (void)removeFilter:(id<CDZConsoleLoggerFilter>)filter;

//去除所有过滤器
- (void)removeAllFilters;

//增加过滤器后刷新控制台
- (void)updateConsoleFromFilters;

//最大显示条数，默认100
@property (nonatomic, assign) NSUInteger maxMessageNumber;

//最小刷新间隔，默认0.3s
@property (nonatomic, assign) NSTimeInterval minUpdateInterval;

@property (nonatomic, weak) id<CDZConsoleLoggerDelegate> delegate;

@property (nonatomic, weak) CDZConsoleLoggerTableView  *consoleView;


@end
