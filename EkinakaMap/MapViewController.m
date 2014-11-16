//
//  MapViewController.m
//  EkiNaka
//
//  Created by 佐野 大河 on 2014/06/04.
//  Copyright (c) 2014年 佐野 大河. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController ()

@end

@implementation MapViewController{
    double nowLatitude;
    double nowLongitude;
    
    //現在地移動ボタン
    UIButton *nowPlaceBtn;
    //地下街表示ボタン
    UIButton *undergroundBtn;
    //アイコンの高さの調整用
    int iconAdjustHeight;
    //地下街の表示
    BOOL chikaOrNot;
    //csvファイルから取得した全出口と緯度経度データ
    NSMutableArray *latLonData;
    
    NSUserDefaults *ud;
    //緯度経度データの数
    int allDataCount;
    //一回目の現在地取得
    BOOL firstLoad;
}

@synthesize station;

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
    
//Admob
    //バナーユニットID
    NSString *MY_BANNER_UNIT_ID = @"ca-app-pub-9654967944736237/7575001305";
    
    // 画面上部に標準サイズのビューを作成する
    // 利用可能な広告サイズの定数値は GADAdSize.h で説明されている
    // 3.インスタンスを生成
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    
    // 広告ユニット ID を指定する
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    [bannerView_ setCenter:CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height-bannerView_.bounds.size.height/2-49)];
    // ユーザーに広告を表示した場所に後で復元する UIViewController を
    // ランタイムに知らせてビュー階層に追加する
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // 一般的なリクエストを行って広告を読み込む
    [bannerView_ loadRequest:[GADRequest request]];
//ここまで

    // Do any additional setup after loading the view.
    //画面サイズの取得
    CGFloat width  = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    // CSVファイルからセクションデータを取得する
    NSString *csvFile = [[NSBundle mainBundle] pathForResource:@"ExitLatLonData" ofType:@"csv"];
    NSData *csvData = [NSData dataWithContentsOfFile:csvFile];
    NSString *csv = [[NSString alloc] initWithData:csvData encoding:NSUTF8StringEncoding];
    NSScanner *scanner = [NSScanner scannerWithString:csv];
    
    // 改行文字の集合を取得
    NSCharacterSet *chSet = [NSCharacterSet newlineCharacterSet];
    // 一行ずつの読み込み
    NSString *line;
    latLonData = [[NSMutableArray alloc] init];
    
    
    
    
    //タイトル行読み飛ばしフラグ。読み込む場合はtrueにする
    bool titleUse = false;
    while (![scanner isAtEnd]) {
        // 一行読み込み
        [scanner scanUpToCharactersFromSet:chSet intoString:&line];
        if(titleUse){
            // カンマ「,」で区切る
            NSArray *array = [line componentsSeparatedByString:@","];
            // 配列に挿入する
            [latLonData addObject:array];
        }
        //　改行文字をスキップ
        [scanner scanCharactersFromSet:chSet intoString:NULL];
        titleUse = true;
    }
    //データの数を取得
    allDataCount = [latLonData count];

    NSLog(@"%d",allDataCount);
    
    
    
    
    // コンパスが使用可能かどうかチェックする
    if ([CLLocationManager headingAvailable]) {
        // CLLocationManagerを作る
//        locationManager = [[CLLocationManager alloc] init];
        locationManager = [CLLocationManager new];
        //デリゲートを設定
        locationManager.delegate = self;
        
        // iOS8未満は、このメソッドは無いので
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            
            // GPSを取得する旨の認証をリクエストする
            // 「このアプリ使っていない時も取得するけどいいでしょ？」
            [locationManager requestAlwaysAuthorization];
        }
        //デリゲートを設定
        locationManager.delegate = self;
        
        // デバイスの度の向きを北とするか（デフォルトは画面上部）
        locationManager.headingOrientation = CLDeviceOrientationPortrait;
        
        // コンパスの使用を開始する
        [locationManager startUpdatingHeading];
        
        // 測量の制度を「出来る限り正確」に設定
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        
        // 現在位置を取得する
        [locationManager startUpdatingLocation];
        
        
    }
    
    
    //YMKMapViewのインスタンスを作成
    ymap = [[YMKMapView alloc] initWithFrame:CGRectMake(0, 0, width, height-99) appid:@"dj0zaiZpPU1jOXVVam9VemJjYyZzPWNvbnN1bWVyc2VjcmV0Jng9Yzc-"];
    
    //地図のタイプを指定 標準の地図を指定
//    ymap.mapType=YMKMapTypeStyle; //スタンダード
    ymap.mapType=YMKMapTypeChika; //地下街を表示
    NSMutableArray* ary=[NSMutableArray array];
    [ary addObject:[NSString stringWithFormat:@"on:underground"]];
    [ymap setMapType:YMKMapTypeStyle MapStyle:@"standard" MapStyleParam:ary];

    
    
    
    //YMKMapViewを追加
    [self.view addSubview:ymap];
    
    
    //YMKMapViewDelegateを登録
    ymap.delegate = self;
    
    //地図の位置と縮尺を設定
//    CLLocationCoordinate2D center;
//    center.latitude = 35.6657214;
//    center.longitude = 139.7310058;
//    ymap.region = YMKCoordinateRegionMake(center, YMKCoordinateSpanMake(0.002, 0.002));

    
        //現在地の表示
    ymap.showsUserLocation = YES;
    
    //ヘッダー画像
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    headView.image = [UIImage imageNamed:@"640-98.png"];
    [self.view addSubview:headView];
    
    
    
    //現在地取得ボタン
    nowPlaceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *nowPlaceImg = [UIImage imageNamed:@"nowLocation.png"];
    [nowPlaceBtn setBackgroundImage:nowPlaceImg forState:UIControlStateNormal];
    nowPlaceBtn.frame = CGRectMake(280, ymap.frame.size.height - 50, 68/2, 68/2);
    [nowPlaceBtn addTarget:self action:@selector(setNowPlace) forControlEvents:UIControlEventTouchUpInside];
    [ymap addSubview:nowPlaceBtn];
    
    firstLoad = true;
    
    //地下街ボタン
    undergroundBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *undergroundImg = [UIImage imageNamed:@"underGround.png"];
    [undergroundBtn setBackgroundImage:undergroundImg forState:UIControlStateNormal];
    undergroundBtn.frame = CGRectMake(280, ymap.frame.size.height - 100, 68/2, 68/2);
    [undergroundBtn addTarget:self action:@selector(changeMapTypeToChika) forControlEvents:UIControlEventTouchUpInside];
    //undergroundBtn.backgroundColor = [UIColor redColor];
    undergroundBtn.alpha = 0.5;
    [ymap addSubview:undergroundBtn];

    
    
//    //以下Nend
//    // (2) NADViewの作成
//    self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, height-99, 320, 50)];
//    // (3) ログ出力の指定
//    [self.nadView setIsOutputLog:NO];
//    // (4) set apiKey, spotId.
//    [self.nadView setNendID:@"dce3ec71ff77b036a121bce6e22e609f35d05399"
//                     spotID:@"202991"];
//    [self.nadView setDelegate:self]; //(5)
//    [self.nadView load]; //(6)
//    [self.view addSubview:self.nadView]; // 最初から表示する場合
//    //ここまで
    
    //地下街の表示
    chikaOrNot = NO;
    
    //ピンを生成するメソッドへ
    [self setAnnotation];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [self.nadView pause];
//}

- (void)viewWillAppear:(BOOL)animated {
    //[self.nadView resume];
    
    NSLog(@"%@!!!!!!!",station);
    
    ud = [NSUserDefaults standardUserDefaults];
    BOOL b = [ud boolForKey:@"KEY_C"];
    
    [ud synchronize];
    //スケールバーの表示
    if (b ==YES) {
        ymap.scalebarVisible = YES;
    }else{
        ymap.scalebarVisible = NO;
    }
    
    
    //駅選択画面から読み込まれた場合、その駅の地点へ飛ぶ
    if (station) {
        [self loadStationLocation:station];
    }else {
    }
}

//駅の位置へ移動
- (void)loadStationLocation:(NSString *)stationName{
    NSLog(@"%@へ移動",stationName);
    CLLocationCoordinate2D center;
    if ([stationName isEqualToString:@"新宿駅"]) {
        NSLog(@"新宿！");
        center.latitude =  35.690921;
        center.longitude = 139.700258;
    }else if ([stationName isEqualToString:@"東京駅"]){
        NSLog(@"東京！");
        center.latitude =  35.681382;
        center.longitude = 139.766084;
    }else if ([stationName isEqualToString:@"横浜駅"]){
        NSLog(@"横浜！");
        center.latitude =  35.466188;
        center.longitude = 139.622715;
    }else if ([stationName isEqualToString:@"渋谷駅"]){
        NSLog(@"渋谷！");
        center.latitude =  35.658517;
        center.longitude = 139.701334;
    }
    ymap.region = YMKCoordinateRegionMake(center, YMKCoordinateSpanMake(0.005, 0.005));
}


//デバイスの緯度と経度が変化すると呼ばれるメソッド
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    nowLatitude = newLocation.coordinate.latitude;
    nowLongitude = newLocation.coordinate.longitude;
    
    if (firstLoad == true && !station) {
        [self setNowPlace];
        firstLoad = false;
    }
}

//現在地に移動
-(void)setNowPlace{
    //地図の位置と縮尺を再設
    CLLocationCoordinate2D center;
    center.latitude = nowLatitude;
    center.longitude = nowLongitude;
    ymap.region = YMKCoordinateRegionMake(center, YMKCoordinateSpanMake(0.002, 0.002));
}

-(void)setAnnotation{
    
    for (int i=0; i< allDataCount; i++) {
        //データからそれぞれの緯度経度を取得し、nsstring→floatに変換
        float markerLat = [[[latLonData objectAtIndex:i] objectAtIndex:1] floatValue];
        float markerLon = [[[latLonData objectAtIndex:i] objectAtIndex:2] floatValue];
        
        //アイコンの緯度経度を設定
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = markerLat;
        coordinate.longitude = markerLon;
        //MyAnnotationの初期化
        MyAnnotation* myAnnotation = [[MyAnnotation alloc] initWithLocationCoordinate:coordinate title:[[NSString alloc] initWithFormat:@"%@",[[latLonData objectAtIndex:i] objectAtIndex:0]] subtitle:[[NSString alloc] initWithFormat:@""]];
        //AnnotationをYMKMapViewに追加
        [ymap addAnnotation:myAnnotation];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//コンパスがうまく動かない時にキャリブレーションを表示
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    NSLog(@"キャリブレーション");
    return YES;
}

//地下街マップへの切り替え
- (void)changeMapTypeToChika{
    if (chikaOrNot == NO) {
        ymap.mapType = YMKMapTypeChika;
        chikaOrNot = YES;
        undergroundBtn.alpha = 1.0;
    }else{
        ymap.mapType = YMKMapTypeStyle;
        chikaOrNot = NO;
        undergroundBtn.alpha = 0.5;
    }
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