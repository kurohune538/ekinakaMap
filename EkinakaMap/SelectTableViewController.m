//
//  SelectTableViewController.m
//  EkiNaka
//
//  Created by 佐野 大河 on 2014/06/04.
//  Copyright (c) 2014年 佐野 大河. All rights reserved.
//

#import "SelectTableViewController.h"

@interface SelectTableViewController ()

@end

@implementation SelectTableViewController{
    NSArray *stations;
    CGFloat width;
    CGFloat height;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//Admob
    //バナーユニットID
    NSString *MY_BANNER_UNIT_ID = @"ca-app-pub-9654967944736237/7575001305";
    
    // 画面上部に標準サイズのビューを作成する
    // 利用可能な広告サイズの定数値は GADAdSize.h で説明されている
    // 3.インスタンスを生成
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];

    // 広告ユニット ID を指定する
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    [bannerView_ setCenter:CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height-bannerView_.bounds.size.height/2-29)];
    // ユーザーに広告を表示した場所に後で復元する UIViewController を
    // ランタイムに知らせてビュー階層に追加する
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // 一般的なリクエストを行って広告を読み込む
    [bannerView_ loadRequest:[GADRequest request]];
//ここまで
    //画面サイズの取得
    width  = self.view.frame.size.width;
    height = self.view.frame.size.height;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    stations = [[NSArray alloc] initWithObjects:@"新宿駅",@"横浜駅",@"東京駅",@"渋谷駅", nil];
    
//    //以下Nend
//    // (2) NADViewの作成
//    self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0,0, 320, 50)];
//    // (3) ログ出力の指定
//    [self.nadView setIsOutputLog:NO];
//    // (4) set apiKey, spotId.
//    [self.nadView setNendID:@"dce3ec71ff77b036a121bce6e22e609f35d05399"
//                     spotID:@"202991"];
//    [self.nadView setDelegate:self]; //(5)
//    [self.nadView load]; //(6)
//    [adView addSubview:self.nadView]; // 最初から表示する場合
//    [adView bringSubviewToFront:self.nadView];
//    
//    //ここまで
}

//-(void)nadViewDidFailToReceiveAd:(NADView *)adView
//{
//    NSLog(@"delegate nadViewDidFailToLoad:");
//    // エラーごとに分岐する
//    NSError* error = adView.error;
//    NSString* domain = error.domain;
//    int errorCode = error.code;
//    // isOutputLog = NOでも、domain を利用してアプリ側で任意出力が可能
//    NSLog(@"log %d", adView.isOutputLog);
//    NSLog(@"%@",[NSString stringWithFormat: @"code=%d, message=%@",
//                 errorCode, domain]);
//    switch (errorCode) {
//        case NADVIEW_AD_SIZE_TOO_LARGE:
//            // 広告サイズがディスプレイサイズよりも大きい
//            break;
//        case NADVIEW_INVALID_RESPONSE_TYPE:
//            // 不明な広告ビュータイプ
//            break;
//        case NADVIEW_FAILED_AD_REQUEST:
//            // 広告取得失敗
//            break;
//        case NADVIEW_FAILED_AD_DOWNLOAD:
//            // 広告画像の取得失敗
//            break;
//        case NADVIEW_AD_SIZE_DIFFERENCES:
//            // リクエストしたサイズと取得したサイズが異なる
//            break;
//        default:
//            break;
//    }
//}

//- (void)viewWillDisappear:(BOOL)animated {
//    [self.nadView pause];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [self.nadView resume];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [stations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セルにテキストを設定
    cell.textLabel.text = [stations objectAtIndex:indexPath.row];
    // セルの背景指定
    UIView *cellBackgroundView = [[UIView alloc] init];
    cellBackgroundView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = cellBackgroundView;

    
    return cell;
}

//セルが選択されたとき
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"「%@」が選択されました", [stations objectAtIndex:indexPath.row]);
    
    MapViewController *mapView = self.tabBarController.childViewControllers[1];
    mapView.station = [stations objectAtIndex:indexPath.row];
//    NSString *stationName = [stations objectAtIndex:indexPath.row];
//    [ARView loadStationLocation:stationName];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //トランジションのタイプ
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromRight;
    
    // tabBarController のアニメーションを変更する
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
    //画面遷移
    self.tabBarController.selectedViewController = mapView;
}

//ヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 68.0;
}

//ヘッダー
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage *image = [UIImage imageNamed:@"640-98.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 320, 70 + 18);
    
    //「駅選択」ラベル
    UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,20)];
    headerLbl.center = CGPointMake(imageView.frame.size.width/2, imageView.frame.size.height/2);
    headerLbl.text = @"駅選択";
    headerLbl.font = [UIFont boldSystemFontOfSize:18];
    headerLbl.textColor = [UIColor whiteColor];
    headerLbl.textAlignment = UITextAlignmentCenter;
    [imageView addSubview:headerLbl];

    return imageView;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section
{
    
    return @"";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = @"駅選択";
        tableViewHeaderFooterView.textLabel.backgroundColor = [UIColor whiteColor];
    }
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
