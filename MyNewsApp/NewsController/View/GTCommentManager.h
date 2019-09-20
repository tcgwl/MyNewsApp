//
//  GTCommentManager.h
//  MyNewsApp
//
//  Created by rainHou on 2019/9/20.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTCommentManager : NSObject

+ (GTCommentManager *)sharedCommentManager;
- (void)showCommentView;

@end

NS_ASSUME_NONNULL_END
