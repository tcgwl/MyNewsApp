//
//  GTMediator.h
//  MyNewsApp
//
//  Created by rainHou on 2019/9/17.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 常用的三种组件化方案
 */
@protocol GTDetailViewControllerProtocol <NSObject>

- (__kindof UIViewController *)detailViewControllerWithUrl:(NSString *)detailUrl;

@end

@interface GTMediator : NSObject

// target action
+ (__kindof UIViewController *)detailViewControllerWithUrl:(NSString *)detailUrl;

// url scheme
typedef void(^GTMediatorProcessBlock)(NSDictionary *params);
+ (void)registerScheme:(NSString *)scheme processBlock:(GTMediatorProcessBlock)processBlock;
+ (void)openUrl:(NSString *)url params:(NSDictionary *)params;

//protocol class
+ (void)registerProtocol:(Protocol *)protocol class:(Class)cls;
+ (Class)classForProtocol:(Protocol *)protocol;

@end

NS_ASSUME_NONNULL_END
