//
//  ARViewController.m
//  EkiNaka
//
//  Created by 佐野 大河 on 2014/06/04.
//  Copyright (c) 2014年 佐野 大河. All rights reserved.
//
//
#import "ARViewController.h"

@interface ARViewController ()

@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) UIView *previewView;
@end

@implementation ARViewController{
    //緯度経度のcsv読み込み用インスタンス
    NSString *csvFile;
    NSData *csvData;
    NSString *csv;
    NSScanner *scanner;
    //各軸座標の値
    UIAccelerationValue accelX, accelY, accelZ;
    CMMotionManager *motionManager;
    
    CLLocationDirection heading;
    UIImageView *markerView[500];

    UIImage *markerImage;

    UIScreen *sc;
    CGFloat width;
    CGFloat height;
    UILabel *headingLabel;
    UILabel *degreeLabel;
    UILabel *nowLatLabel;
    UILabel *nowLonLabel;
    UILabel *targetAzimuthLabel;
    UILabel *markerDistance[500];
    UILabel *markerName[500];
    //現在地からの距離をソートするための空の配列を生成するためのインスタンス
//    UILabel *markerDistanceData[500];
    NSString *markerDistanceStr[500];
    double markerDisDouble[500];
    
    //地図を隠すボタン
    UIImage *downBtnImg;
    UIImage *upBtnImg;
    UIButton *downBtn;
    UIButton *upBtn;
    YMKMapView *ymap;
    float sizeX;
    float sizeY;
    float markerX;
    float markerY;
    double nowLatitude;
    double nowLongitude;
    float targetDegree;
    
    // 現在地からターゲットまでの地図上での方位角（ラジアン）
	double pointAzimuth;
    //現在向いている方向からターゲットまでの角度（ラジアン）
    double targetAzimuth;
    
    // 現在向いている方向（Heading）からビューポート半分を引いたものがビューポート左端の角度（クリッピングポイント）
	double centerAzimuth;
	double leftAzimuth;
    //ユーザーが決めた表示範囲
    int userLength;

    CLLocationDistance distance;
    //スカイツリーの座標
    #define latSKY 35.710063
    #define lonSKY 139.8107
    
    //画面読み込み時に現在地へ飛ぶかどうか
    BOOL loadNowLocation;

    BOOL isScaleBar;
    UIButton *nowPlaceBtn;
    UIButton *undergroundBtn;
    //アイコンの高さの調整用
    int iconAdjustHeight;
    //地下街の表示
    BOOL chikaOrNot;
    //csvファイルから取得した全出口と緯度経度データ
    NSMutableArray *latLonData;
    //緯度経度データの数
    int allDataCount;
    NSUserDefaults *ud;
}

@synthesize station;

float CalculateAngle(float nLat1, float nLon1, float nLat2, float nLon2)
{
    float longitudinalDifference = nLon2 - nLon1;
    float latitudinalDifference  = nLat2 - nLat1;
    float azimuth = (M_PI * .5f) - atan(latitudinalDifference / longitudinalDifference);
    if (longitudinalDifference > 0)   return( azimuth );
    else if (longitudinalDifference < 0) return( azimuth + M_PI );
    else if (latitudinalDifference < 0)  return( M_PI );
    return( 0.0f );
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    [self getLocationCsv];

    [self prepareScreen];
    
    [self setMarker];
    
    [self setUpYmap];
    
    [self setHeader];
    
    [self prepareBtn];
    
    [self setAnnotation];
   }

//ビューが読み込まれるたびに呼ばれる
- (void)viewWillAppear:(BOOL)animated{

    [self setUp];
    //　加速度センサを開始する
    [self startAccelerometer];
    [self getConpassAndLocation];
    [self setupAVCapture];
    
}

-(void)setUp{
    //アイコンの高さの調整用
    iconAdjustHeight = 2;
    ud = [NSUserDefaults standardUserDefaults];
    isScaleBar = [ud boolForKey:@"KEY_C"];
    [ud synchronize];
    
    if (isScaleBar == YES) {
        ymap.scalebarVisible = YES;
    }else{
        ymap.scalebarVisible = NO;
    }

    //地下街の表示
    chikaOrNot = NO;
}
-(void)getConpassAndLocation{
    // コンパスが使用可能かどうかチェックする
    if ([CLLocationManager headingAvailable]) {
        locationManager = [CLLocationManager new];
        locationManager.delegate = self;
        // iOS8未満は、このメソッドは無いので
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            
            // GPSを取得する旨の認証をリクエストする
            // 「このアプリ使っていない時も取得するけどいいでしょ？」
            [locationManager requestAlwaysAuthorization];
        }
        // デバイスの度の向きを北とするか（デフォルトは画面上部）
        locationManager.headingOrientation = CLDeviceOrientationPortrait;
        // コンパスの使用を開始する
        [locationManager startUpdatingHeading];
        // 測量の制度を「出来る限り正確」に設定
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        
        // 現在位置を取得する
        [locationManager startUpdatingLocation];
        
        userLength = [ud integerForKey:@"KEY_D"];
        NSLog(@"指定範囲:%d",userLength);
        //headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,10,100,30)];
        //degreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,50,100,30)];
        //nowLatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 100, 30)];
        //nowLonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 100, 30)];
        //targetAzimuthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 100, 30)];
    }
    //駅選択画面から読み込まれた場合、その駅の地点へ飛ぶ
    if (station) {
        loadNowLocation = false;
        [self loadStationLocation:station];
    }else {
        //タブバーから読み込まれた場合、現在地へ飛ぶ
        loadNowLocation = true;
    }

}

-(void)getLocationCsv{
    csvFile = [[NSBundle mainBundle] pathForResource:@"ExitLatLonData" ofType:@"csv"];
    csvData = [NSData dataWithContentsOfFile:csvFile];
    csv = [[NSString alloc] initWithData:csvData encoding:NSUTF8StringEncoding];
    scanner = [NSScanner scannerWithString:csv];
    
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
            
            //テスト(全体の緯度経度を移動)
            //            float fLat = [[array objectAtIndex:1] floatValue];
            //            float fLon = [[array objectAtIndex:2] floatValue];
            ////            fLat = fLat - 0.060291; //佐野家と新宿駅の差
            ////            fLon = fLon - 0.315887;
            //            fLat = fLat - 0.029355; //日野キャンと新宿駅の差　35.661523　　139.367619　35.690921　　139.700258
            //            fLon = fLon - 0.332639;
            //            NSString *sLat = [NSString stringWithFormat:@"%f",fLat];
            //            NSString *sLon = [NSString stringWithFormat:@"%f",fLon];
            //            NSString *exitName = [array objectAtIndex:0];
            //            NSArray *testArray = [NSArray arrayWithObjects:exitName,sLat,sLon, nil];
            //            //配列に挿入する
            //            [latLonData addObject:testArray];
            
            // 配列に挿入する
            [latLonData addObject:array];
            
        }
        //　改行文字をスキップ
        [scanner scanCharactersFromSet:chSet intoString:NULL];
        titleUse = true;
    }
    //    NSLog(@"csv:%@",latLonData);

}

-(void)prepareScreen{
    sc = [UIScreen mainScreen];
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;
    //ステータスバー込みのサイズ
    CGRect rect = sc.bounds;
    sizeX = rect.size.width;
    sizeY = rect.size.height;
    
    // プレビュー用のビューを生成
    self.previewView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,height)];
    [self.view addSubview:self.previewView];
}

-(void)setHeader{
    //ヘッダー画像
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    headView.image = [UIImage imageNamed:@"640-98.png"];
    [self.view addSubview:headView];
}

-(void)setMarker{
    //画像を選択
    markerImage = [UIImage imageNamed:@"balloon300-150.png"];
    //データの数を取得
    allDataCount = [latLonData count];
    //全てのマーカーをセット
    for (int i = 0; i < allDataCount; i++) {
        //サイズ調整用
        float adjust = 0.8;
        markerView[i] = [[UIImageView alloc]initWithImage:markerImage];
        //画面の外に配置
        markerView[i].frame = CGRectMake(width, height, 150*adjust, 75*adjust);
        
        markerX = markerImage.size.width;
        markerY = markerImage.size.height;
        //最初は非表示
        markerView[i].hidden = YES;
        
        [self.view addSubview:markerView[i]];
        //距離のラベルを作成
        markerDistance[i] = [[UILabel alloc] initWithFrame:CGRectMake(0,0,75*adjust,15)];
        markerDistance[i].center = CGPointMake(75*adjust, 38);
        markerDistance[i].textAlignment = UITextAlignmentCenter;
        markerDistance[i].font = [UIFont fontWithName:@"AppleGothic" size:12];
        markerDistance[i].adjustsFontSizeToFitWidth = YES;
        [markerView[i] addSubview:markerDistance[i]];
        
        //出口・改札名のラベルを表示
        markerName[i] = [[UILabel alloc] initWithFrame:CGRectMake(0,0,75*adjust,15)];
        markerName[i].center = CGPointMake(75*adjust, 18);
        markerName[i].text = [[latLonData objectAtIndex:i] objectAtIndex:0]; //データの一列目から名前を取得
        markerName[i].textAlignment = UITextAlignmentCenter;
        markerName[i].adjustsFontSizeToFitWidth = YES;
        [markerView[i] addSubview:markerName[i]];
    }

}

-(void)setUpYmap{
    //YMKMapViewのインスタンスを作成
    ymap = [[YMKMapView alloc] initWithFrame:CGRectMake(0, height/2, width, height/2-49) appid:@"dj0zaiZpPWowMElEclpUZU5yNyZzPWNvbnN1bWVyc2VjcmV0Jng9NGY-" ];
    
    //地図のタイプを指定 標準の地図を指定
    //    ymap.mapType=YMKMapTypeStyle; //スタンダード
    //    ymap.mapType=YMKMapTypeHybrid; //地下街を表示
    
    NSMutableArray* ary=[NSMutableArray array];
    [ary addObject:[NSString stringWithFormat:@"on:background"]]; //←なぜ機能してくれない！
    [ymap setMapType:YMKMapTypeStyle MapStyle:@"standard" MapStyleParam:ary];
    [self.view addSubview:ymap];
    //YMKMapViewDelegateを登録
    ymap.delegate = self;
    ymap.showsUserLocation = YES;

    
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

-(void)prepareBtn{
    downBtnImg = [UIImage imageNamed:@"pullDownBtn.png"];
    upBtnImg = [UIImage imageNamed:@"pullUpBtn.png"];
    
    downBtn = [[UIButton alloc]
               initWithFrame:CGRectMake(8*width/10, height/2-1, 56, 24)];
    [downBtn setBackgroundImage:downBtnImg forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downbtnTapped:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downBtn];
    
    //現在地取得ボタン
    nowPlaceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *nowPlaceImg = [UIImage imageNamed:@"nowLocation.png"];
    [nowPlaceBtn setBackgroundImage:nowPlaceImg forState:UIControlStateNormal];
    nowPlaceBtn.frame = CGRectMake(280, ymap.frame.size.height - 50, 68/2, 68/2);
    [nowPlaceBtn addTarget:self action:@selector(setNowPlace) forControlEvents:UIControlEventTouchUpInside];
    [ymap addSubview:nowPlaceBtn];
    
    //地下街ボタン
    undergroundBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *undergroundImg = [UIImage imageNamed:@"underGround.png"];
    [undergroundBtn setBackgroundImage:undergroundImg forState:UIControlStateNormal];
    undergroundBtn.frame = CGRectMake(280, ymap.frame.size.height - 90, 68/2, 68/2);
    [undergroundBtn addTarget:self action:@selector(changeMapTypeToChika) forControlEvents:UIControlEventTouchUpInside];
    //undergroundBtn.backgroundColor = [UIColor redColor];
    undergroundBtn.alpha = 0.5;
    [ymap addSubview:undergroundBtn];

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

- (void)setupAVCapture
{
    NSError *error = nil;
    
    // 入力と出力からキャプチャーセッションを作成
    self.session = [[AVCaptureSession alloc] init];
    // 正面に配置されているカメラを取得
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // カメラからの入力を作成し、セッションに追加
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
    [self.session addInput:self.videoInput];
    
    // 画像への出力を作成し、セッションに追加
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.session addOutput:self.stillImageOutput];
    
    // キャプチャーセッションから入力のプレビュー表示を作成
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.frame = self.view.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // レイヤーをViewに設定
    CALayer *previewLayer = self.previewView.layer;
    previewLayer.masksToBounds = YES;
    [previewLayer addSublayer:captureVideoPreviewLayer];
    [self.session startRunning];
}

- (void)takePhoto:(id)sender
{
    // ビデオ入力のAVCaptureConnectionを取得
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection == nil) {
        return;
    }
    // ビデオ入力から画像を非同期で取得。ブロックで定義されている処理が呼び出され、画像データを引数から取得する
    [self.stillImageOutput
     captureStillImageAsynchronouslyFromConnection:videoConnection
     completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         if (imageDataSampleBuffer == NULL) {
             return;
         }
         // 入力された画像データからJPEGフォーマットとしてデータを取得
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         // アルバムに画像を保存
         UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
     }];
}

//　加速度センサを開始するメソッド
-(void)startAccelerometer {
    motionManager = [[CMMotionManager alloc] init];
    //　加速度センサを読み込む間隔を設定
    motionManager.accelerometerUpdateInterval = (1.0f / kAccelerometerFrequency);
    //　加速度に変化が起きたときに実行される処理を指定
    CMAccelerometerHandler acceleHandler = ^(CMAccelerometerData *data, NSError *error) {
        [self didAccelerate:data.acceleration];
    };
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:acceleHandler];
}

//　加速度に変化が起こったときに呼ばれるメソッド
- (void)didAccelerate:(CMAcceleration)acceleratio
{
    accelX = (accelX * kFilteringFactor) + (acceleratio.x * (1.0f - kFilteringFactor));
    accelY = (accelY * kFilteringFactor) + (acceleratio.y * (1.0f - kFilteringFactor));
    accelZ = (accelZ * kFilteringFactor) + (acceleratio.z * (1.0f - kFilteringFactor));
    
//    [self drawPicture];
}


//デバイスの緯度と経度が変化すると呼ばれるメソッド
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    nowLatitude = newLocation.coordinate.latitude;
    nowLongitude = newLocation.coordinate.longitude;
    
//    NSLog(@"緯度:%f 経度:%f",nowLatitude,nowLongitude);
    //全てのマーカーとの距離を計算
    for (int i = 0; i < allDataCount; i++) {
        // 経緯緯度からCLLocationを作成
        CLLocation *nowLocation = [[CLLocation alloc] initWithLatitude:nowLatitude longitude:nowLongitude];
        
        //データからそれぞれの緯度経度を取得し、nsstring→floatに変換
        float markerLat = [[[latLonData objectAtIndex:i] objectAtIndex:1] floatValue];
        float markerLon = [[[latLonData objectAtIndex:i] objectAtIndex:2] floatValue];
        
        CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:markerLat longitude:markerLon];
        //　距離を取得
        distance = [nowLocation distanceFromLocation:targetLocation];
        
        //距離を配列に文字列として格納
        markerDistanceStr[i] = [NSString stringWithFormat:@"%f",distance];
        //距離を配列にdoubleとして格納
        markerDisDouble[i] = distance;
        
        //NSLog(@"きょり%d%f",i,markerDisDouble[i]);
        //一定距離以内のマーカーを表示
        if (distance < userLength) {
            markerView[i].hidden = NO;
        }else{
            markerView[i].hidden = YES;
        }
        if (distance>userLength) {
            int km = distance/1000;
            markerDistance[i].text = [NSString stringWithFormat:@"%d.%.0f km",km,distance/100-km*10];
        }else{
            markerDistance[i].text = [NSString stringWithFormat:@"%.0f m",distance];
        }
    }
    //タブバーから読み込まれた場合、一度だけ現在地に移動する
    if (loadNowLocation == true) {
        [self setNowPlace];
        loadNowLocation = false;
    }
}

//現在地に移動
-(void)setNowPlace{
    //地図の位置と縮尺を設定
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

//デバイスの方位が変化すると、デリゲートメソッドであるlocationManager:didUpdateHeading:が呼び出される
- (void)locationManager:(CLLocationManager*)manager didUpdateHeading:(CLHeading*)newHeading
{
    heading = newHeading.trueHeading;
    //全てのマーカーの方位角を求める
    for (int i = 0; i < allDataCount; i++) {
        //データからそれぞれの緯度経度を取得し、nsstring→floatに変換
        float markerLat = [[[latLonData objectAtIndex:i] objectAtIndex:1] floatValue];
        float markerLon = [[[latLonData objectAtIndex:i] objectAtIndex:2] floatValue];
        // 方位角を求める(現在地から目的地までの方位角)
        pointAzimuth = CalculateAngle(nowLatitude, nowLongitude, markerLat, markerLon);
        //ラジアンを度に変換
        targetDegree = pointAzimuth * 180/M_PI;
        // 現在向いている方位から方位角を引き、今向いている方向から対象物までの角度を算出する
        targetAzimuth = newHeading.trueHeading - targetDegree;
        if (targetAzimuth < 0) {
            targetAzimuth = 360 + targetAzimuth;
        }
        
        //下から順番に比較
//        for (int j=i+1; j<allDataCount; j++) {
//            
//            //うえのほうが大きい時は互いに入れ替えます
//            if(markerDisDouble[i]>markerDisDouble[j]){
//                double t=markerDisDouble[i];
//                markerDisDouble[i] = markerDisDouble[j];
//                markerDisDouble[j] = t;
//                
//            }
//        }

        //マーカーの位置を調整
        [self drawPicture:i];
    }
    for (int i=0; i<allDataCount; i++) {
    //NSLog(@"出口%@はきょり%dは%f",markerName[i].text,i,markerDisDouble[i]);
    }

    headingLabel.text = [NSString stringWithFormat:@"%.2f", heading];
    [self.view addSubview:headingLabel];
    
    nowLatLabel.text = [NSString stringWithFormat:@"%.2f", nowLatitude];
    nowLonLabel.text = [NSString stringWithFormat:@"%.2f", nowLongitude];
    [self.view addSubview:degreeLabel];
    [self.view addSubview:nowLatLabel];
    [self.view addSubview:nowLonLabel];
    
    //向いている方角からターゲットまでの方位角
    targetAzimuthLabel.text = [NSString stringWithFormat:@"%.2f", targetAzimuth];
    [self.view addSubview:targetAzimuthLabel];
}


//画像の位置を変える
-(void)drawPicture:(int)markerNumber{
    
    //最後の要素をのぞいて、すべての要素を並べ替える
            //NSLog(@"%@",markerDistanceData);
    //最後の要素をのぞいて、すべての要素を並べ替える
            //NSLog(@"%@",markerDistanceData);

    /*約0~400mの距離のマーカーが画面いっぱいに入る調整*/
        if (targetAzimuth>180 && targetAzimuth<360) {
           
            markerView[markerNumber].center = CGPointMake(sizeX/2.0 - (targetAzimuth-360.0)*10.9,
                                        (sizeY - markerDisDouble[markerNumber]/500 *sizeY +accelZ*sizeY)/iconAdjustHeight
                                                          );
//            if (markerView[markerNumber].center.y>sizeY) {
//                markerView[markerNumber].center = CGPointMake(sizeX/2.0 - (targetAzimuth-360.0)*10.9,
//                                                           sizeY-50);
//            }
        }else if (targetAzimuth>0 && targetAzimuth<180){
            markerView[markerNumber].center = CGPointMake(sizeX/2.0 - targetAzimuth*10.9,
                                        (sizeY - markerDisDouble[markerNumber]/500 *sizeY +accelZ*sizeY)/iconAdjustHeight
                                                          );
//            if (markerView[markerNumber].center.y>sizeY) {
//                markerView[markerNumber].center = CGPointMake(sizeX/2.0 - (targetAzimuth-360.0)*10.9,
//                                                              sizeY-50);
//            }
        
        }
        //距離ラベルの位置
//        if (targetAzimuth>180 && targetAzimuth<360) {
//            markerDistance[0].center = CGPointMake(sizeX/2.0 - (targetAzimuth-360.0)*10.9,
//                                            (sizeY/2 + accelZ*sizeY) / iconAdjustHeight);
//        }else if (targetAzimuth>0 && targetAzimuth<180){
//            markerDistance[0].center = CGPointMake(sizeX/2.0 - targetAzimuth*10.9,
//                                            (sizeY/2 + accelZ*sizeY) / iconAdjustHeight);
//        }
    
}

// downbtnを押して呼ばれるメソッド
-(void)downbtnTapped:(id)sender{
    
    NSLog(@"sita");
    [downBtn setBackgroundImage:upBtnImg forState:UIControlStateNormal];
    [self.view addSubview:downBtn];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{

                         ymap.transform = CGAffineTransformMakeTranslation(0, sizeY/2);
                         downBtn.transform = CGAffineTransformMakeTranslation(0, sizeY/2-70);
                         
                     } completion:^(BOOL finished) {
                        
                         NSLog(@"アニメーション終了");
                     }];
    
    [downBtn addTarget:self action:@selector(upbtnTapped:)
      forControlEvents:UIControlEventTouchUpInside];
    //アイコンの位置の高さを2分の１にする
    iconAdjustHeight = 1;
}

-(void)upbtnTapped:(id)sender{
    NSLog(@"ue");
    [downBtn setBackgroundImage:downBtnImg forState:UIControlStateNormal];
    [self.view addSubview:downBtn];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         ymap.transform = CGAffineTransformMakeTranslation(0, 0);
                         downBtn.transform = CGAffineTransformMakeTranslation(0, 0);
                         
                     } completion:^(BOOL finished) {
                         
                         NSLog(@"アニメーション終了");
                     }];
    [downBtn addTarget:self action:@selector(downbtnTapped:)
      forControlEvents:UIControlEventTouchUpInside];
    
    //アイコンの位置の高さを戻す
    iconAdjustHeight = 2;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
