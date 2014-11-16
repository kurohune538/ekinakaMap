//	
//  YMLFloorConnection
//	
//  Created by hooe on 10/07/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//	
#import <Foundation/Foundation.h>

@interface YMKFloorConnection : NSObject
{
    int floorId;
    int connectionIndoorId;
    int connectionFloorId;
}
@property (nonatomic) int floorId;
@property (nonatomic) int connectionIndoorId;
@property (nonatomic) int connectionFloorId;


@end