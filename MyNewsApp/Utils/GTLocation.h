//
//  GTLocation.h
//  MyNewsApp
//
//  Created by rainHou on 2019/9/19.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 App中统一的位置信息管理
 */
@interface GTLocation : NSObject

+ (GTLocation *)sharedLocation;
- (void)checkLocationAuthorization;

@end

NS_ASSUME_NONNULL_END
