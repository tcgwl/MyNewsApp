//
//  GTVideoCoverView.h
//  MyNewsApp
//
//  Created by rainHou on 2019/9/11.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTVideoCoverView : UICollectionViewCell

/**
 根据数据布局，封面图&播放 url
 */
- (void)layoutWithVideoCoverUrl:(NSString *)videoCoverUrl videoUrl:(NSString *)videoUrl;

@end

NS_ASSUME_NONNULL_END
