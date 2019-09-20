//
//  GTNotification.h
//  MyNewsApp
//
//  Created by rainHou on 2019/9/19.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 APP 推送管理
 */
@interface GTNotification : NSObject

+ (GTNotification *)sharedNotification;
- (void)checkNotificationAuthorization;

@end

NS_ASSUME_NONNULL_END
