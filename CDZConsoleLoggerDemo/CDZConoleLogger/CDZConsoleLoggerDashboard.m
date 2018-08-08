//
//  CDZConsoleLoggerConsoleDashboard.m
//  CDZConsoleLoggerConsole
//
//  Created by Nemocdz on 2017/8/1.
//  Copyright © 2017年 Nemocdz. All rights reserved.
//

#import "CDZConsoleLoggerDashboard.h"
#import "CDZConsoleLoggerViewController.h"
#import "CDZConsoleLoggerTableView.h"
#import "UIView+CDZConsoleLogger.h"

static CDZConsoleLoggerDashboard * _sharedDashboard;

@interface CDZConsoleLoggerDashboard()<CDZConsoleLoggerViewControllerDelegate>
@property (nonatomic, weak) UIWindow *lastWindow;
@property (nonatomic, strong) UIButton *dragButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *miniLabel;
@property (nonatomic, strong) CDZConsoleLoggerViewController *consoleViewController;
@end

@implementation CDZConsoleLoggerDashboard

+ (instancetype)sharedDashboard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDashboard = [[self alloc] initWithFrame:UIScreen.mainScreen.bounds];
    });
    return _sharedDashboard;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.tintColor = [UIColor grayColor];
        CDZConsoleLoggerViewController *controller = [CDZConsoleLoggerViewController.alloc init];
        self.consoleViewController = controller;
        controller.delegate = self;
        self.rootViewController = controller;
        [self setupViews];
    }
    return self;
}



- (void)setupViews{
    [self.rootViewController.view addSubview:self.dragButton];
    [self.rootViewController.view addSubview:self.miniLabel];
    [self.rootViewController.view addSubview:self.closeButton];
}


- (void)show{
    if (!self.hidden){
    } else {
        self.hidden = NO;
        self.lastWindow = [UIApplication sharedApplication].keyWindow;
    }
}

- (void)hide{
    if (self.hidden) {
    } else {
        self.hidden = YES;
        [self.lastWindow makeKeyWindow];
    }
}

- (void)setMini:(BOOL)mini{
    _mini = mini;
    if (mini) {
        self.height = 20;
        [self.lastWindow makeKeyWindow];
        self.consoleViewController.toolView.hidden = YES;
        self.miniLabel.hidden = NO;
        self.dragButton.bottom = self.height;
        self.closeButton.bottom = self.height;
        self.consoleViewController.toolView.bottom = self.height;
        self.consoleViewController.consoleView.height = 0;
        self.closeButton.hidden = YES;
    }
}

#pragma mark - CDZConsoleLoggerConsoleViewControllerDelegate

- (void)consoleViewController:(CDZConsoleLoggerViewController *)viewController currentLogger:(CDZConsoleLogger *)logger{
    self.logger = logger;
}

- (void)consoleViewController:(CDZConsoleLoggerViewController *)viewController currentLogMessage:(CDZConsoleLoggerMessage *)logMessage{
    self.miniLabel.textColor = CDZConsoleLoggerTextColorOfLogLevel(logMessage.level);
    self.miniLabel.text = logMessage.mesaage;
}


#pragma mark - Touch Event

- (void)dragMoving:(UIControl *)control withEvent:(UIEvent *)event{
    CGPoint point = [[event.allTouches anyObject] locationInView:self.rootViewController.view];
    CGFloat bottom = point.y + 10;
    
    CGFloat height = 0;
    
    BOOL mini = NO;
    if (bottom <= 20) {
        height = 20;
        mini = YES;
        self.dragButton.top = 0;
    }
    else if (bottom > UIScreen.mainScreen.bounds.size.height){
        height = UIScreen.mainScreen.bounds.size.height;
    }
    else{
        height = bottom;
    }
    
    if (mini) {
        self.mini = mini;
    }
    else{
        self.mini = NO;
        self.consoleViewController.toolView.bottom = height;
        self.height = height;
        self.dragButton.bottom = self.height;
        self.closeButton.bottom = self.height;
        self.closeButton.hidden = NO;
        [self makeKeyWindow];
        self.consoleViewController.toolView.hidden = NO;
        self.miniLabel.hidden = YES;
        if (height > self.consoleViewController.consoleView.top) {
            self.consoleViewController.consoleView.height = height - self.consoleViewController.consoleView.top;
        }
    }
}

- (void)dragEnd:(UIControl *)control withEvent:(UIEvent *)event{
    [self dragMoving:control withEvent:event];
}

- (void)tap:(UIControl *)control withEvent:(UIEvent *)event{
    if ( [event.allTouches anyObject].tapCount < 2) {
        return;
    }
    if (self.isMini) {
        self.height = UIScreen.mainScreen.bounds.size.height;
        self.dragButton.bottom = self.height;
        self.closeButton.bottom = self.height;
        self.closeButton.hidden = NO;
        self.consoleViewController.consoleView.height = self.height - self.consoleViewController.consoleView.top;
        self.consoleViewController.toolView.bottom = self.height;
        self.consoleViewController.toolView.hidden = NO;
        self.miniLabel.hidden = YES;
        self.mini = NO;
    }
    else{
        self.mini = YES;
    }
}

#pragma mark - setter&getter

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton.alloc initWithFrame:CGRectMake(self.width - 50 , 0, 50 ,20)];
        [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
        _closeButton.backgroundColor = UIColor.grayColor;
        [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.hidden = YES;

    }
    return _closeButton;
}

- (UIButton *)dragButton{
    if (!_dragButton) {
        _dragButton = [UIButton.alloc initWithFrame:CGRectMake(0, 0, 90, 20)];
        _dragButton.backgroundColor = UIColor.grayColor;
        [_dragButton setTitle:@"DoubleTap" forState:UIControlStateNormal];
        [_dragButton addTarget:self action:@selector(tap:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_dragButton addTarget:self action:@selector(dragMoving:withEvent:)forControlEvents:UIControlEventTouchDragInside];
        [_dragButton addTarget:self action:@selector(dragEnd:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    }
    return _dragButton;
}

- (UILabel *)miniLabel{
    if (!_miniLabel) {
        _miniLabel = [UILabel.alloc initWithFrame:CGRectMake(self.dragButton.right, 0, self.width - self.dragButton.right, 20)];
        _miniLabel.hidden = YES;
        _miniLabel.textColor = UIColor.whiteColor;
        _miniLabel.backgroundColor = UIColor.blackColor;
        _miniLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _miniLabel;
}


@end
