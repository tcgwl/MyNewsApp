//
//  GTVideoPlayer.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/11.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface GTVideoPlayer ()

@property (nonatomic, strong, readwrite) AVPlayerItem *playerItem;
@property (nonatomic, strong, readwrite) AVPlayer *player;
@property (nonatomic, strong, readwrite) AVPlayerLayer *playerLayer;
@property (nonatomic, strong, readwrite) NSString *playVideoUrl;

@end

@implementation GTVideoPlayer

+ (GTVideoPlayer *)Player {
    static GTVideoPlayer *videoPlayer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoPlayer = [[GTVideoPlayer alloc] init];
    });
    return videoPlayer;
}

- (void)playVideoWithUrl:(NSString *)videoUrl attachView:(UIView *)attachView {
    // 停止播放
    [self _stopPlay];
    
    _playVideoUrl = videoUrl;
    NSURL *videoURL = [NSURL URLWithString:videoUrl];
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    _playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    // 注册监听
    // 监听视频资源状态
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听视频缓冲进度
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    // 创建播放器
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    // 监听播放器播放进度 每隔1s
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSLog(@"播放进度：%@", @(CMTimeGetSeconds(time)));
    }];
    
    // 展示playerLayer
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = attachView.bounds;
    [attachView.layer addSublayer:_playerLayer];
    
    // 接收播放完成Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handlePlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark - private method

- (void)_stopPlay {
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    // 销毁播放器
    [_playerLayer removeFromSuperlayer];
    _playerItem = nil;
    _player = nil;
    _playVideoUrl = nil;
}

- (void)_handlePlayEnd {
    // 播放完成后循环播放
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (((NSNumber *)[change objectForKey:NSKeyValueChangeNewKey]).integerValue == AVPlayerItemStatusReadyToPlay) {
            // 需要在状态变化后获取时间
            CMTime duration = [_playerItem duration];
            CGFloat videoDuration = CMTimeGetSeconds(duration);
            NSLog(@"视频总时长：%@", @(videoDuration));
            // 在合适的时机开始播放
            [_player play];
        } else {
            // 监控错误
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 缓冲进度监听
        NSLog(@"缓冲：%@", [change objectForKey:NSKeyValueChangeNewKey]);
    }
}

@end
