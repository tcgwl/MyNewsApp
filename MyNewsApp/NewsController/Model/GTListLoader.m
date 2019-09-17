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
    // 使用AFNetworking加载数据
//    [[AFHTTPSessionManager manager] GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
    NSArray<GTListItem *> *localListData = [self _readDataFromLocal];
    if (localListData) {
        finishBlock(YES, localListData);
    }
    
    NSString *urlString = @"https://static001.geekbang.org/univer/classes/ios_dev/lession/45/toutiao.json";
//    NSString *urlString = @"http://v.juhe.cn/toutiao/index?type=top&key=97ad001bfcc2082e2eeaf798bad3d54e";
    NSURL *listURL = [NSURL URLWithString:urlString];
//    __unused NSURLRequest *listRequest = [NSURLRequest requestWithURL:listURL];
    NSURLSession *listSession = [NSURLSession sharedSession];
    
    __weak typeof(self)weakSelf = self;
    NSURLSessionDataTask *dataTask = [listSession dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        NSArray *dataArray = [((NSDictionary *) [((NSDictionary *) jsonObj) objectForKey:@"result"]) objectForKey:@"data"];
        NSMutableArray *listItemArray = @[].mutableCopy;
        for (NSDictionary *info in dataArray) {
            GTListItem *listItem = [[GTListItem alloc] init];
            [listItem configWithDictionary:info];
            [listItemArray addObject:listItem];
        }
        
        [strongSelf _archiveListDataWithArray:listItemArray.copy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishBlock) {
                finishBlock(error == nil, listItemArray.copy);
            }
        });
    }];
    
    [dataTask resume];
}

#pragma mark - private method

- (NSArray<GTListItem *> *)_readDataFromLocal {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [pathArray firstObject];
    NSString *listDataPath = [cachePath stringByAppendingPathComponent:@"GTData/list"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *readListData = [fileManager contentsAtPath:listDataPath];
    id unarchivedObj = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [GTListItem class], nil] fromData:readListData error:nil];
    if ([unarchivedObj isKindOfClass:[NSArray class]] && [unarchivedObj count] > 0) {
        return (NSArray<GTListItem *> *)unarchivedObj;
    }
    
    return nil;
}

- (void)_archiveListDataWithArray:(NSArray<GTListItem *> *)dataArray {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [pathArray firstObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //创建文件夹
    NSString *dataPath = [cachePath stringByAppendingPathComponent:@"GTData"];
    NSError *createError;
    [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&createError];
    
    //创建文件
    NSString *listDataPath = [dataPath stringByAppendingString:@"list"];
    NSData *listData = [NSKeyedArchiver archivedDataWithRootObject:dataArray requiringSecureCoding:YES error:nil];
    [fileManager createFileAtPath:listDataPath contents:listData attributes:nil];
}

@end
