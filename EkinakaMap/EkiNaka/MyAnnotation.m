//
//  MyAnnotation.m
//  EkiNaka
//
//  Created by Shinnosuke Komiya on 2014/07/31.
//  Copyright (c) 2014年 佐野 大河. All rights reserved.
//

#import <YMapKit/YMapKit.h>
#import "MyAnnotation.h"
@implementation MyAnnotation
@synthesize coordinate;
@synthesize annotationTitle;
@synthesize annotationSubtitle;

//初期化処理
- (id)initWithLocationCoordinate:(CLLocationCoordinate2D) coord
                           title:(NSString *)annTitle subtitle:(NSString *)annSubtitle {
    if (self=[super init]) {
        coordinate.latitude = coord.latitude;
        coordinate.longitude = coord.longitude;
        annotationTitle = annTitle;
        annotationSubtitle = annSubtitle;
    }
    return self;
}

//タイトル
- (NSString *)title
{
    return annotationTitle;
}

//サブタイトル
- (NSString *)subtitle
{
    return annotationSubtitle;
}
@end
