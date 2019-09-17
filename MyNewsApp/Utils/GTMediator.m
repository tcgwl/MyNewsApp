//
//  GTMediator.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/17.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTMediator.h"

@implementation GTMediator

#pragma mark - target action
+ (__kindof UIViewController *)detailViewControllerWithUrl:(NSString *)detailUrl {
    Class detailCls = NSClassFromString(@"GTDetailViewController");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    UIViewController *controller = [[detailCls alloc] performSelector:NSSelectorFromString(@"initWithUrl:") withObject:detailUrl];
#pragma clang diagnostic pop
    return controller;
}

#pragma mark - url scheme
+ (NSMutableDictionary *)mediatorCache {
    static NSMutableDictionary *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = @{}.mutableCopy;
    });
    return cache;
}

+ (void)registerScheme:(NSString *)scheme processBlock:(GTMediatorProcessBlock)processBlock {
    if (scheme && processBlock) {
        [[[self class] mediatorCache] setObject:processBlock forKey:scheme];
    }
}

+ (void)openUrl:(NSString *)url params:(NSDictionary *)params {
    GTMediatorProcessBlock processBlock = [[[self class] mediatorCache] objectForKey:url];
    if (processBlock) {
        processBlock(params);
    }
}

#pragma mark - protocol class
+ (void)registerProtocol:(Protocol *)protocol class:(Class)cls {
    if (protocol && cls) {
        [[[self class] mediatorCache] setObject:cls forKey:NSStringFromProtocol(protocol)];
    }
}

+ (Class)classForProtocol:(Protocol *)protocol {
    return [[[self class] mediatorCache] objectForKey:NSStringFromProtocol(protocol)];
}

@end
