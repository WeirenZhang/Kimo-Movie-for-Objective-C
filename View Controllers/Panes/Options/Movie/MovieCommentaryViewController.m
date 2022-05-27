//
//  MovieDataViewController.m
//  movie
//
//  Created by Ian1 on 2014/7/7.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieCommentaryViewController.h"
#import "MBProgressHUD.h"
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface MovieCommentaryViewController ()

@end

@implementation MovieCommentaryViewController

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
    
    //self.tableView.separatorStyle = NO;
    secondary = 0;
    currentPage = 1;
    ending = 0;
    
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
                                                             selector:@selector(queryMarkFinished10:)
                                                                 name:@"BLQueryMarkFinishedNotification10" object:nil];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(queryMarkFailed10:)
                                                                 name:@"BLQueryMarkFailedNotification10" object:nil];
                    
                    NSString* currentPageStr = [[NSString alloc] initWithFormat:@"%i",currentPage];
                    
                    _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.movie_id ,@"id", currentPageStr
                                 ,@"currentPage",
                                 nil];
                    [[Markjson sharedManager] selectKey10:_queryKey];
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
    
    //CGSize screenSize =  [UIScreen mainScreen].bounds.size;
    //self.tableView.frame = CGRectMake(0, 0, screenSize.width, self.tableView.frame.size.height - 158);
}

- (void)setupTableViewFooter
{
    // set up label
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"載入中...";
    
    self.footerLabel = label;
    [footerView addSubview:label];
    
    // set up activity indicator
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.center = CGPointMake(40, 16);
    activityIndicatorView.hidesWhenStopped = YES;
    
    self.activityIndicator = activityIndicatorView;
    [footerView addSubview:activityIndicatorView];
    
    self.tableView.tableFooterView = footerView;
    [NSThread detachNewThreadSelector: @selector(actIndicatorBegin) toTarget:self withObject:nil];
}

- (void) actIndicatorBegin {
    [self.activityIndicator startAnimating];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    MovieCommentaryTableViewCell *cell;
    
    if (cell == nil) {
        cell = [[MovieCommentaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //設定 title 高度 開始
    NSString *title = [dict objectForKey:@"title"];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    CGFloat title_width = CGRectGetWidth(self.tableView.frame)-(kAvatarSize*2.0+10);
    
    CGRect bounds = [title boundingRectWithSize:CGSizeMake(title_width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    
    CGFloat title_height = roundf(CGRectGetHeight(bounds)+kAvatarSize);
    
    if (title_height < kMinimumHeight) {
        title_height = kMinimumHeight;
    }
    //設定 title 高度 結束
    
    //設定 context 高度 開始
    NSString *content = [dict objectForKey:@"content"];
    
    paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                   NSParagraphStyleAttributeName: paragraphStyle};
    
    CGFloat content_width = CGRectGetWidth(self.tableView.frame)-(kAvatarSize*2.0+10);
    
    bounds = [content boundingRectWithSize:CGSizeMake(content_width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    
    CGFloat content_height = roundf(CGRectGetHeight(bounds)+kAvatarSize);
    
    if (content_height < kMinimumHeight) {
        content_height = kMinimumHeight;
    }
    //設定 context 高度 結束
    
    //設定 time 高度 開始
    NSString *time = [dict objectForKey:@"time"];
    
    paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.0],
                   NSParagraphStyleAttributeName: paragraphStyle};
    
    CGFloat time_width = CGRectGetWidth(self.tableView.frame)-(kAvatarSize*2.0+10);
    
    bounds = [time boundingRectWithSize:CGSizeMake(time_width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    
    CGFloat time_height = roundf(CGRectGetHeight(bounds)+kAvatarSize);
    
    if (time_height < kMinimumHeight) {
        time_height = kMinimumHeight;
    }
    //設定 time 高度 結束
    
    [cell setImageWithURL:[dict objectForKey:@"score"]];
    
    CGRect newFrame = cell.title.frame;
    newFrame.size.height = title_height;
    newFrame.origin.y = 33;
    cell.title.text = title;
    cell.title.frame = newFrame;
    
    newFrame = cell.content.frame;
    newFrame.size.height = content_height;
    newFrame.origin.y = 33 + title_height;
    cell.content.text = content;
    cell.content.frame = newFrame;
    
    newFrame = cell.time.frame;
    newFrame.size.height = time_height;
    newFrame.origin.y = 33 + title_height + content_height;
    cell.time.text = time;
    cell.time.frame = newFrame;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    //設定 title 高度 開始
    NSString *title = [dict objectForKey:@"title"];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    CGFloat title_width = CGRectGetWidth(self.tableView.frame)-(kAvatarSize*2.0+10);
    
    CGRect bounds = [title boundingRectWithSize:CGSizeMake(title_width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    
    CGFloat title_height = roundf(CGRectGetHeight(bounds)+kAvatarSize);
    
    if (title_height < kMinimumHeight) {
        title_height = kMinimumHeight;
    }
    //設定 title 高度 結束
    
    //設定 context 高度 開始
    NSString *content = [dict objectForKey:@"content"];
    
    paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                   NSParagraphStyleAttributeName: paragraphStyle};
    
    CGFloat content_width = CGRectGetWidth(self.tableView.frame)-(kAvatarSize*2.0+10);
    
    bounds = [content boundingRectWithSize:CGSizeMake(content_width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    
    CGFloat content_height = roundf(CGRectGetHeight(bounds)+kAvatarSize);
    
    if (content_height < kMinimumHeight) {
        content_height = kMinimumHeight;
    }
    //設定 context 高度 結束
    
    //設定 time 高度 開始
    NSString *time = [dict objectForKey:@"time"];
    
    paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12.0],
                   NSParagraphStyleAttributeName: paragraphStyle};
    
    CGFloat time_width = CGRectGetWidth(self.tableView.frame)-(kAvatarSize*2.0+10);
    
    bounds = [time boundingRectWithSize:CGSizeMake(time_width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    
    CGFloat time_height = roundf(CGRectGetHeight(bounds)+kAvatarSize);
    
    if (time_height < kMinimumHeight) {
        time_height = kMinimumHeight;
    }
    //設定 time 高度 結束
    
    return 33 + title_height + content_height + time_height;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (([_list count] % 10 == 0) && ([_list count] == indexPath.row + 1) && ending == 0) {
        NSString* currentPageStr = [[NSString alloc] initWithFormat:@"%i",currentPage];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryMarkFinished10:)
                                                     name:@"BLQueryMarkFinishedNotification10" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryMarkFailed10:)
                                                     name:@"BLQueryMarkFailedNotification10" object:nil];
        _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     self.movie_id ,@"id", currentPageStr
                     ,@"currentPage",
                     nil];
        [[Markjson sharedManager] selectKey10:_queryKey];
        
        [NSThread detachNewThreadSelector:@selector(setupTableViewFooter) toTarget:self withObject:nil];
    }
}

//接收BL查询Hotel信息成功通知
- (void)queryMarkFinished10:(NSNotification*)not
{
    ending = 0;
    self.tableView.tableFooterView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification10"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification10" object:nil];
    NSArray *resList = not.object;
    if( resList != (id)[NSNull null] && [resList count] != 0 ) {
        NSMutableArray *arrM = [[NSMutableArray alloc] init];
        [arrM addObjectsFromArray:_list];
        [arrM addObjectsFromArray:resList];
        _list = arrM;
        currentPage++;
    } else {
        ending = 1;
        if (currentPage == 1) {
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
    [self.activity stopAnimating];
    [loadingview removeFromSuperview];
    [self.tableView reloadData];
}

//接收BL查询Hotel信息失敗通知
- (void)queryMarkFailed10:(NSNotification*)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification10" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification10" object:nil];
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
