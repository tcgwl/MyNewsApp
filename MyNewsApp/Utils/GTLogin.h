//
//  GTLogin.h
//  MyNewsApp
//
//  Created by rainHou on 2019/9/18.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GTLoginFinishBlock)(BOOL isLogin);
/**
 QQ登录和分享相关逻辑
 */
@interface GTLogin : NSObject

@property (nonatomic, strong, readonly) NSString *nickName;
@property (nonatomic, strong, readonly) NSString *address;
@property (nonatomic, strong, readonly) NSString *avatarUrl;

+ (instancetype)sharedLogin;

#pragma mark - 登录
- (BOOL)isLogin;
- (void)loginWithFinishBlock:(GTLoginFinishBlock)finishBlock;
- (void)logout;

#pragma mark - 分享
- (void)shareToQQWithArticleUrl:(NSURL *)articleUrl;

@end

NS_ASSUME_NONNULL_END
