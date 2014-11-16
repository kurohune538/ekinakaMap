//
//  YMKLabelTouchDelegate.h
//
//  Copyright (C) 2013 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKLabelInfo.h"
//アイテム検索
@protocol YMKLabelTouchDelegate <NSObject>

@optional
//注記タッチ
-(void)onLabelTouchWithLabelInfo:(YMKLabelInfo*)labelInfo;

@end