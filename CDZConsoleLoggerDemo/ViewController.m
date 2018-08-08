//
//  ViewController.m
//  CDZConsoleLoggerDemo
//
//  Created by Nemocdz on 2018/8/9.
//  Copyright © 2018年 Nemocdz. All rights reserved.
//

#import "ViewController.h"

#import "CDZConsoleLoggerDashboard.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CDZConsoleLoggerDashboard sharedDashboard].mini = YES;
    
    [self generateRandomLogMessage];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)showDashBoard:(UIButton *)sender {
    [[CDZConsoleLoggerDashboard sharedDashboard] show];
}

- (void)generateRandomLogMessage{
    // Random message format
    
    // Random level
    NSUInteger randomLevel = arc4random() % 5;
    
    
    CDZConsoleLoggerMessage *message = [CDZConsoleLoggerMessage.alloc init];
    message.mesaage = @"[CDZConsoleLogger]this is a log message";
    
    // Log
    switch (randomLevel){
        case 4:
            message.level = CDZConsoleLoggerLevelFatal;
            break;
        case 3:
            message.level = CDZConsoleLoggerLevelWarn;
            break;
        case 2:
            message.level = CDZConsoleLoggerLevelInfo;
            break;
        case 1:
            message.level = CDZConsoleLoggerLevelTrace;
            break;
        default:
            message.level = CDZConsoleLoggerLevelDebug;
            break;
    }
    [[CDZConsoleLoggerDashboard sharedDashboard].logger logMessage:message];
    
    // Schedule next message
    double delayInSeconds = (arc4random() % 100) / pow(10.0,0.9);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self generateRandomLogMessage];
    });
}


@end
