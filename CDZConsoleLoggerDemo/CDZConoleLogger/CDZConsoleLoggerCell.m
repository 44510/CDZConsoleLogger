//
//  CDZConsoleLoggerCell.m
//  CDZConsoleLoggerCell
//
//  Created by Nemocdz on 2017/7/31.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "CDZConsoleLoggerCell.h"
#import "CDZConsoleLoggerMessage.h"
#import "CDZConsoleLoggerCellItem.h"
#import "UIView+CDZConsoleLogger.h"

static CGFloat CDZConsoleLoggerCellNormalHeight = 25;
static CGFloat CDZConsoleLoggerCellMarkedHeight = 23;
static CGFloat CDZConsoleLoggerCellExpandedHeight = 120;

@interface CDZConsoleLoggerCell()
@property (nonatomic, strong) UILabel *logTextLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, weak) CDZConsoleLoggerCellItem *item;
@end

@implementation CDZConsoleLoggerCell

+ (CGFloat)tableView:(__kindof UITableView *)tableView rowHeightForItem:(CDZConsoleLoggerCellItem *)item{
    switch (item.style) {
        case CDZConsoleLoggerCellStyleNormal:
            return CDZConsoleLoggerCellNormalHeight;
            break;
        case CDZConsoleLoggerCellStyleMarked:
            return CDZConsoleLoggerCellMarkedHeight;
            break;
        case CDZConsoleLoggerCellStyleExpanded:
            return CDZConsoleLoggerCellExpandedHeight;
            break;
        default:
            return 0;
            break;
    }
}

-  (void)configWithCellItem:(CDZConsoleLoggerCellItem *)item{
    self.item  = item;
    switch (item.style) {
        case CDZConsoleLoggerCellStyleNormal:
            [self configNoramalViewsWithLog:item.log];
            break;
        case CDZConsoleLoggerCellStyleMarked:
            [self configMarkerWithDate:item.logTime];
            break;
        case CDZConsoleLoggerCellStyleExpanded:
            [self configExpandedViewsWithLog:item.log];
            break;
            
        default:
            break;
    }
}

- (void)configMarkerWithDate:(NSDate *)date{
    self.logTextLabel.text = [NSString stringWithFormat:@"Mark at %@",CDZConsoleLoggerDateStringFromDate(date)];
    self.detailLabel.hidden = YES;
    self.logTextLabel.textColor = UIColor.lightGrayColor;
    [self.logTextLabel sizeToFit];
}


- (void)configExpandedViewsWithLog:(CDZConsoleLoggerMessage *)log{
    [self configNoramalViewsWithLog:log];
    self.detailLabel.textColor = CDZConsoleLoggerTextColorOfLogLevel(log.level);
    self.detailLabel.hidden = NO;
    NSArray <NSString *> *paths = [log.fileName componentsSeparatedByString:@"/"];
    self.detailLabel.text = [NSString stringWithFormat:@"level:%@\nfile:%@\nline:%@\nfunc:%@\n%@",CDZConsoleLoggerNameOfLogLevel(log.level),paths.lastObject,[NSNumber numberWithUnsignedInteger:log.line],log.funcName,self.item.logTime];
    [self.detailLabel sizeToFit];
}

- (void)configNoramalViewsWithLog:(CDZConsoleLoggerMessage *)log{
    self.logTextLabel.textColor = CDZConsoleLoggerTextColorOfLogLevel(log.level);
    self.detailLabel.hidden = YES;
    self.logTextLabel.text = log.mesaage;
    [self.logTextLabel sizeToFit];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupViews{
    [self.contentView addSubview:self.logTextLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.line];
}


- (UIView *)line{
    if (!_line) {
        _line = [UIView.alloc initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 1)];
        _line.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
    }
    return _line;
}

- (UILabel *)logTextLabel{
    if (!_logTextLabel) {
        _logTextLabel = [UILabel.alloc initWithFrame:CGRectMake(5, 3, self.contentView.width - 10, CDZConsoleLoggerCellNormalHeight)];
        _logTextLabel.numberOfLines = 1;
        _logTextLabel.font = [UIFont systemFontOfSize:14.f];
        _logTextLabel.textColor = [UIColor grayColor];
    }
    return _logTextLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel.alloc initWithFrame:CGRectMake(5, self.logTextLabel.bottom, self.contentView.width - 10, 1)];
        _detailLabel.numberOfLines = 0;
        _detailLabel.hidden = YES;
        _detailLabel.font = [UIFont systemFontOfSize:13.f];
        _detailLabel.textColor = UIColor.grayColor;
    }
    return _detailLabel;
}

@end
