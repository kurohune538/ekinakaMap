//
//  AppDelegate.h
//  EkiNaka
//
//  Created by 佐野 大河 on 2014/06/04.
//  Copyright (c) 2014年 佐野 大河. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectTableViewController.h"
#import "ARViewController.h"
#import "MapViewController.h"
#import "SettingTableViewController.h"

#import "SettingNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UITabBarController *tabBarController;
    UINavigationController *navigationController;
    UIWindow *window;
}

@property (strong, nonatomic) UIWindow *window;

@end
