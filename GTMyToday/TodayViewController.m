//
//  TodayViewController.m
//  GTMyToday
//
//  Created by rainHou on 2019/9/20.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 200, 100)];
        [button setTitle:@"点击跳转" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(_openSampleApp) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    
    // Extension 共享数据
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.rainhou.MyNewsApp"];
//    [userDefaults setObject:@"从0开发一款iOS App" forKey:@"title"];
    NSString *shareTitle = [userDefaults objectForKey:@"title"];
    NSLog(@"共享数据：%@", shareTitle);
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

#pragma mark - private
- (void)_openSampleApp {
    // 跳转到主App
    [self.extensionContext openURL:[NSURL URLWithString:@"rainhounews://"] completionHandler:^(BOOL success) {
        NSLog(@"通过Extension跳转到主App");
    }];
}

@end
