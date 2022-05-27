//
//  FavoritesViewController.m
//  movie
//
//  Created by Ian1 on 2014/7/11.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "FavoritesViewController.h"
#import "MBProgressHUD.h"

@interface FavoritesViewController () <ViewPagerDataSource, ViewPagerDelegate>

@end

@implementation FavoritesViewController

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
    self.dataSource = self;
    self.delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    network = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openMovieTheater:) name:@"openMovieTheater" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openMovie:) name:@"openMovie" object:nil];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if (self.title == nil) {
        self.title = @"我的最愛";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"tw.movies.yahoo.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"正常連線");
            network = 1;
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            network = 0;
            NSLog(@"無法連線");
        });
    };
    [reach startNotifier];
}

- (void)openMovieTheater:(NSNotification*)not
{
    NSLog(@"電影院");
    NSDictionary* dict = not.object;
    self.movie_theater_id = [dict objectForKey:@"movie_theater_id"];
    self.movie_theater_name = [dict objectForKey:@"movie_theater_name"];
    if (network == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud hide:YES afterDelay:1];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"無網路連線";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
    } else {
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
    }
}

- (void)openMovie:(NSNotification*)not
{
    NSLog(@"電影");
    NSDictionary* dict = not.object;
    MovieViewController *movieViewController = [[MovieViewController alloc] initWithNibName:@"MovieViewController" bundle:nil];
    movieViewController.movie_id = [dict objectForKey:@"id"];
    movieViewController.chinese_name = [dict objectForKey:@"chinese_name"];
    movieViewController.english_name = [dict objectForKey:@"english_name"];
    movieViewController.image = [dict objectForKey:@"image"];
    movieViewController.release_date = [dict objectForKey:@"release_date"];
    movieViewController.menu = [dict objectForKey:@"menu"];
    [self.navigationController pushViewController:movieViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        network = 1;
        NSLog(@"正常連線(觀察者)");
    }
    else
    {
        network = 0;
        NSLog(@"無法連線(觀察者)");
    }
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 2;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    
    switch (index) {
        case 0:
            self.viewPager_name = @"電影院";
            break;
        case 1:
            self.viewPager_name = @"電影";
            break;
        default:
            break;
    }
    
    label.text = self.viewPager_name;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == 0) {
        MovieTheaterFavoritesViewController *cvc = [[MovieTheaterFavoritesViewController alloc] initWithNibName:@"MovieTheaterFavoritesViewController" bundle:nil];
        return cvc;
    } else if (index == 1) {
        MovieFavoritesViewController *cvc = [[MovieFavoritesViewController alloc] initWithNibName:@"MovieFavoritesViewController" bundle:nil];
        return cvc;
    }
    return nil;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        case ViewPagerOptionFixFormerTabsPositions:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    return color;
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

@end
