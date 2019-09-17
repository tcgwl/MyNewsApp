//
//  GTScreen.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/12.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTScreen.h"

@implementation GTScreen

// iphone xs max
+ (CGSize)sizeFor65Inch {
    return CGSizeMake(414, 896);
}

// iphone xr
+ (CGSize)sizeFor61Inch {
    return CGSizeMake(414, 896);
}

// iphone x
+ (CGSize)sizeFor58Inch {
    return CGSizeMake(375, 812);
}

@end
