//
//  GTNotification.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/19.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTNotification.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

@interface GTNotification () <UNUserNotificationCenterDelegate>

@property (nonatomic, strong, readwrite) UNUserNotificationCenter *notificationCenter;

@end

@implementation GTNotification

+ (GTNotification *)sharedNotification {
    static GTNotification *notification;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notification = [[GTNotification alloc] init];
    });
    return notification;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        self.notificationCenter.delegate = self;
    }
    return self;
}

- (void)checkNotificationAuthorization {
    [self.notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // 本地推送
            [self _pushLocalNotification];
            
//            // 远程推送
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // 向APNs注册Token，UIApplicationDelegate回调注册结果
//                [[UIApplication sharedApplication] registerForRemoteNotifications];
//            });
        }
    }];
}

#pragma mark - private

- (void)_pushLocalNotification {
    // 推送内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.badge = @(3);
    content.title = @"极客时间";
    content.body = @"从0开发一款iOS App";
    content.sound = [UNNotificationSound defaultSound];
    // 触发时机
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5.f repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"_pushLocalNotification" content:content trigger:trigger];
    [self.notificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"本地推送");
    }];
}

#pragma mark - delegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"通知到来");
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
//    // 处理badge展示逻辑
//    // 点击之后根据业务逻辑处理
    NSInteger badgeNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
    NSLog(@"badgeNum=%ld", badgeNum);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNum - 1];
    
    NSLog(@"点击通知 处理业务逻辑");
    completionHandler();
}

@end
