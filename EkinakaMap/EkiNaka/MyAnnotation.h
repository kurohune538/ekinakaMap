//
//  MyAnnotation.h
//  EkiNaka
//
//  Created by Shinnosuke Komiya on 2014/07/31.
//  Copyright (c) 2014年 佐野 大河. All rights reserved.
//

#import <YMapKit/YMapKit.h>
#import <Foundation/Foundation.h>

@interface MyAnnotation : NSObject <YMKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *annotationTitle;
    NSString *annotationSubtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *annotationTitle;
@property (nonatomic, retain) NSString *annotationSubtitle;

- (id)initWithLocationCoordinate:(CLLocationCoordinate2D) coord
                           title:(NSString *)annTitle subtitle:(NSString *)annSubtitle;
- (NSString *)title;
- (NSString *)subtitle;
@end
