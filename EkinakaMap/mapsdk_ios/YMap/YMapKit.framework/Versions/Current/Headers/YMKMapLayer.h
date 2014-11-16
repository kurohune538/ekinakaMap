//
//  YMKMapLayer.h
//  iDriveSample7
//
//  Created by hooe on 11/08/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "YMKTypes.h"
#import "YMKGeometry.h"
#import "YMKIndoorDataSet.h"

@protocol YMKMapLayer <NSObject>
@optional

-(YMKIndoorDataSet*)indoorDataSet;

-(BOOL)existsWithMapType:(YMKMapType)mapType withSpan:(YMKCoordinateSpan)span;
-(BOOL)existsWithMapType:(YMKMapType)mapType withSpan:(YMKCoordinateSpan)span withLevel:(int)level;
-(YMKCoordinateSpan)getMinSpanWithMapType:(YMKMapType)mapType;
-(YMKCoordinateSpan)getMaxSpanWithMapType:(YMKMapType)mapType;
- (void)stop;
@end