//
//  NewViewController.m
//  movie
//
//  Created by Ian1 on 2014/6/26.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "NewViewController.h"
#import "MBProgressHUD.h"
@import GoogleMobileAds;
@interface NewViewController ()

-(void)reachabilityChanged:(NSNotification*)note;

@end

@implementation NewViewController

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
        self.title = @"本周新片";
    }
    
    self.tableview.separatorStyle = NO;
    
    self.tableview.pullArrowImage = [UIImage imageNamed:@"whiteArrow"];
    self.tableview.pullBackgroundColor = [UIColor blackColor];
    self.tableview.pullTextColor = [UIColor whiteColor];
    currentPage = 1;
    self.check = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"tw.movies.yahoo.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"正常連線");
            
            if (warning != nil) {
                [warning removeFromSuperview];
            }
            if( _list != (id)[NSNull null] && [_list count] == 0) {
                if(!self.tableview.pullTableIsRefreshing) {
                    self.tableview.pullTableIsRefreshing = YES;
                }
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(queryMarkFinished:)
                                                             name:@"BLQueryMarkFinishedNotification" object:nil];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(queryMarkFailed:)
                                                             name:@"BLQueryMarkFailedNotification" object:nil];
                _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                             @"1",@"currentPage",
                             nil];
                [[Markjson sharedManager] selectKey:_queryKey];
            }
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"無法連線");
            NSArray *nibViews;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    if([UIScreen mainScreen].bounds.size.height == 568){
                        // iPhone retina-4 inch
                        nibViews=[[NSBundle mainBundle] loadNibNamed:@"List_568_Warning" owner:self options:nil];
                        NSLog(@"4");
                    } else{
                        // iPhone retina-3.5 inch
                        nibViews=[[NSBundle mainBundle] loadNibNamed:@"List_480_Warning" owner:self options:nil];
                        NSLog(@"3.5");
                    }
                }
                else {
                    // not retina display
                    nibViews=[[NSBundle mainBundle] loadNibNamed:@"List_480_Warning" owner:self options:nil];
                    NSLog(@"3.5");
                }
            }
            warning = [nibViews objectAtIndex:0];
            [self.view addSubview:warning]; //添加
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
        NSLog(@"正常連線(觀察者)");
    }
    else
    {
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
    MovieCell *cell;
    
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[MovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.egoImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]]
                      placeholderImage:[UIImage imageNamed:@"small_vertical"]];
    cell.chinese_name.text = [dict objectForKey:@"chinese_name"];
    cell.english_name.text = [dict objectForKey:@"english_name"];
    cell.release_date.text = [dict objectForKey:@"release_date"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath  *)indexPath
{
    return 120;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    NSLog(@"下拉刷新");
    currentPage = 1;
    self.check = @"";
    NSString* currentPageStr = [[NSString alloc] initWithFormat:@"%i",currentPage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryMarkFinished:)
                                                 name:@"BLQueryMarkFinishedNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryMarkFailed:)
                                                 name:@"BLQueryMarkFailedNotification" object:nil];
    _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                 currentPageStr,@"currentPage",
                 nil];
    [[Markjson sharedManager] selectKey:_queryKey];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    NSLog(@"上拉刷新");
    NSString* currentPageStr = [[NSString alloc] initWithFormat:@"%i",currentPage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryMarkFinished:)
                                                 name:@"BLQueryMarkFinishedNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryMarkFailed:)
                                                 name:@"BLQueryMarkFailedNotification" object:nil];
    _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                 currentPageStr,@"currentPage",
                 nil];
    [[Markjson sharedManager] selectKey:_queryKey];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    MovieViewController *movieViewController = [[MovieViewController alloc] initWithNibName:@"MovieViewController" bundle:nil];
    movieViewController.movie_id = [dict objectForKey:@"id"];
    movieViewController.chinese_name = [dict objectForKey:@"chinese_name"];
    movieViewController.english_name = [dict objectForKey:@"english_name"];
    movieViewController.image = [dict objectForKey:@"image"];
    movieViewController.release_date = [dict objectForKey:@"release_date"];
    movieViewController.url = [dict objectForKey:@"trailer_url"];
    movieViewController.menu = [dict objectForKey:@"menu"];
    [self.navigationController pushViewController:movieViewController animated:YES];
}

//接收BL查询Hotel信息成功通知
- (void)queryMarkFinished:(NSNotification*)not
{
    self.tableview.tableFooterView = nil;
    self.tableview.pullTableIsRefreshing = NO;
    self.tableview.pullTableIsLoadingMore = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification" object:nil];
    NSArray *resList = not.object;
    if (currentPage == 1) {
        _list = [NSMutableArray new];
    }
    if( resList != (id)[NSNull null] && [resList count] != 0 ) {
        currentPage++;
        NSMutableArray *arrM = [[NSMutableArray alloc] init];
        [arrM addObjectsFromArray:_list];
        [arrM addObjectsFromArray:resList];
        _list = arrM;
    } else if( resList != (id)[NSNull null] && [resList count] == 0 ) {
        NSLog(@"最末頁");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud hide:YES afterDelay:1];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"最末頁";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
    }
    self.tableview.separatorStyle = YES;
    [self.tableview reloadData];
}

//接收BL查询Hotel信息失敗通知
- (void)queryMarkFailed:(NSNotification*)not
{
    self.tableview.tableFooterView = nil;
    self.tableview.pullTableIsRefreshing = NO;
    self.tableview.pullTableIsLoadingMore = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification" object:nil];
    [self.tableview reloadData];
    NSLog(@"伺服器未回應");
}

@end
