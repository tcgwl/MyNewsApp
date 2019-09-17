//
//  GTDetailViewController.h
//  MyNewsApp
//
//  Created by rainHou on 2019/9/6.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMediator.h"

NS_ASSUME_NONNULL_BEGIN

/**
 文章详情页
 */
@interface GTDetailViewController : UIViewController<GTDetailViewControllerProtocol>

- (instancetype)initWithUrl:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
