//
//  GTListLoader.h
//  MyNewsApp
//
//  Created by thunderHou on 2019/9/7.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GTListItem;

NS_ASSUME_NONNULL_BEGIN

typedef void(^GTListLoaderFinishBlock)(BOOL success, NSArray<GTListItem *> *dataArray);

@interface GTListLoader : NSObject

- (void)loadListDataWithFinishBlock:(GTListLoaderFinishBlock)finishBlock;

@end

NS_ASSUME_NONNULL_END
