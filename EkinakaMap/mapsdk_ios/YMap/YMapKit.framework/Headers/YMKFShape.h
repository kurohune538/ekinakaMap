//	
//  YMKFShape
//	
//  Created by hooe on 10/07/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//	
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>	

@interface YMKFShape : NSObject
{
    CLLocationCoordinate2D* coordinates;
    int coordsCount;
}
@property (assign) CLLocationCoordinate2D *coordinates;
@property (nonatomic) int coordsCount;

@end