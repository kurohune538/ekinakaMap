//
//  AppDelegate.m
//  EkiNaka
//
//  Created by 佐野 大河 on 2014/06/04.
//  Copyright (c) 2014年 佐野 大河. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate{
    UIViewController *selectView;
    UIViewController *ARView;
    UIViewController *mapView;
    UINavigationController *settingNavi;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application{
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    //それぞれのビューのインスタンスを作成
    ARView = [[ARViewController alloc] init];
    mapView = [[MapViewController alloc] init];
    selectView = [[SelectTableViewController alloc] init];
    settingNavi = [[SettingNavigationController alloc] init]; // ← NavigationController
    
    NSArray *tabs = [[NSArray alloc] initWithObjects:ARView,mapView,selectView,settingNavi, nil];
    
    
    //基点となるコントローラーを作成
    tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:tabs animated:NO];
    
    
    //バーボタンのアイコンを作成(選択前 & 選択後)
    //    [selectView.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_icon1-o.png"]
    //                  withFinishedUnselectedImage:[UIImage imageNamed:@"tab_icon1.png"]];
    //    [ARView.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_icon1-o.png"]
    //                  withFinishedUnselectedImage:[UIImage imageNamed:@"tab_icon1.png"]];
    //    [mapView.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_icon1-o.png"]
    //                  withFinishedUnselectedImage:[UIImage imageNamed:@"tab_icon1.png"]];
    //    [settingNavi.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_icon1-o.png"]
    //                  withFinishedUnselectedImage:[UIImage imageNamed:@"tab_icon1.png"]];
    
    UIImage *icon1 = [UIImage imageNamed:@"menuicon30-1.png"];
    UIImage *icon2 = [UIImage imageNamed:@"menuicon30-2.png"];
    UIImage *icon3 = [UIImage imageNamed:@"menuicon30-3.png"];
    UIImage *icon4 = [UIImage imageNamed:@"menuicon30-4.png"];
//    UIImage *icon1_resize;
//    UIImage *icon2_resize;
//    UIImage *icon3_resize;
//    UIImage *icon4_resize;
//    
//    UIGraphicsBeginImageContext(CGSizeMake(30, 30));
//    [icon1 drawInRect:CGRectMake(0, 0, 30, 30)];
//    icon1_resize = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    selectView.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:icon1 tag:0];
    ARView.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:icon2 tag:0];
    mapView.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:icon3 tag:0];
    settingNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:icon4 tag:0];
    
    //タイトルの設定
    [ARView setTitle:@"AR"];
    [mapView setTitle:@"Map"];
    [selectView setTitle:@"Station"];
    [settingNavi setTitle:@"Setting"];
    
    //タイトルの色(通常時)
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //(選択中)
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateSelected];
    
    //選択中のアイコンの色
//    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:1.00 green:0.88 blue:0.00 alpha:1.0]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:1.00 green:1.00 blue:0.40 alpha:1.0]];
    
    
    
    //タブバーの背景画像を設定
    UIImage *bgImg = [UIImage imageNamed:@"320-46.png"];
    [UITabBar appearance].backgroundImage = bgImg;
    [UITabBar appearance].backgroundColor = [UIColor orangeColor];
    
    //バーの背景色を設定
//    [UITabBar appearance].barTintColor = [UIColor blueColor];
    
    //モーダルのためにデリゲートを設定
    tabBarController.delegate = self;
    
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
}

//コンパスがうまく動かない時にキャリブレーションを表示
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    NSLog(@"キャリブレーション");
    return YES;
}

//タブが選択されたときに呼ばれる
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == settingNavi) {
        NSLog(@"モーダル！");
        SettingNavigationController *setView = [[SettingNavigationController alloc] init];

        [settingNavi presentModalViewController:setView animated:YES];
        
        return NO;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
