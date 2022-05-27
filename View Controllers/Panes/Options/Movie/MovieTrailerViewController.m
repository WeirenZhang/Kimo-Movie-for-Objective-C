//
//  MovieTrailerViewController.m
//  movie
//
//  Created by Ian1 on 2014/7/7.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieTrailerViewController.h"
#import "MBProgressHUD.h"

@interface MovieTrailerViewController ()

@end

@implementation MovieTrailerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)MovieTrailer:(NSNotification*)not
{
    NSString *url = not.object;
    //NSLog(@"字串==%@", url);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    secondary = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovieTrailer:) name:@"MovieTrailer" object:nil];
    
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
                NSArray *nibViews;
                if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                    if ([[UIScreen mainScreen] scale] == 2.0) {
                        if([UIScreen mainScreen].bounds.size.height == 568){
                            // iPhone retina-4 inch
                            nibViews=[[NSBundle mainBundle] loadNibNamed:@"568_MovieTrailerLoading" owner:self options:nil];
                            NSLog(@"4");
                        } else{
                            // iPhone retina-3.5 inch
                            nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_MovieTrailerLoading" owner:self options:nil];
                            NSLog(@"3.5");
                        }
                    }
                    else {
                        // not retina display
                        nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_MovieTrailerLoading" owner:self options:nil];
                        NSLog(@"3.5");
                    }
                }
                
                if (secondary == 0) {
                    loadingview = [nibViews objectAtIndex:0];
                    [self.view addSubview:loadingview]; //添加
                    [self.activity startAnimating];
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(queryMarkFinished11:)
                                                                 name:@"BLQueryMarkFinishedNotification11" object:nil];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(queryMarkFailed11:)
                                                                 name:@"BLQueryMarkFailedNotification11" object:nil];
                    _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.movie_id ,@"id",
                                 nil];
                    [[Markjson sharedManager] selectKey11:_queryKey];
                    secondary = 1;
                }
            }
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"無法連線");
            secondary = 0;
            NSArray *nibViews;
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
    MovieTrailerCell *cell;
    
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[MovieTrailerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.egoImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]]
                         placeholderImage:[UIImage imageNamed:@"small_horizontal"]];
    
    cell.movietrailer_name.text = [dict objectForKey:@"movietrailer_name"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath  *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    NSURL *url = nil;
    NSString *newUrlStr = [[dict objectForKey:@"movietrailer_href"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [NSURL URLWithString:newUrlStr];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openUrl" object:url];
}

//接收BL查询Hotel信息成功通知
- (void)queryMarkFinished6:(NSNotification*)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification6"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification6" object:nil];
    NSArray *resList = not.object;
    if( resList != (id)[NSNull null] && [resList count] != 0 ) {
        NSDictionary* dict = [resList objectAtIndex:0];
        NSLog(@"字串==%@", [dict objectForKey:@"MovieTrailer"]);
        if (![[dict objectForKey:@"MovieTrailer"] isEqual: @""]) {
            NSLog(@"字串!=''");
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(queryMarkFinished8:)
                                                         name:@"BLQueryMarkFinishedNotification8" object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(queryMarkFailed8:)
                                                         name:@"BLQueryMarkFailedNotification8" object:nil];
            _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         [dict objectForKey:@"MovieTrailer"] ,@"url",
                         nil];
            [[Markjson sharedManager] selectKey8:_queryKey];
        } else {
            NSLog(@"字串==''");
            NSArray *nibViews;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    if([UIScreen mainScreen].bounds.size.height == 568){
                        // iPhone retina-4 inch
                        nibViews=[[NSBundle mainBundle] loadNibNamed:@"568_NoData" owner:self options:nil];
                        NSLog(@"4");
                    } else{
                        // iPhone retina-3.5 inch
                        nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_NoData" owner:self options:nil];
                        NSLog(@"3.5");
                    }
                }
                else {
                    // not retina display
                    nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_NoData" owner:self options:nil];
                    NSLog(@"3.5");
                }
            }
            nodataview = [nibViews objectAtIndex:0];
            [self.view addSubview:nodataview]; //添加
            [self.activity stopAnimating];
            [loadingview removeFromSuperview];
            [self.tableview reloadData];
        }
    }
}

//接收BL查询Hotel信息失敗通知
- (void)queryMarkFailed6:(NSNotification*)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification6" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification6" object:nil];
    NSLog(@"伺服器未回應");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hide:YES afterDelay:1];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"伺服器未回應，請重試";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
}

//接收BL查询Hotel信息成功通知
- (void)queryMarkFinished8:(NSNotification*)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification8"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification8" object:nil];
    NSArray *resList = not.object;
    if( resList != (id)[NSNull null] && [resList count] != 0 ) {
        NSLog(@"123456789");
        NSMutableArray *arrM = [[NSMutableArray alloc] init];
        [arrM addObjectsFromArray:_list];
        [arrM addObjectsFromArray:resList];
        _list = arrM;
        [self.activity stopAnimating];
        [loadingview removeFromSuperview];
        [self.tableview reloadData];
    } else {
        NSArray *nibViews;
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            if ([[UIScreen mainScreen] scale] == 2.0) {
                if([UIScreen mainScreen].bounds.size.height == 568){
                    // iPhone retina-4 inch
                    nibViews=[[NSBundle mainBundle] loadNibNamed:@"568_NoData" owner:self options:nil];
                    NSLog(@"4");
                } else{
                    // iPhone retina-3.5 inch
                    nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_NoData" owner:self options:nil];
                    NSLog(@"3.5");
                }
            }
            else {
                // not retina display
                nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_NoData" owner:self options:nil];
                NSLog(@"3.5");
            }
        }
        nodataview = [nibViews objectAtIndex:0];
        [self.view addSubview:nodataview]; //添加
    }
}

//接收BL查询Hotel信息失敗通知
- (void)queryMarkFailed8:(NSNotification*)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification8" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification8" object:nil];
    NSLog(@"伺服器未回應");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hide:YES afterDelay:1];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"伺服器未回應，請重試";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
}

//接收BL查询Hotel信息成功通知
- (void)queryMarkFinished11:(NSNotification*)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification11"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification11" object:nil];
    NSString *str = not.object;
    
    NSLog(@"字串==%@", str);
    
    if([str length] > 1) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryMarkFinished8:)
                                                     name:@"BLQueryMarkFinishedNotification8" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryMarkFailed8:)
                                                     name:@"BLQueryMarkFailedNotification8" object:nil];
        _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     str ,@"url",
                     nil];
        [[Markjson sharedManager] selectKey8:_queryKey];
    } else {
        NSArray *nibViews;
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            if ([[UIScreen mainScreen] scale] == 2.0) {
                if([UIScreen mainScreen].bounds.size.height == 568){
                    // iPhone retina-4 inch
                    nibViews=[[NSBundle mainBundle] loadNibNamed:@"568_NoData" owner:self options:nil];
                    NSLog(@"4");
                } else{
                    // iPhone retina-3.5 inch
                    nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_NoData" owner:self options:nil];
                    NSLog(@"3.5");
                }
            }
            else {
                // not retina display
                nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_NoData" owner:self options:nil];
                NSLog(@"3.5");
            }
        }
        nodataview = [nibViews objectAtIndex:0];
        [self.view addSubview:nodataview]; //添加
    }
}

//接收BL查询Hotel信息失敗通知
- (void)queryMarkFailed11:(NSNotification*)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification11" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification11" object:nil];
    NSLog(@"伺服器未回應");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hide:YES afterDelay:1];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"伺服器未回應，請重試";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
}

@end
