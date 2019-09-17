//
//  GTVideoCoverView.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/11.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTVideoCoverView.h"
#import "GTVideoToolbar.h"
#import "GTVideoPlayer.h"
#import "GTScreen.h"

@interface GTVideoCoverView ()

@property (nonatomic, strong, readwrite) UIImageView *coverView;
@property (nonatomic, strong, readwrite) UIImageView *playButton;
@property (nonatomic, copy, readwrite) NSString *videoUrl;
@property (nonatomic, strong, readwrite) GTVideoToolbar *toolbar;

@end

@implementation GTVideoCoverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:({
            _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - GTVideoToolbarHeight)];
            _coverView;
        })];
        
        [_coverView addSubview:({
            _playButton = [[UIImageView alloc] initWithFrame:CGRectMake((_coverView.bounds.size.width - UI(50)) / 2, (_coverView.bounds.size.height - UI(50)) / 2, UI(50), UI(50))];
            _playButton.image = [UIImage imageNamed:@"videoPlay"];
            _playButton;
        })];
        
        [self addSubview:({
            _toolbar = [[GTVideoToolbar alloc] initWithFrame:CGRectMake(0, _coverView.bounds.size.height, frame.size.width, GTVideoToolbarHeight)];
            _toolbar;
        })];
        
        // 点击全部Item都支持播放
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapToPlay)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark - public method

- (void)layoutWithVideoCoverUrl:(NSString *)videoCoverUrl videoUrl:(NSString *)videoUrl {
    _coverView.image = [UIImage imageNamed:videoCoverUrl];
    _videoUrl = videoUrl;
    [_toolbar layoutWithModel:nil];
}

#pragma mark - private method

- (void)_tapToPlay {
    [[GTVideoPlayer Player] playVideoWithUrl:_videoUrl attachView:_coverView];
}

@end
