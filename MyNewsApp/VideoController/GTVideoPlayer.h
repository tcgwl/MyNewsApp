//
//  GTVideoPlayer.h
//  MyNewsApp
//
//  Created by rainHou on 2019/9/11.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 播放器
 */
@interface GTVideoPlayer : NSObject

/**
 全局播放器单例
 */
+ (GTVideoPlayer *)Player;

/**
 在指定View上通过url播放视频

 @param videoUrl 视频播放地址
 @param attachView 在哪个View上播放视频
 */
- (void)playVideoWithUrl:(NSString *)videoUrl attachView:(UIView *)attachView;

@end

NS_ASSUME_NONNULL_END
