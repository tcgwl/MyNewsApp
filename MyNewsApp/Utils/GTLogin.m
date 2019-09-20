//
//  GTLogin.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/18.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTLogin.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface GTLogin () <TencentSessionDelegate>

@property (nonatomic, strong, readwrite) TencentOAuth *tencentOAuth;
@property (nonatomic, copy, readwrite) GTLoginFinishBlock finishBlock;
@property (nonatomic, assign, readwrite) BOOL isLogin;

@end

@implementation GTLogin

+ (instancetype)sharedLogin {
    static GTLogin *login;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        login = [[GTLogin alloc] init];
    });
    return login;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isLogin = NO;
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"222222" andDelegate:self];
    }
    return self;
}

- (BOOL)isLogin {
    // 登录状态失效逻辑
    return _isLogin;
}

- (void)loginWithFinishBlock:(GTLoginFinishBlock)finishBlock {
    _finishBlock = [finishBlock copy];
    _tencentOAuth.authMode = kAuthModeClientSideToken;
    [_tencentOAuth authorize:@[kOPEN_PERMISSION_GET_USER_INFO,
                        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                        kOPEN_PERMISSION_ADD_ALBUM,
                        kOPEN_PERMISSION_ADD_ONE_BLOG,
                        kOPEN_PERMISSION_ADD_SHARE,
                        kOPEN_PERMISSION_ADD_TOPIC,
                        kOPEN_PERMISSION_CHECK_PAGE_FANS,
                        kOPEN_PERMISSION_GET_INFO,
                        kOPEN_PERMISSION_GET_OTHER_INFO,
                        kOPEN_PERMISSION_LIST_ALBUM,
                        kOPEN_PERMISSION_UPLOAD_PIC,
                        kOPEN_PERMISSION_GET_VIP_INFO,
                        kOPEN_PERMISSION_GET_VIP_RICH_INFO]];
}

- (void)logout {
    [_tencentOAuth logout:self];
    _isLogin = NO;
}

#pragma mark - delegate

- (void)tencentDidLogin {
    _isLogin = YES;
    // 保存openid
    [_tencentOAuth getUserInfo];
}

-(void)tencentDidNotLogin:(BOOL)cancelled {
    if (_finishBlock) {
        _finishBlock(NO);
    }
}

- (void)tencentDidNotNetWork {
    if (_finishBlock) {
        _finishBlock(NO);
    }
}

- (void)tencentDidLogout {
    // 退出登录，需要清理下存储在本地的登录数据
    NSLog(@"退出登录");
}

- (void)getUserInfoResponse:(APIResponse *)response {
    NSDictionary *userInfo = response.jsonResponse;
    _nickName = userInfo[@"nickname"];
    _address = userInfo[@"city"];
    _avatarUrl = userInfo[@"figureurl_qq_2"];
    if (_finishBlock) {
        _finishBlock(YES);
    }
}

#pragma mark - share
- (void)shareToQQWithArticleUrl:(NSURL *)articleUrl {
    // 登录校验
    if (_isLogin) {
        // loginWithFinishBlock
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:articleUrl title:@"iOS" description:@"从0开始iOS开发" previewImageURL:nil];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        __unused QQApiSendResultCode resultCode = [QQApiInterface SendReqToQZone:req];
    }
}

@end
