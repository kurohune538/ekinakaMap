//
//  SelectTableViewController.h
//  EkiNaka
//
//  Created by 佐野 大河 on 2014/06/04.
//  Copyright (c) 2014年 佐野 大河. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "ARViewController.h"
#import "MapViewController.h"
#import "SettingTableViewController.h"
#import "SettingNavigationController.h"
#import "NADView.h"
#import "GADBannerView.h"

@interface SelectTableViewController : UITableViewController{
    // インスタンス変数として 1 つ宣言する
    GADBannerView *bannerView_;
}
@property (nonatomic, retain) NADView * nadView;

@end
