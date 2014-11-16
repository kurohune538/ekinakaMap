//
//  SettingNavigationController.m
//  EkiNaka
//
//  Created by 佐野 大河 on 2014/06/04.
//  Copyright (c) 2014年 佐野 大河. All rights reserved.
//

#import "SettingNavigationController.h"

@interface SettingNavigationController ()

@end

@implementation SettingNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //ナビゲーションバーの背景画像を指定
    UIImage *navigationBackgroundImage = [UIImage imageNamed:@"640-98.png"];
    [[UINavigationBar appearance] setBackgroundImage:navigationBackgroundImage forBarMetrics:UIBarMetricsDefault];
    SettingTableViewController *settingView = [[SettingTableViewController alloc] init];
    [self initWithRootViewController:settingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
