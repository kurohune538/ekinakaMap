//
//  SettingTableViewController.m
//  EkiNaka
//
//  Created by 佐野 大河 on 2014/06/04.
//  Copyright (c) 2014年 佐野 大河. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController{
    NSArray *sectionList;
    NSDictionary *dataSource;
    NSUserDefaults *ud;
    NSMutableDictionary *defaults;
    UISlider *sl;
    NSString *sliderValueString;
    UILabel *sliderValueLabel;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//Admob
    //バナーユニットID
    NSString *MY_BANNER_UNIT_ID = @"ca-app-pub-9654967944736237/7575001305";
    
    // 画面上部に標準サイズのビューを作成する
    // 利用可能な広告サイズの定数値は GADAdSize.h で説明されている
    // 3.インスタンスを生成
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    
    // 広告ユニット ID を指定する
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    [bannerView_ setCenter:CGPointMake(self.view.bounds.size.width/2,150)];
    // ユーザーに広告を表示した場所に後で復元する UIViewController を
    // ランタイムに知らせてビュー階層に追加する
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // 一般的なリクエストを行って広告を読み込む
    [bannerView_ loadRequest:[GADRequest request]];
//ここまで
    
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"設定";
    
        
    //ナビゲーションバーのボタン
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [button addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"back_button_4.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = item;
    
    
//    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
//                            initWithImage:[[UIImage imageNamed:@"back_button_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                            style:UIBarButtonSystemItemCancel
//                            target:self action:@selector(dismissView)];
//    self.navigationItem.leftBarButtonItem = btn;
    
    //セクション名を設定
    sectionList = [[NSArray alloc] initWithObjects:@"セクション1",@"セクション2", nil];
    NSArray *section1 = [[NSArray alloc] initWithObjects:@"縮尺の表示",@"表示範囲", nil];
    NSArray *section2 = [[NSArray alloc] initWithObjects:nil];
    
    // セルの項目をまとめる
    NSArray *datas = [NSArray arrayWithObjects:section1, section2, nil];
    dataSource = [[NSDictionary alloc] initWithObjects:datas forKeys:sectionList];
    
    //ユーザーでフォルトのインスタンス作成
    ud = [NSUserDefaults standardUserDefaults];
    defaults = [NSMutableDictionary dictionary];
    //デフォルト値を設定
    //[defaults setObject:@"0" forKey:@"KEY_A"]; //Yahoo or Google
    [defaults setObject:@"" forKey:@"KEY_B"]; //拡大縮小
    [defaults setObject:@"YES" forKey:@"KEY_C"];
    [defaults setObject:@"250" forKey:@"KEY_D"];//表示範囲
    [ud registerDefaults:defaults];
    // 値をすぐに反映させる
    [ud synchronize];
//aaaa
    
//    //以下Nendあああ
//    // (2) NADViewの作成
//    self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 130, 320, 50)];
//    // (3) ログ出力の指定
//    [self.nadView setIsOutputLog:NO];
//    // (4) set apiKey, spotId.
//    [self.nadView setNendID:@"dce3ec71ff77b036a121bce6e22e609f35d05399"
//                     spotID:@"202991"];
//    [self.nadView setDelegate:self]; //(5)
//    [self.nadView load]; //(6)
//    [self.view addSubview:self.nadView]; // 最初から表示する場合
//    //ここまで
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [self.nadView pause];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [self.nadView resume];
//}


// モーダルビューを消す
- (void)dismissView {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//セクションの数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionList count];
}

//セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows;
    NSString *sectionName = [sectionList objectAtIndex:section];
    rows = [[dataSource objectForKey:sectionName] count];
    return rows;
}

//セルの中身
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セクション名を取得する
    NSString *sectionName = [sectionList objectAtIndex:indexPath.section];
    
    // セクション名をキーにしてそのセクションの項目をすべて取得
    NSArray *items = [dataSource objectForKey:sectionName];
    
    //セルタップ時のハイライトをなしに
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    // セルの中身を設定
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        // セグメントのアイテム
//        NSArray *items = [NSArray arrayWithObjects:@"Yahoo", @"Google", nil];
//        // セグメント
//        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:items];
//        segment.segmentedControlStyle = UISegmentedControlStylePlain;
//        int num = [ud integerForKey:@"KEY_A"];
//        segment.selectedSegmentIndex = num;
//        [segment addTarget:self
//                    action:@selector(segment_ValueChanged:)
//          forControlEvents:UIControlEventValueChanged];
//        // accessoryViewに代入するときれいに動作する
//        cell.accessoryView = segment;
//        //セルタップ時のハイライトをなしに
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    //拡大縮小のON OFF
//    else if (indexPath.section == 0 && indexPath.row == 1) {
//        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectZero];
//        // UISwitchはUIContolを継承しているので、タップされた際の動作を簡単に指定できる
//        [sw addTarget:self action:@selector(tapSwich1:) forControlEvents:UIControlEventTouchUpInside];
//        BOOL OnOff = [ud boolForKey:@"KEY_B"];
//        sw.on = OnOff;
//        // accessoryViewに代入するときれいに動作する
//        cell.accessoryView = sw;
//        //セルタップ時のハイライトをなしに
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    //縮尺のON OFF
    if (indexPath.section == 0 && indexPath.row == 0) {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectZero];
        // UISwitchはUIContolを継承しているので、タップされた際の動作を簡単に指定できる
        [sw addTarget:self action:@selector(tapSwich2:) forControlEvents:UIControlEventTouchUpInside];
        BOOL OnOff = [ud boolForKey:@"KEY_C"];
        sw.on = OnOff;
        // accessoryViewに代入するときれいに動作する
        cell.accessoryView = sw;
        //セルタップ時のハイライトをなしに
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //表示範囲
    if (indexPath.section == 0 && indexPath.row == 1) {
        //UISliderの初期化
        sl = [[UISlider alloc] initWithFrame:CGRectMake(100, 7, 150, 30)];
        // 最小値を設定
        sl.minimumValue = 50;
         // 最大値を設定
        sl.maximumValue = 500;
        //初期値を設定
        NSLog(@"%d",[ud integerForKey:@"KEY_D"]);
        int firstValue = [ud integerForKey:@"KEY_D"];
        sl.value = firstValue;
        
        [sl addTarget:self action:@selector(sliderEdited:)
     forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:sl];
        
        //スライダーの数値を表示
        //一度NSNumberにすることで小数点を切り捨て
        NSNumber* number = [[NSNumber alloc] initWithFloat:sl.value];
        sliderValueString = [NSString stringWithFormat:@"%@",number];
        sliderValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(255,7,60,30)];
        sliderValueLabel.text = sliderValueString;
        [cell.contentView addSubview:sliderValueLabel];
        
        //mを挿入
        UILabel *meterLabel;
        meterLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 7, 20, 30)];
        meterLabel.text = @"m";
        [cell.contentView addSubview:meterLabel];
        
    }
    
    //セルのテキストの設定
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    return cell;
}

//ヘッダーの高さ
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 38.0;
    }
    else {
        return 0;
    }
    
}

//フッターの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 70.0;
    }
    else {
        return 0;
    }
}

//フッター
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 100)];
        footer.textAlignment = UITextAlignmentCenter;
        footer.text = @"駅ナカMAP ver1.0";
        footer.center = CGPointMake(self.view.bounds.size.width/2, 40);
        footer.textColor = [UIColor grayColor];
        [self.view addSubview:footer];
        return footer;
    }
    else{
        return nil;
    }
}

//セグメントボタンが選択されたとき呼び出される
- (void)segment_ValueChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    switch (segment.selectedSegmentIndex) {
        case 0:
            NSLog(@"Google!");
            [ud setInteger:0 forKey:@"KEY_A"];
            // 値をすぐに反映させる
            [ud synchronize];
            break;
            
        case 1:
            NSLog(@"Yahoo!");
            [ud setInteger:1 forKey:@"KEY_A"];
            // 値をすぐに反映させる
            [ud synchronize];
            break;
            
        default:
            break;
    }
}

// 「拡大縮小ボタン」のUISwitchがタップされた際に呼び出される
-(void)tapSwich1:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    switch (sw.on) {
        case YES:
            NSLog(@"ON!");
            [ud setBool:YES forKey:@"KEY_B"];
            // 値をすぐに反映させる
            [ud synchronize];
            break;
            
        default:
            NSLog(@"OFF!");
            [ud setBool:NO forKey:@"KEY_B"];
            // 値をすぐに反映させる
            [ud synchronize];
            break;
    }
}

// 「スケールバー」のUISwitchがタップされた際に呼び出される
-(void)tapSwich2:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    switch (sw.on) {
        case YES:
            NSLog(@"ON!");
            [ud setBool:YES forKey:@"KEY_C"];
            // 値をすぐに反映させる
            [ud synchronize];
            break;
            
        default:
            NSLog(@"OFF!");
            [ud setBool:NO forKey:@"KEY_C"];
            // 値をすぐに反映させる
            [ud synchronize];
            break;
    }
}
//UISliderが編集されたら呼び出される
-(void)sliderEdited:(UISlider*)slider{
    NSNumber* number = [[NSNumber alloc] initWithFloat:slider.value];
    sliderValueString = [NSString stringWithFormat:@"%@",number];
    sliderValueLabel.text = sliderValueString;
    [ud setObject:number forKey:@"KEY_D"];
    [ud synchronize];
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
