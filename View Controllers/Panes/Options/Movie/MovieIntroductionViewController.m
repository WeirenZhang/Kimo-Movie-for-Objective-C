//
//  MovieIntroductionViewController.m
//  movie
//
//  Created by Ian1 on 2014/7/7.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieIntroductionViewController.h"
#import "MBProgressHUD.h"
#define FONT_SIZE 17.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface MovieIntroductionViewController ()
@end

@implementation MovieIntroductionViewController

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
    self.tableview.separatorStyle = NO;
    secondary = 0;
    
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
                            nibViews=[[NSBundle mainBundle] loadNibNamed:@"568_MovieIntroductionLoading" owner:self options:nil];
                            NSLog(@"4");
                        } else{
                            // iPhone retina-3.5 inch
                            nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_MovieIntroductionLoading" owner:self options:nil];
                            NSLog(@"3.5");
                        }
                    }
                    else {
                        // not retina display
                        nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_MovieIntroductionLoading" owner:self options:nil];
                        NSLog(@"3.5");
                    }
                }
                if (secondary == 0) {
                    loadingview = [nibViews objectAtIndex:0];
                    [self.view addSubview:loadingview]; //添加
                    [self.activity startAnimating];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(queryMarkFinished9:)
                                                                 name:@"BLQueryMarkFinishedNotification9" object:nil];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(queryMarkFailed9:)
                                                                 name:@"BLQueryMarkFailedNotification9" object:nil];
                    _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.movie_id ,@"id",
                                 nil];
                    [[Markjson sharedManager] selectKey9:_queryKey];
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
    UILabel *label = nil;
    
    static NSString *SimpleTableIdentifier = @"Cell";
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: SimpleTableIdentifier];
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label setMinimumScaleFactor:FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        label.textColor = [UIColor whiteColor];
        [label setTag:1];
        [[cell contentView] addSubview:label];
    }
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    // 區分顯示區段 結束
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:[dict objectForKey:@"plot_synopsis"] attributes:@{
                                                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]
                                                                                                                                     }];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    [label setText:[dict objectForKey:@"plot_synopsis"]];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *plot_synopsis;
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    if( _list != (id)[NSNull null] && [_list count] == 0) {
        plot_synopsis = @"";
    } else {
        plot_synopsis = [dict objectForKey:@"plot_synopsis"];
    }
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:FONT_SIZE] forKey:NSFontAttributeName];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:plot_synopsis
     attributes:attributes];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    CGFloat height = MAX(size.height, 44.0f);
    return height + (CELL_CONTENT_MARGIN * 2);
}

//接收BL查询Hotel信息成功通知
- (void)queryMarkFinished9:(NSNotification*)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification9"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification9" object:nil];
    NSArray *resList = not.object;
    if( resList != (id)[NSNull null] && [resList count] != 0 ) {
        NSMutableArray *arrM = [[NSMutableArray alloc] init];
        [arrM addObjectsFromArray:_list];
        [arrM addObjectsFromArray:resList];
        _list = arrM;
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
    [self.activity stopAnimating];
    [loadingview removeFromSuperview];
    [self.tableview reloadData];
}

//接收BL查询Hotel信息失敗通知
- (void)queryMarkFailed9:(NSNotification*)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification9" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification9" object:nil];
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
