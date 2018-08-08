//
//  CDZLogConsoleCell.h
//  CDZLogConsole
//
//  Created by Nemocdz on 2017/7/31.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDZConsoleLoggerCellItem;

@protocol CDZConsoleLoggerCell<NSObject>
- (void)configWithCellItem:(CDZConsoleLoggerCellItem *)item;
+ (CGFloat)tableView:(__kindof UITableView *)tableView rowHeightForItem:(CDZConsoleLoggerCellItem *)item;

@end


@interface CDZConsoleLoggerCell : UITableViewCell<CDZConsoleLoggerCell>

@end


