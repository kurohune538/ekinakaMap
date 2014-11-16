//
//  MapViewController.h
//  EkiNaka
//
//  Created by 佐野 大河 on 2014/06/04.
//  Copyright (c) 2014年 佐野 大河. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <YMapKit/YMapKit.h>
#import "NADView.h"
#import "MyAnnotation.h"
#import "GADBannerView.h"

@interface MapViewController : UIViewController<CLLocationManagerDelegate,YMKMapViewDelegate> {
    CLLocationManager *locationManager;
    YMKMapView *ymap; //YMKMapViewインスタンス用ポインタ
    // インスタンス変数として 1 つ宣言する
    GADBannerView *bannerView_;
    
    NSString *station;
}
@property (nonatomic, retain) NADView * nadView;
@property (nonatomic,copy) NSString *station;

@end
