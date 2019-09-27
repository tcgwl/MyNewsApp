//
//  AppDelegate.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/5.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "AppDelegate.h"
#import "GTNewsViewController.h"
#import "GTVideoViewController.h"
#import "GTRecommendViewController.h"
#import "GTMineViewController.h"
#import "GTSplashView.h"
#include <execinfo.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "GTLocation.h"
#import "GTNotification.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    GTNewsViewController *newsController = [[GTNewsViewController alloc] init];
    GTVideoViewController *videoController = [[GTVideoViewController alloc] init];
    GTRecommendViewController *recommendController = [[GTRecommendViewController alloc] init];
    GTMineViewController *mineController = [[GTMineViewController alloc] init];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[newsController, videoController, recommendController, mineController]];
    tabBarController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    [self.window addSubview:({
        GTSplashView *splashView = [[GTSplashView alloc] initWithFrame:self.window.bounds];
        splashView;
    })];
    
    // 测试crash收集
//    [self _caughtException];
//    [@[].mutableCopy addObject:nil];
    
    // 定位
    [[GTLocation sharedLocation] checkLocationAuthorization];
    // 推送
    [[GTNotification sharedNotification] checkNotificationAuthorization];
    
    // Extension 共享数据
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.rainhou.MyNewsApp"];
    [userDefaults setObject:@"从0开发一款iOS App" forKey:@"title"];
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"切换tabBar");
//    // 测试更换App图标
//    [self _changeIcon];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - url scheme

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"url=%@", url);
    if (YES == [TencentOAuth CanHandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

#pragma mark - PUSH

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    // 向APNs注册Token成功，获得deviceToken，交由服务器，结合推送消息一起发送给APNs
    // 尽量收敛到GTNotification中实现
    NSLog(@"注册成功");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败");
}

#pragma mark - crash
- (void)_caughtException {
    // NSException
    NSSetUncaughtExceptionHandler(HandleNSException);
    
    // signal
    signal(SIGABRT, SignalExceptionHandler);
    signal(SIGILL, SignalExceptionHandler);
    signal(SIGSEGV, SignalExceptionHandler);
    signal(SIGFPE, SignalExceptionHandler);
    signal(SIGBUS, SignalExceptionHandler);
    signal(SIGPIPE, SignalExceptionHandler);
}

void HandleNSException(NSException *exception) {
    __unused NSString *reason = [exception reason];
    __unused NSString *name = [exception name];
    // 存储crash信息
}

void SignalExceptionHandler(int signal){
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i = 0; i < frames; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    // 存储crash信息
}

#pragma mark - 更换App图标
- (void)_changeIcon {
    if ([UIApplication sharedApplication].supportsAlternateIcons) {
        [[UIApplication sharedApplication] setAlternateIconName:@"ICONBLACK" completionHandler:^(NSError * _Nullable error) {
            NSLog(@"动态更换App图标的回调");
        }];
    }
}

@end
