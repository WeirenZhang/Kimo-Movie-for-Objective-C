//
//  AreaViewController.m
//  movie
//
//  Created by Ian1 on 2014/7/1.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "AreaViewController.h"
#import "MBProgressHUD.h"

@interface AreaViewController ()

@end

@implementation AreaViewController

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
        self.title = @"電影院";
    }
    
    check = false;
    
    appDelegate = (AppDelegate*)
    [[UIApplication sharedApplication]delegate];
    network = 0;
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Area" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetch setEntity:entity];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"area_sort_id" ascending:YES];
    fetch.sortDescriptors = @[sort];
    self.allUsers = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
    
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
            //if ([self.allUsers count] == 0) {
            if (warning != nil) {
                [warning removeFromSuperview];
            }
            if (!check) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"Loading";
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(queryMarkFinished3:)
                                                             name:@"BLQueryMarkFinishedNotification3" object:nil];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(queryMarkFailed3:)
                                                             name:@"BLQueryMarkFailedNotification3" object:nil];
                _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                             @"1",@"currentPage",
                             nil];
                [[Markjson sharedManager] selectKey3:_queryKey];
                check = true;
            }
            //}
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            network = 0;
            NSLog(@"無法連線");
            //if ([self.allUsers count] == 0) {
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
            //}
        });
    };
    [reach startNotifier];
    
    if (![self.allUsers count] == 0) {
        self.list = [[NSMutableArray alloc] init];
        self.allUsers = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
        if (![self.allUsers count] == 0) {
            for (Area *p in self.allUsers) {
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:p.area_id forKey:@"area_id"];
                [parameters setObject:p.area_name forKey:@"area_name"];
                [parameters setObject:p.area_sort_id forKey:@"area_sort_id"];
                [self.list addObject:parameters];
            }
        }
    }
    
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
    static NSString *SimpleTableIdentifier = @"Cell";
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: SimpleTableIdentifier];
        
    }
    
    cell.textLabel.text = [dict objectForKey:@"area_name"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie_theater" inManagedObjectContext:appDelegate.managedObjectContext];
     [fetch setEntity:entity];
     // 設定查詢條件: 客戶編號為A01的客戶
     NSDictionary* dict = [_list objectAtIndex:indexPath.row];
     self.logo = [dict objectForKey:@"area_name"];
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movie_theater_area_id == %@", [dict objectForKey:@"area_id"]];
     [fetch setPredicate:predicate];
     self.allUsers = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
     if ([self.allUsers count] == 0) {
     NSLog(@"空的");
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
     selector:@selector(queryMarkFinished4:)
     name:@"BLQueryMarkFinishedNotification4" object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(queryMarkFailed4:)
     name:@"BLQueryMarkFailedNotification4" object:nil];
     _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     [dict objectForKey:@"area_id"], @"area_id", nil];
     [[Markjson sharedManager] selectKey4:_queryKey];
     }
     } else {
     NSLog(@"不是空的");
     _list1 = [NSMutableArray new];
     for (Movie_theater *p in self.allUsers) {
     NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
     [parameters setObject:p.movie_theater_id forKey:@"movie_theater_id"];
     [parameters setObject:p.movie_theater_name forKey:@"movie_theater_name"];
     [parameters setObject:p.movie_theater_address forKey:@"movie_theater_address"];
     [parameters setObject:p.movie_theater_tel forKey:@"movie_theater_tel"];
     [parameters setObject:p.movie_theater_area_id forKey:@"movie_theater_area_id"];
     [self.list1 addObject:parameters];
     }
     Movie_theaterViewController *movie_theaterViewController = [[Movie_theaterViewController alloc] initWithNibName:@"Movie_theaterViewController" bundle:nil];
     movie_theaterViewController.list = _list1;
     movie_theaterViewController.logo = self.logo;
     [self.navigationController pushViewController:movie_theaterViewController animated:YES];
     }
     */
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    self.logo = [dict objectForKey:@"area_name"];
    if (network == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud hide:YES afterDelay:1];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"無網路連線";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
    } else {
        /*
         count = (int) indexPath.row * 100;
         
         if (count == 0 || count == 100 || count == 200 || count == 300 || count == 400) {
         _categories = [[NSMutableArray alloc] init];
         for (int i = 0; i < [_list count]; i++) {
         NSDictionary* dict = [_list objectAtIndex:i];
         
         if( [dict objectForKey:@"movie_theater"] != (id)[NSNull null] && [[dict objectForKey:@"movie_theater"] count] != 0 ) {
         
         for (int j = 0; j < [[dict objectForKey:@"movie_theater"] count]; j++) {
         NSDictionary* dict1 = [[dict objectForKey:@"movie_theater"] objectAtIndex:j];
         if ([[dict1 objectForKey:@"movie_theater_area_id"] isEqual: [NSString stringWithFormat:@"%d", count]]) {
         [_categories addObject:dict1];
         }
         }
         }
         }
         
         for (int j = 0; j < [_categories count]; j++) {
         NSDictionary* dict1 = [_categories objectAtIndex:j];
         if ([[dict1 objectForKey:@"movie_theater_area_id"] isEqual: [NSString stringWithFormat:@"%d", count]]) {
         NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
         [f setNumberStyle:NSNumberFormatterDecimalStyle];
         NSNumber * movie_theater_id = [f numberFromString:[NSString stringWithFormat:@"%@", [dict1 objectForKey:@"movie_theater_id"]]];
         NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
         NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie_theater" inManagedObjectContext:appDelegate.managedObjectContext];
         [fetch setEntity:entity];
         
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movie_theater_id == %@", movie_theater_id];
         [fetch setPredicate:predicate];
         
         NSArray *allUsers = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
         if (![allUsers count] == 0) {
         NSLog(@"資料庫已經有了 %@", [dict1 objectForKey:@"movie_theater_name"]);
         } else {
         NSLog(@"資料庫還沒有 %@", [dict1 objectForKey:@"movie_theater_name"]);
         NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
         [f setNumberStyle:NSNumberFormatterDecimalStyle];
         Movie_theater *movie_theater;
         movie_theater = [NSEntityDescription insertNewObjectForEntityForName:@"Movie_theater" inManagedObjectContext:appDelegate. managedObjectContext];
         movie_theater.movie_theater_id = [f numberFromString:[dict1 objectForKey:@"movie_theater_id"]];
         movie_theater.movie_theater_name = [dict1 objectForKey:@"movie_theater_name"];
         movie_theater.movie_theater_address = [dict1 objectForKey:@"movie_theater_address"];
         movie_theater.movie_theater_tel = [dict1 objectForKey:@"movie_theater_tel"];
         movie_theater.movie_theater_area_id = [f numberFromString:[dict1 objectForKey:@"movie_theater_area_id"]];
         // 真正將資料寫入 "UserData"
         [appDelegate.managedObjectContext save:nil];
         }
         }
         }
         
         Movie_theaterViewController *movie_theaterViewController = [[Movie_theaterViewController alloc] initWithNibName:@"Movie_theaterViewController" bundle:nil];
         movie_theaterViewController.list = _categories;
         movie_theaterViewController.logo = self.logo;
         [self.navigationController pushViewController:movie_theaterViewController animated:YES];
         
         } else {
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         hud.labelText = @"Loading";
         [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(queryMarkFinished4:)
         name:@"BLQueryMarkFinishedNotification4" object:nil];
         
         [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(queryMarkFailed4:)
         name:@"BLQueryMarkFailedNotification4" object:nil];
         _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
         [dict objectForKey:@"area_id"], @"area_id", nil];
         [[Markjson sharedManager] selectKey4:_queryKey];
         }
         */
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading";
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryMarkFinished4:)
                                                     name:@"BLQueryMarkFinishedNotification4" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryMarkFailed4:)
                                                     name:@"BLQueryMarkFailedNotification4" object:nil];
        _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     [dict objectForKey:@"area_id"], @"area_id", nil];
        [[Markjson sharedManager] selectKey4:_queryKey];
    }
}

//接收BL查询Hotel信息成功通知
- (void)queryMarkFinished3:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification3"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification3" object:nil];
    _list = [NSMutableArray new];
    NSArray *resList = not.object;
    if( resList != (id)[NSNull null] ) {
        NSMutableArray *arrM = [[NSMutableArray alloc] init];
        [arrM addObjectsFromArray:_list];
        [arrM addObjectsFromArray:resList];
        _list = arrM;
        
        /*
         NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
         NSEntityDescription *entity = [NSEntityDescription entityForName:@"Area" inManagedObjectContext:appDelegate.managedObjectContext];
         [fetch setEntity:entity];
         NSArray *allUsers = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
         if ([allUsers count] == 0) {
         for (int i = 0; i < [_list count]; i++) {
         NSDictionary* dict = [_list objectAtIndex:i];
         NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
         [f setNumberStyle:NSNumberFormatterDecimalStyle];
         Area *area;
         area = [NSEntityDescription insertNewObjectForEntityForName:@"Area" inManagedObjectContext:appDelegate. managedObjectContext];
         area.area_id = [f numberFromString:[dict objectForKey:@"area_id"]];
         area.area_name = [dict objectForKey:@"area_name"];
         area.area_sort_id = [f numberFromString:[dict objectForKey:@"area_sort_id"]];
         // 真正將資料寫入 "UserData"
         [appDelegate.managedObjectContext save:nil];
         
         if( [dict objectForKey:@"movie_theater"] != (id)[NSNull null] && [[dict objectForKey:@"movie_theater"] count] != 0 ) {
         
         NSLog(@"%d", i);
         
         for (int j = 0; j < [[dict objectForKey:@"movie_theater"] count]; j++) {
         NSDictionary* dict1 = [[dict objectForKey:@"movie_theater"] objectAtIndex:j];
         NSLog(@"%@", [dict1 objectForKey:@"movie_theater_id"]);
         NSLog(@"%@", [dict1 objectForKey:@"movie_theater_name"]);
         NSLog(@"%@", [dict1 objectForKey:@"movie_theater_address"]);
         NSLog(@"%@", [dict1 objectForKey:@"movie_theater_tel"]);
         NSLog(@"%@", [dict1 objectForKey:@"movie_theater_area_id"]);
         Movie_theater *movie_theater;
         movie_theater = [NSEntityDescription insertNewObjectForEntityForName:@"Movie_theater" inManagedObjectContext:appDelegate. managedObjectContext];
         movie_theater.movie_theater_id = [f numberFromString:[dict1 objectForKey:@"movie_theater_id"]];
         movie_theater.movie_theater_name = [dict1 objectForKey:@"movie_theater_name"];
         movie_theater.movie_theater_address = [dict1 objectForKey:@"movie_theater_address"];
         movie_theater.movie_theater_tel = [dict1 objectForKey:@"movie_theater_tel"];
         movie_theater.movie_theater_area_id = [f numberFromString:[dict1 objectForKey:@"movie_theater_area_id"]];
         // 真正將資料寫入 "UserData"
         [appDelegate.managedObjectContext save:nil];
         }
         }
         }
         }
         */
        
        [self.tableview reloadData];
    }
}

//接收BL查询Hotel信息失敗通知
- (void)queryMarkFailed3:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification3" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification3" object:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hide:YES afterDelay:1];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"伺服器未回應，請重試";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
}

//接收BL查询Hotel信息成功通知
- (void)queryMarkFinished4:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification4"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification4" object:nil];
    _list1 = [NSMutableArray new];
    NSArray *resList = not.object;
    if( resList != (id)[NSNull null] ) {
        /*
         for (NSDictionary* dict in resList) {
         //NSLog(@"%@ %@", [dict objectForKey:@"movie_theater_area_id"], [dict objectForKey:@"movie_theater_name"]);
         
         NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
         [f setNumberStyle:NSNumberFormatterDecimalStyle];
         NSNumber * movie_theater_id = [f numberFromString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"movie_theater_id"]]];
         NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
         NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie_theater" inManagedObjectContext:appDelegate.managedObjectContext];
         [fetch setEntity:entity];
         
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movie_theater_id == %@", movie_theater_id];
         [fetch setPredicate:predicate];
         
         NSArray *allUsers = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
         if (![allUsers count] == 0) {
         NSLog(@"資料庫已經有了 %@", [dict objectForKey:@"movie_theater_name"]);
         } else {
         NSLog(@"資料庫還沒有 %@", [dict objectForKey:@"movie_theater_name"]);
         NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
         [f setNumberStyle:NSNumberFormatterDecimalStyle];
         Movie_theater *movie_theater;
         movie_theater = [NSEntityDescription insertNewObjectForEntityForName:@"Movie_theater" inManagedObjectContext:appDelegate. managedObjectContext];
         movie_theater.movie_theater_id = [f numberFromString:[dict objectForKey:@"movie_theater_id"]];
         movie_theater.movie_theater_name = [dict objectForKey:@"movie_theater_name"];
         movie_theater.movie_theater_address = [dict objectForKey:@"movie_theater_address"];
         movie_theater.movie_theater_tel = [dict objectForKey:@"movie_theater_tel"];
         movie_theater.movie_theater_area_id = [f numberFromString:[dict objectForKey:@"movie_theater_area_id"]];
         // 真正將資料寫入 "UserData"
         [appDelegate.managedObjectContext save:nil];
         }
         }
         */
        NSMutableArray *arrM = [[NSMutableArray alloc] init];
        [arrM addObjectsFromArray:_list1];
        [arrM addObjectsFromArray:resList];
        _list1 = arrM;
        Movie_theaterViewController *movie_theaterViewController = [[Movie_theaterViewController alloc] initWithNibName:@"Movie_theaterViewController" bundle:nil];
        movie_theaterViewController.list = _list1;
        movie_theaterViewController.logo = self.logo;
        [self.navigationController pushViewController:movie_theaterViewController animated:YES];
    }
}

//接收BL查询Hotel信息失敗通知
- (void)queryMarkFailed4:(NSNotification*)not
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification4" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification4" object:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hide:YES afterDelay:1];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"伺服器未回應，請重試";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
}

@end
