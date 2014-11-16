//
//  YMKPolygonView.h
//
//  Copyright (C) 2013 Yahoo Japan Corporation. All Rights Reserved.
//
#import <UIKit/UIKit.h>
#import "YMKOverlayPathView.h"
#import "YMKPolygon.h"

@interface YMKPolygonView : YMKOverlayPathView {
}

- (id)initWithPolygon:(YMKPolygon *)polygon;

@end
