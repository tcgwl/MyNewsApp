//
//  GTVideoToolbar.h
//  MyNewsApp
//
//  Created by rainHou on 2019/9/11.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTScreen.h"

NS_ASSUME_NONNULL_BEGIN

#define GTVideoToolbarHeight UI(60)

/**
 视频ViewController Item下的Toolbar
 */
@interface GTVideoToolbar : UIView

/**
 根据数据布局Toolbar
 */
- (void)layoutWithModel:(nullable id)model;

@end

NS_ASSUME_NONNULL_END
