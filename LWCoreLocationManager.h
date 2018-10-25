//
//  MyCoreLocation.h
//  bameng
//
//  Created by lhb on 16/11/11.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LWCoreLocationManagerDelegate <NSObject>

@end

typedef void(^LWRusultBlock)(NSString *);

@interface LWCoreLocationManager : NSObject


+(instancetype)LWCoreLocationManagerShare;


- (void)LWCoreLocationManagerStartLocal:(UIViewController *)vc result:(LWRusultBlock)message;


- (void)LWCoreLocationManagerStopLocal;


@property(nonatomic,weak) id <LWCoreLocationManagerDelegate> delegate;


@end
