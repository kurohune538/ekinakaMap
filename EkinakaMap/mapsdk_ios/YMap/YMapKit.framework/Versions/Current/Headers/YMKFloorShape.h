//	
//  YMLFloorShape
//	
//  Created by hooe on 10/07/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//	
#import <Foundation/Foundation.h>

@interface YMKFloorShape : NSObject
{
    NSString* type;
    int* floorIds;
    int floorIdCount;
    NSArray* floorLevels;
}
@property (nonatomic,retain) NSString* type;
@property (assign)int* floorIds;
@property (nonatomic) int floorIdCount;
@property (nonatomic,retain) NSArray* shapes;

@end