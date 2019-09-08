//
//  GTListLoader.m
//  MyNewsApp
//
//  Created by thunderHou on 2019/9/7.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTListLoader.h"
#import "AFNetworking.h"
#import "GTListItem.h"

@implementation GTListLoader

- (void)loadListDataWithFinishBlock:(GTListLoaderFinishBlock)finishBlock {
    NSString *urlString = @"http://v.juhe.cn/toutiao/index?type=top&key=97ad001bfcc2082e2eeaf798bad3d54e";
    
//    [[AFHTTPSessionManager manager] GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
    NSURL *listURL = [NSURL URLWithString:urlString];
    __unused NSURLRequest *listRequest = [NSURLRequest requestWithURL:listURL];
    NSURLSession *listSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [listSession dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        NSArray *dataArray = [((NSDictionary *) [((NSDictionary *) jsonObj) objectForKey:@"result"]) objectForKey:@"data"];
        NSMutableArray *listItemArray = @[].mutableCopy;
        for (NSDictionary *info in dataArray) {
            GTListItem *listItem = [[GTListItem alloc] init];
            [listItem configWithDictionary:info];
            [listItemArray addObject:listItem];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishBlock) {
                finishBlock(error == nil, listItemArray.copy);
            }
        });
    }];
    [dataTask resume];
    
    [self _getSandBoxPath];
}

- (void)_getSandBoxPath {
    NSArray<NSString *> *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
}

@end
