//
//  Movie_theaterViewController.m
//  movie
//
//  Created by Ian1 on 2014/7/2.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "Movie_theaterViewController.h"
#import "MBProgressHUD.h"

@interface Movie_theaterViewController ()

@end

@implementation Movie_theaterViewController

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
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if (self.title == nil) {
        self.title = self.logo;
    }
    
    appDelegate = (AppDelegate*)
    [[UIApplication sharedApplication]delegate];
    network = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"tw.movies.yahoo.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            network = 1;
            NSLog(@"正常連線");
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
    
    // Create a view of the standard size at the top of the screen.
    // Available AdSize constants are explained in GADAdSize.h.
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            0.0,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    
    // Specify the ad unit ID.
    bannerView_.adUnitID = @"ca-app-pub-2998840474155137/8915235603";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
    //[bannerView_ loadRequest:[self createTestRequest]];
}
/*
 - (GADRequest *)createTestRequest{
 GADRequest *request = [GADRequest request];
 request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, @"df432bddf5305e6dcdcdbf7180f57fc4e5129770", nil];
 return request;
 }
 */
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    Movie_theaterCell *cell;
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    cell = (Movie_theaterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[Movie_theaterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.movie_theater_name.text = [dict objectForKey:@"movie_theater_name"];
    cell.movie_theater_address.text = [dict objectForKey:@"movie_theater_address"];
    cell.movie_theater_tel.text = [dict objectForKey:@"movie_theater_tel"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath  *)indexPath
{
    return 96;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    self.movie_theater_id = [dict objectForKey:@"movie_theater_id"];
    self.movie_theater_name = [dict objectForKey:@"movie_theater_name"];
    self.movie_theater_address = [dict objectForKey:@"movie_theater_address"];
    self.movie_theater_tel = [dict objectForKey:@"movie_theater_tel"];
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
        movie_theater_releaseViewController.movie_theater_address = self.movie_theater_address;
        movie_theater_releaseViewController.movie_theater_tel = self.movie_theater_tel;
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
