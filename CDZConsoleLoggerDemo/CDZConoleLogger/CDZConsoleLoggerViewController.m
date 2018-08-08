//
//  CDZConsoleLoggerConsoleViewController.m
//  CDZConsoleLoggerConsole
//
//  Created by Nemocdz on 2017/7/31.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "CDZConsoleLoggerViewController.h"
#import "CDZConsoleLoggerCell.h"
#import "CDZConsoleLogger.h"
#import "CDZConsoleLoggerMessage.h"
#import "CDZConsoleLoggerTableView.h"
#import "CDZConsoleLoggerLevelFilter.h"
#import "CDZConsoleLoggerKeywordFilter.h"
#import "UIView+CDZConsoleLogger.h"

static NSString * const CDZConsoleLoggerCellIdentifer = @"a";
static CGFloat CDZConsoleLoggerToolViewHeight = 20;


@interface CDZConsoleLoggerViewController ()<UISearchBarDelegate,CDZConsoleLoggerDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, weak) CDZConsoleLogger *currentLogger;

@property (nonatomic, strong) UIButton *markButton;
@property (nonatomic, strong) UIButton *clearButton;

@property (nonatomic, strong) CDZConsoleLoggerLevelFilter *levelFilter;
@property (nonatomic, strong) CDZConsoleLoggerKeywordFilter *keywordFilter;

@property (nonatomic, copy) NSArray <CDZConsoleLoggerMessage *>  *visualMessages;


@end

@implementation CDZConsoleLoggerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];

}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)setupViews{
    self.view.clipsToBounds = YES;
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.consoleView];
    [self.view addSubview:self.toolView];
    [self.toolView addSubview:self.markButton];
    [self.toolView addSubview:self.clearButton];
    [self.searchBar sizeToFit];
}



+ (CDZConsoleLoggerLevel)levelOfScopeIndex:(NSInteger)index{
    switch (index) {
        case 1:
            return CDZConsoleLoggerLevelDebug;
            break;
        case 2:
            return CDZConsoleLoggerLevelTrace;
            break;
        case 3:
            return CDZConsoleLoggerLevelInfo;
            break;
        case 4:
            return CDZConsoleLoggerLevelWarn;
            break;
        case 5:
            return CDZConsoleLoggerLevelFatal;
            break;
        default:
            return CDZConsoleLoggerLevelDebug;
            break;
    }
}



#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    if (selectedScope == 0) {
        self.levelFilter.enable = NO;
        [self.currentLogger updateConsoleFromFilters];
    }
    else {
        CDZConsoleLoggerLevel level = [CDZConsoleLoggerViewController levelOfScopeIndex:selectedScope];
        [self.levelFilter removeAllLevels];
        [self.levelFilter addLevel:level];
        self.levelFilter.enable = YES;
        [self.currentLogger updateConsoleFromFilters];
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.keywordFilter.keyword = searchText;
    self.keywordFilter.enable  = YES;
    [self.currentLogger updateConsoleFromFilters];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

#pragma mark - Touch Event

- (void)addMark:(UIButton *)button{
    [self.currentLogger addMarkAtDate:[NSDate date]];
}

- (void)clearConsole:(UIButton *)button{
    [self.currentLogger clearConsole];
}


#pragma mark - CDZConsoleLoggerConsoleLoggerDelegate

- (void)consoleLogger:(CDZConsoleLogger *)logger currentLog:(CDZConsoleLoggerMessage *)logMessage{
    if ([self.delegate respondsToSelector:@selector(consoleViewController:currentLogMessage:)]) {
        [self.delegate consoleViewController:self currentLogMessage:logMessage];
    }
}


#pragma mark - setter&getter

- (UIButton *)markButton{
    if (!_markButton) {
        _markButton = [UIButton.alloc initWithFrame:CGRectMake(100, 0, 50, CDZConsoleLoggerToolViewHeight)];
        _markButton.backgroundColor = UIColor.darkGrayColor;
        [_markButton setTitle:@"Mark" forState:UIControlStateNormal];
        [_markButton addTarget:self action:@selector(addMark:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _markButton;
}

- (UIButton *)clearButton{
    if (!_clearButton) {
        _clearButton = [UIButton.alloc initWithFrame:CGRectMake(self.markButton.right + 10, 0, 55, CDZConsoleLoggerToolViewHeight)];
        _clearButton.backgroundColor = UIColor.darkGrayColor;
        [_clearButton setTitle:@"Clear" forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearConsole:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}


- (UIView *)toolView{
    if (!_toolView) {
        _toolView = [UIView.alloc initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, CDZConsoleLoggerToolViewHeight)];
        _toolView.backgroundColor = UIColor.clearColor;
    }
    return _toolView;
}


- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [UISearchBar.alloc initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 88)];
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = YES;
        _searchBar.placeholder = @"Keyword";
        _searchBar.scopeButtonTitles = @[@"All",
                                         CDZConsoleLoggerNameOfLogLevel(CDZConsoleLoggerLevelDebug),
                                         CDZConsoleLoggerNameOfLogLevel(CDZConsoleLoggerLevelTrace),
                                         CDZConsoleLoggerNameOfLogLevel(CDZConsoleLoggerLevelInfo),
                                         CDZConsoleLoggerNameOfLogLevel(CDZConsoleLoggerLevelWarn),
                                         CDZConsoleLoggerNameOfLogLevel(CDZConsoleLoggerLevelFatal)];
        _searchBar.barStyle = UIBarStyleBlack;
        _searchBar.showsScopeBar = YES;
        _searchBar.selectedScopeButtonIndex = 0;
        [self.currentLogger addFilter:self.levelFilter];
        [self.currentLogger addFilter:self.keywordFilter];
    }
    return _searchBar;
}


- (CDZConsoleLoggerTableView *)consoleView{
    if (!_consoleView) {
        _consoleView = [CDZConsoleLoggerTableView.alloc initWithFrame:CGRectMake(0, 88, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - 88)];
        _consoleView.backgroundColor = [UIColor blackColor];
    }
    return _consoleView;
}

- (CDZConsoleLogger *)currentLogger{
    if (!_currentLogger) {
        _currentLogger = self.consoleView.logger;
        _currentLogger.delegate = self;
        if ([self.delegate respondsToSelector:@selector(consoleViewController:currentLogger:)]) {
            [self.delegate consoleViewController:self currentLogger:_currentLogger];
        }
    }
    return _currentLogger;
}


- (CDZConsoleLoggerLevelFilter *)levelFilter{
    if (!_levelFilter) {
        _levelFilter = [CDZConsoleLoggerLevelFilter.alloc init];
        _levelFilter.enable = NO;
    }
    return _levelFilter;
}

- (CDZConsoleLoggerKeywordFilter *)keywordFilter{
    if (!_keywordFilter) {
        _keywordFilter = [CDZConsoleLoggerKeywordFilter.alloc init];
        _keywordFilter.enable = NO;
    }
    return _keywordFilter;
}



@end
