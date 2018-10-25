//
//  MyCoreLocation.m
//  bameng
//
//  Created by lhb on 16/11/11.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "LWCoreLocationManager.h"
#import <CoreLocation/CoreLocation.h>
@interface LWCoreLocationManager ()<CLLocationManagerDelegate>
/**
 * 定位管理器
 **/
@property (nonatomic, strong) CLLocationManager * locationManager;
/**
 * 地理编码
 **/
@property (nonatomic, strong) CLGeocoder *geoC;


@property (nonatomic, weak) LWRusultBlock block;



@end

@implementation LWCoreLocationManager

static LWCoreLocationManager * _LWCoreLocationManager;


- (CLGeocoder *)geoC{
    if (_geoC == nil) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

- (CLLocationManager *)locationManager{
    if(_locationManager == nil){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.distanceFilter = 100.0;
        [_locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}



+(instancetype)LWCoreLocationManagerShare{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_LWCoreLocationManager == nil){
            _LWCoreLocationManager = [[self alloc] init];
        }
    });
    return _LWCoreLocationManager;
}


- (instancetype)init{
    if (self = [super init]) {
        [self locationManager];
    }
    return self;
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{

    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }else if(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted){
        //用户拒绝了权限
        [self doDeniey];
    }
}


- (void)doDeniey{
//    if (self.forceOpenLocal) {
//        UIViewController * vc = [LWTool getCurrentVC];
//        if (vc.navigationController.viewControllers.count > 1) {
//            [vc.navigationController popViewControllerAnimated:YES];
//        }
//    }
}

- (void)locationManager:(CLLocationManager * )manager didUpdateLocations:(NSArray *)locations{
    CLLocation* location = [locations lastObject];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%g",location.altitude] forKey:@"altitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%g",location.coordinate.longitude] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%g",location.coordinate.latitude] forKey:@"latitude"];
    [manager stopUpdatingLocation];
    if (self.block) {
        self.block(@"cccccccc");
    }
}

- (void)LWCoreLocationManagerStartLocal:(UIViewController *)vc result:(LWRusultBlock)message{
    
    
    self.block = message;
    if([CLLocationManager locationServicesEnabled]){
        
        //1、判读是否支持定位
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            //开启授权
           [self.locationManager requestWhenInUseAuthorization];
        }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            //权限拒绝
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
            appName = [NSString stringWithFormat:@"为了更好的体验,请到设置->隐私->定位服务中开启!【%@APP】定位服务,已便获取附近信息!",appName];
            UIAlertController * alerc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:appName preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self doDeniey];
            }];
            [alerc addAction:action1];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }];
            [alerc addAction:action2];
        }else{
            //开始定位
            [self.locationManager startUpdatingLocation];
        }
    }

}

- (void)LWCoreLocationManagerStopLocal{
    [_locationManager stopUpdatingLocation];
}


@end
