//
//  ARViewController.h
//  EkiNaka
//
//  Created by 佐野 大河 on 2014/06/04.
//  Copyright (c) 2014年 佐野 大河. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <YMapKit/YMapKit.h>
#import "MyAnnotation.h"
#import <Foundation/Foundation.h>

//　加速度センサから値を取得する間隔
#define kAccelerometerFrequency 20.0f
//　加速度センサの感度を制限する
#define kFilteringFactor 0.7f

@interface ARViewController : UIViewController<CLLocationManagerDelegate,YMKMapViewDelegate> {
    CLLocationManager *locationManager;
    NSString *station;
}

- (void)loadStationLocation:(NSString *)stationName;
@property (nonatomic,copy) NSString *station;

@end
