//
//  GTLocation.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/19.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface GTLocation () <CLLocationManagerDelegate>

@property (nonatomic, strong, readwrite) CLLocationManager *locationManager;

@end

@implementation GTLocation

+ (GTLocation *)sharedLocation {
    static GTLocation *location;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[GTLocation alloc] init];
    });
    return location;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)checkLocationAuthorization {
    // 判断系统定位服务是否开启
    if (![CLLocationManager locationServicesEnabled]) {
        // 引导弹窗
    } else {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

#pragma mark - delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"使用应用期间");
        [self.locationManager startUpdatingLocation];
    } else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"不允许");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 地理信息
    CLLocation *location = [locations firstObject];
    CLGeocoder *coder = [[CLGeocoder alloc] init];
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 地标信息 placemarks
    }];
    
    [self.locationManager stopUpdatingLocation];
}

@end
