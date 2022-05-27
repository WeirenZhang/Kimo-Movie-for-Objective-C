//
//  MovieReleaseViewController.m
//  movie
//
//  Created by Ian1 on 2014/7/9.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieReleaseViewController.h"
#import "MBProgressHUD.h"
#import "HTHorizontalSelectionList.h"
#import "PGDatePickManager.h"

@interface MovieReleaseViewController () <HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, PGDatePickerDelegate>

@property (nonatomic, strong) HTHorizontalSelectionList *textSelectionList;

@end

@implementation MovieReleaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:dateComponents];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    _date = [formatter stringFromDate:date];
    [_button setTitle:_date forState:UIControlStateNormal];
    
    _movieId = 0;
    [self.textSelectionList setSelectedButtonIndex:0 animated:true];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryMarkFinished7:)
                                                 name:@"BLQueryMarkFinishedNotification7" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryMarkFailed7:)
                                                 name:@"BLQueryMarkFailedNotification7" object:nil];
    _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                 self.movie_id ,@"id", _date ,@"date",
                 nil];
    [[Markjson sharedManager] selectKey7:_queryKey];
}

- (void)aMethod:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeVertical;
    datePicker.isHiddenMiddleText = false;
    //    datePicker.isCycleScroll = true;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:true completion:nil];
    
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    //    datePicker.minimumDate = [dateFormatter dateFromString: @"2018-02-18"];
    //    datePicker.maximumDate = [dateFormatter dateFromString: @"2020-01-18"];
    
    //    NSDate *date = [dateFormatter dateFromString: @"2019-01-18"];
    //    [datePicker setDate:date animated:true];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _movieId = 0;
    secondary = 0;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    _date = [formatter stringFromDate:date];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    CGSize screenSize =  [UIScreen mainScreen].bounds.size;
    
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_button addTarget:self
                action:@selector(aMethod:)
      forControlEvents:UIControlEventTouchUpInside];
    _button.backgroundColor = [UIColor whiteColor];
    [_button setTitle:_date forState:UIControlStateNormal];
    _button.frame = CGRectMake(0.0, 0.0, screenSize.width, 30.0);
    [self.view addSubview:_button];
    
    self.tableView.frame = CGRectMake(0, 70, self.tableView.frame.size.width, self.tableView.frame.size.height - 120);
    
    NSError *error;
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"json"];
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    // do something useful
    _movie_json = [[NSMutableArray alloc] init];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *weatherInfo = [weatherDic objectForKey:@"markers"];
    for (int i = 0; i < [weatherInfo count]; i++) {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        NSDictionary* dict = [weatherInfo objectAtIndex:i];
        [parameters setObject:[dict objectForKey:@"area"] forKey:@"area"];
        [parameters setObject:[dict objectForKey:@"list"] forKey:@"list"];
        [_movie_json addObject:parameters];
    }
    self.textSelectionList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 30, screenSize.width, 40)];
    self.textSelectionList.delegate = self;
    self.textSelectionList.dataSource = self;
    self.textSelectionList.selectionIndicatorAnimationMode = HTHorizontalSelectionIndicatorAnimationModeLightBounce;
    self.textSelectionList.showsEdgeFadeEffect = YES;
    self.textSelectionList.selectionIndicatorColor = [UIColor redColor];
    [self.textSelectionList setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.textSelectionList setTitleFont:[UIFont systemFontOfSize:14] forState:UIControlStateNormal];
    [self.textSelectionList setTitleFont:[UIFont boldSystemFontOfSize:14] forState:UIControlStateSelected];
    [self.textSelectionList setTitleFont:[UIFont boldSystemFontOfSize:14] forState:UIControlStateHighlighted];
    //self.textSelectionList.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.textSelectionList];
    self.textSelectionList.snapToCenter = YES;
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"tw.movies.yahoo.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"正常連線");
            if (warning != nil) {
                [warning removeFromSuperview];
            }
            if( _list != (id)[NSNull null] && [_list count] == 0) {
                
                if (secondary == 0) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.labelText = @"Loading";
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(queryMarkFinished7:)
                                                                 name:@"BLQueryMarkFinishedNotification7" object:nil];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(queryMarkFailed7:)
                                                                 name:@"BLQueryMarkFailedNotification7" object:nil];
                    _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.movie_id ,@"id", _date ,@"date",
                                 nil];
                    [[Markjson sharedManager] selectKey7:_queryKey];
                    secondary = 1;
                }
            }
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"無法連線");
            NSArray *nibViews;
            secondary = 0;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    if([UIScreen mainScreen].bounds.size.height == 568){
                        // iPhone retina-4 inch
                        nibViews=[[NSBundle mainBundle] loadNibNamed:@"568_Warning" owner:self options:nil];
                        NSLog(@"4");
                    } else{
                        // iPhone retina-3.5 inch
                        nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_Warning" owner:self options:nil];
                        NSLog(@"3.5");
                    }
                }
                else {
                    // not retina display
                    nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_Warning" owner:self options:nil];
                    NSLog(@"3.5");
                }
            }
            warning = [nibViews objectAtIndex:0];
            [self.view addSubview:warning]; //添加
        });
    };
    [reach startNotifier];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 30, screenSize.width, self.tableView.frame.size.height)];
    [_textView setBackgroundColor: [UIColor blackColor]];
    _textView.textAlignment = NSTextAlignmentCenter;
    _textView.text = @"查無資料";
    _textView.font = [UIFont systemFontOfSize:16.f];
    _textView.textColor = [UIColor whiteColor];
    
    [self.view addSubview:_textView];
    _textView.hidden = true;
}

#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return _data.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index
{
    NSDictionary* dict = [_data objectAtIndex:index];
    return [self change:[[dict objectForKey:@"area"] intValue]];
}

#pragma mark - HTHorizontalSelectionListDelegate Protocol Methods

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index
{
    // update the view for the corresponding index
    _movieId = index;
    //NSDictionary* dict = [_data objectAtIndex:index];
    //NSLog(@"area = %@", [dict objectForKey:@"area"]);
    [self.tableView reloadData];
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastRow
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        NSLog(@"正常連線(觀察者)");
    }
    else
    {
        NSLog(@"無法連線(觀察者)");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_data objectAtIndex:_movieId] objectForKey:@"movie_theater_name"] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieReleaseCell * cell;
    //NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    NSString *indicator = @"Cell";
    NSLog(@"%@", indicator);
    
    if (cell == nil) {
        cell = [[MovieReleaseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: indicator];
    }
    NSDictionary* dict = [_data objectAtIndex:_movieId];
    
    cell.movie_theater_name.text = [[dict objectForKey:@"movie_theater_name"] objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(MovieReleaseCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionViewDataSourceDelegate3:self index:indexPath.row];
    [cell setCollectionViewDataSourceDelegate:self index:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    NSDictionary* dict = [_data objectAtIndex:_movieId];
    NSArray * array= [[dict objectForKey:@"movie_release_date"] objectAtIndex:indexPath.row];
    int rows = (int)ceil((double)[array count] / 3.0);
    CGFloat height = kTableCellPadding * 2 + rows * kCollectionViewCellHeight + (rows) *kCollectionViewPadding;
    return height + 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     NSDictionary* dict = [_list objectAtIndex:indexPath.row];
     NSLog(@"result %@", [dict objectForKey:@"movie_theater_id"]);
     
     self.movie_theater_id = [dict objectForKey:@"movie_theater_id"];
     self.movie_theater_name = [dict objectForKey:@"movie_theater_name"];
     
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     hud.labelText = @"Loading";
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(queryMarkFinished5:)
     name:@"BLQueryMarkFinishedNotification5" object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(queryMarkFailed5:)
     name:@"BLQueryMarkFailedNotification5" object:nil];
     _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     [dict objectForKey:@"movie_theater_id"], @"movie_theater_id", nil];
     [[Markjson sharedManager] selectKey5:_queryKey];
     */
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag >= 1000000) {
        NSDictionary* dict = [_data objectAtIndex:_movieId];
        NSArray * array = [[dict objectForKey:@"movie_device"] objectAtIndex:collectionView.tag - 1000000];
        return [array count];
    } else {
        NSDictionary* dict = [_data objectAtIndex:_movieId];
        NSArray * array = [[dict objectForKey:@"movie_release_date"] objectAtIndex:collectionView.tag];
        return [array count];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag >= 1000000) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier3 forIndexPath:indexPath];
        
        //cell.backgroundColor = [UIColor redColor];
        //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 43, 25)];
        UILabel *imageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 43, 25)];
        
        NSDictionary* dict = [_data objectAtIndex:_movieId];
        NSArray * array = [[dict objectForKey:@"movie_device"] objectAtIndex:collectionView.tag - 1000000];
        //NSString* string = [NSString stringWithFormat:@"%@.%@",array[indexPath.row],@"png"];
        
        NSLog(@"result %@", array[indexPath.row]);
        /*
         [imageView sd_setImageWithURL:[NSURL URLWithString:array[indexPath.row]]
         placeholderImage:[UIImage imageNamed:@"small_vertical"]];
         */
        imageView.text = array[indexPath.row];
        imageView.textColor = [UIColor whiteColor];
        imageView.backgroundColor = [UIColor blueColor];
        imageView.textAlignment = UITextAlignmentCenter;
        [imageView setFont:[UIFont systemFontOfSize:14]];
        cell.backgroundView = imageView;
        
        return cell;
    } else {
        //NSDictionary* dict = [_list objectAtIndex:collectionView.tag];
        NSDictionary* dict = [_data objectAtIndex:_movieId];
        NSArray * array = [[dict objectForKey:@"movie_release_date"] objectAtIndex:collectionView.tag];
        NSString * movie_release_date = array[indexPath.row];
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
        
        //NSArray *collectionViewArray = self.colorArray[collectionView.tag];
        cell.backgroundColor = [UIColor clearColor];
        self.movie_theater_release = [[UILabel alloc] init];
        self.movie_theater_release.frame = (CGRect) {
            .origin.x = 0.0f,
            .origin.y = 0.0f,
            .size.width = 90.0f,
            .size.height = 20.0f
        };
        
        self.movie_theater_release.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.movie_theater_release.font = [UIFont boldSystemFontOfSize:16.0f];
        self.movie_theater_release.backgroundColor = [UIColor clearColor];
        self.movie_theater_release.textColor = [UIColor whiteColor];
        self.movie_theater_release.textAlignment = NSTextAlignmentCenter;
        self.movie_theater_release.text = movie_release_date;
        [cell addSubview:self.movie_theater_release];
        
        return cell;
    }
}

//接收BL查询Hotel信息成功通知
- (void)queryMarkFinished5:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification5"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification5" object:nil];
    _list1 = [NSMutableArray new];
    NSArray *resList = not.object;
    if( resList != (id)[NSNull null] ) {
        for (NSDictionary* dict in resList) {
            //NSLog(@"%@", [dict objectForKey:@"movie_id"]);
            //NSLog(@"%@", [dict objectForKey:@"movie_image"]);
            //NSLog(@"%@", [dict objectForKey:@"movie_classification"]);
            //NSLog(@"%@", [dict objectForKey:@"movie_chinese_name"]);
            /*
             for (NSString* movie_device in [dict objectForKey:@"movie_device"]) {
             NSLog(@"%@", movie_device);
             }
             */
            /*
             for (NSString* movie_release_date in [dict objectForKey:@"movie_release_date"]) {
             NSLog(@"%@", movie_release_date);
             }
             */
        }
        NSMutableArray *arrM = [[NSMutableArray alloc] init];
        [arrM addObjectsFromArray:_list1];
        [arrM addObjectsFromArray:resList];
        _list1 = arrM;
        
        Movie_theater_releaseViewController *movie_theater_releaseViewController = [[Movie_theater_releaseViewController alloc] initWithNibName:@"Movie_theater_releaseViewController" bundle:nil];
        movie_theater_releaseViewController.list = _list1;
        movie_theater_releaseViewController.movie_theater_id = self.movie_theater_id;
        movie_theater_releaseViewController.movie_theater_name = self.movie_theater_name;
        [self.navigationController pushViewController:movie_theater_releaseViewController animated:YES];
    }
}

//接收BL查询Hotel信息失敗通知
- (void)queryMarkFailed5:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification5" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification5" object:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hide:YES afterDelay:1];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"伺服器未回應，請重試";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
}

//接收BL查询Hotel信息成功通知
- (void)queryMarkFinished7:(NSNotification*)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification7"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification7" object:nil];
    NSArray *resList = not.object;
    if( resList != (id)[NSNull null] && [resList count] != 0 ) {
        _textView.hidden = true;
        NSMutableArray *arrM = [[NSMutableArray alloc] init];
        _data = [[NSMutableArray alloc] init];
        [arrM addObjectsFromArray:_data];
        [arrM addObjectsFromArray:resList];
        _data = arrM;
        
        NSLog(@"_data %ld", _data.count);
        [self.textSelectionList reloadData];
        
        /*
         NSMutableArray *a = [[NSMutableArray alloc]init];
         for (int i = 0; i < [_list count]; i++) {
         NSDictionary* dict = [_list objectAtIndex:i];
         [a addObject:[dict objectForKey:@"movie_theater_id"]];
         //NSLog(@"result %@", [dict objectForKey:@"movie_theater_id"]);
         }
         NSMutableSet *setA = [NSMutableSet setWithArray:a];
         
         if( _movie_json != (id)[NSNull null] && [_movie_json count] != 0 ) {
         _data = [[NSMutableArray alloc] init];
         for (int i = 0; i < [_movie_json count]; i++) {
         NSMutableArray *b = [[NSMutableArray alloc]init];
         NSDictionary* dict = [_movie_json objectAtIndex:i];
         for (int j = 0; j < [[dict objectForKey:@"list"] count]; j++) {
         [b addObject:[[[dict objectForKey:@"list"] objectAtIndex:j] objectForKey:@"movie"]];
         }
         NSMutableSet *setB = [NSMutableSet setWithArray:b];
         [setB intersectSet:setA];
         
         if( [setB allObjects] != (id)[NSNull null] && [[setB allObjects] count] != 0 ) {
         NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
         
         NSMutableArray *c = [[NSMutableArray alloc]init];
         NSMutableArray *d = [[NSMutableArray alloc]init];
         NSMutableArray *e = [[NSMutableArray alloc]init];
         
         for (int i = 0; i < [[setB allObjects] count]; i++) {
         //NSLog(@"result %@", [[setB allObjects] objectAtIndex:i]);
         
         for (int j = 0; j < [_list count]; j++) {
         NSDictionary* dict = [_list objectAtIndex:j];
         if ([[dict objectForKey:@"movie_theater_id"] isEqual: [[setB allObjects] objectAtIndex:i]]) {
         [c addObject:[dict objectForKey:@"movie_theater_name"]];
         [d addObject:[dict objectForKey:@"movie_release_date"]];
         [e addObject:[dict objectForKey:@"movie_device"]];
         }
         }
         }
         
         [parameters setObject:c forKey:@"movie_theater_name"];
         [parameters setObject:d forKey:@"movie_release_date"];
         [parameters setObject:e forKey:@"movie_device"];
         [parameters setObject:[dict objectForKey:@"area"] forKey:@"area"];
         [_data addObject:parameters];
         }
         
         }
         [self.textSelectionList reloadData];
         }
         */
        
    } else {
        _textView.hidden = false;
    }
    /*
     for (int i = 0; i < [_data count]; i++) {
     NSDictionary* dict = [_data objectAtIndex:i];
     NSLog(@"data area %@", [dict objectForKey:@"area"] );
     for (int j = 0; j < [[dict objectForKey:@"movie_theater_name"] count]; j++) {
     NSLog(@"data movie_theater_name %@", [[dict objectForKey:@"movie_theater_name"] objectAtIndex:j] );
     for (int k = 0; k < [[[dict objectForKey:@"movie_release_date"] objectAtIndex:j] count]; k++) {
     NSLog(@"data movie_release_date %@", [[[dict objectForKey:@"movie_release_date"] objectAtIndex:j] objectAtIndex:k] );
     }
     }
     }
     */
    [self.activity stopAnimating];
    [loadingview removeFromSuperview];
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//接收BL查询Hotel信息失敗通知
- (void)queryMarkFailed7:(NSNotification*)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification7" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification7" object:nil];
    NSLog(@"伺服器未回應");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hide:YES afterDelay:1];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"伺服器未回應，請重試";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
}

- (NSString *)change:(int)area
{
    NSString *str = @"";
    switch (area) {
        case 28:
            str = @"台北市";
            break;
        case 3:
            str = @"台北二輪";
            break;
        case 8:
            str = @"新北市";
            break;
        case 16:
            str = @"桃園";
            break;
        case 20:
            str = @"新竹";
            break;
        case 15:
            str = @"苗栗";
            break;
        case 2:
            str = @"台中";
            break;
        case 22:
            str = @"彰化";
            break;
        case 13:
            str = @"南投";
            break;
        case 19:
            str = @"雲林";
            break;
        case 21:
            str = @"嘉義";
            break;
        case 10:
            str = @"台南";
            break;
        case 17:
            str = @"高雄";
            break;
        case 14:
            str = @"屏東";
            break;
        case 18:
            str = @"基隆";
            break;
        case 11:
            str = @"宜蘭";
            break;
        case 12:
            str = @"花蓮";
            break;
        case 9:
            str = @"台東";
            break;
        case 24:
            str = @"金門";
            break;
        case 23:
            str = @"澎湖";
            break;
    }
    return str;
}

@end
