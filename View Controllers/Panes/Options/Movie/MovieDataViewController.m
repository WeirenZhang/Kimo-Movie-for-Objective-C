//
//  MovieDataViewController.m
//  movie
//
//  Created by Ian1 on 2014/7/7.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieDataViewController.h"
#import "MBProgressHUD.h"
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface MovieDataViewController ()

@end

@implementation MovieDataViewController

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
                            nibViews=[[NSBundle mainBundle] loadNibNamed:@"568_MovieDataLoading" owner:self options:nil];
                            NSLog(@"4");
                        } else{
                            // iPhone retina-3.5 inch
                            nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_MovieDataLoading" owner:self options:nil];
                            NSLog(@"3.5");
                        }
                    }
                    else {
                        // not retina display
                        nibViews=[[NSBundle mainBundle] loadNibNamed:@"480_MovieDataLoading" owner:self options:nil];
                        NSLog(@"3.5");
                    }
                }
                if (secondary == 0) {
                    loadingview = [nibViews objectAtIndex:0];
                    [self.view addSubview:loadingview]; //添加
                    [self.activity startAnimating];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(queryMarkFinished6:)
                                                                 name:@"BLQueryMarkFinishedNotification6" object:nil];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(queryMarkFailed6:)
                                                                 name:@"BLQueryMarkFailedNotification6" object:nil];
                    _queryKey = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.movie_id ,@"id",
                                 nil];
                    [[Markjson sharedManager] selectKey6:_queryKey];
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

// 傳回有多少區段
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

// 傳回每個區段要顯示多少列
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// 設定每個區段的表頭資料，這個方法為非必要方法
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    
    switch (section) {
        case 0:
            break;
        case 1:
            header = @"電影名稱";
            break;
        case 2:
            header = @"電影分級";
            break;
        case 3:
            header = @"上映日期";
            break;
        case 4:
            header = @"電影類型";
            break;
        case 5:
            header = @"電影長度";
            break;
        case 6:
            header = @"導演";
            break;
        case 7:
            header = @"演員";
            break;
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label = nil;
    NSString *row = [NSString stringWithFormat:@"%li", (long)indexPath.section];
    NSString *indicator = [NSString stringWithFormat:@"%@%@",@"Cell",row];
    NSLog(@"%@", indicator);
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             indicator];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: indicator];
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label setMinimumScaleFactor:FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        label.textColor = [UIColor whiteColor];
        [label setTag:1];
        [[cell contentView] addSubview:label];
    }
    UIImageView *imageView;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    // 區分顯示區段 開始
    switch (indexPath.section) {
        case 0:
            //egoImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"big_vertical"]];
            //egoImageView.frame = CGRectMake(0, 0, 320, 460);
            //[egoImageView setImageURL:[NSURL URLWithString:[dict objectForKey:@"image"]]];
            //[cell addSubview:egoImageView];
            
            egoImageView = [[UIImageView alloc] init];
            egoImageView.frame = CGRectMake(0, 0, 320, 460);
            [egoImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]]
                            placeholderImage:[UIImage imageNamed:@"big_vertical"]];
            [cell addSubview:egoImageView];
            
            break;
        case 1:
            self.text = [NSString stringWithFormat:@"%@\n%@",[dict objectForKey:@"chinese_name"],[dict objectForKey:@"english_name"]];
            cell.userInteractionEnabled = NO;
            break;
        case 2:
            egoImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"small_vertical"]];
            egoImageView.frame = CGRectMake(7, 7, 50, 50);
            [egoImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"classification"]]
                            placeholderImage:[UIImage imageNamed:@"big_vertical"]];
            if (![[dict objectForKey:@"classification"] isEqualToString:@""]) {
                [cell addSubview:egoImageView];
            }
            self.text = @"";
            cell.userInteractionEnabled = NO;
            break;
        case 3:
            self.text = [dict objectForKey:@"release_date"];
            cell.userInteractionEnabled = NO;
            break;
        case 4:
            self.text = [dict objectForKey:@"type"];
            cell.userInteractionEnabled = NO;
            break;
        case 5:
            self.text = [dict objectForKey:@"length"];
            cell.userInteractionEnabled = NO;
            break;
        case 6:
            self.text = [dict objectForKey:@"director"];
            cell.userInteractionEnabled = NO;
            break;
        case 7:
            self.text = [dict objectForKey:@"actor"];
            cell.userInteractionEnabled = NO;
            break;
    }
    
    if( _list != (id)[NSNull null] && [_list count] == 0) {
        self.text = @"";
    }
    
    // 區分顯示區段 結束
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:self.text attributes:@{
                                                                                                          NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]
                                                                                                          }];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    [label setText:self.text];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *classification;
    NSString *chinese_name;
    NSString *english_name;
    NSString *release_date;
    NSString *type;
    NSString *length;
    NSString *director;
    NSString *actor;
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    if( _list != (id)[NSNull null] && [_list count] == 0) {
        classification = @"";
        chinese_name = @"";
        english_name = @"";
        release_date = @"";
        type = @"";
        length = @"";
        director = @"";
        actor = @"";
    } else {
        classification = [dict objectForKey:@"classification"];
        chinese_name = [dict objectForKey:@"chinese_name"];
        english_name = [dict objectForKey:@"english_name"];
        release_date = [dict objectForKey:@"release_date"];
        type = [dict objectForKey:@"type"];
        length = [dict objectForKey:@"length"];
        director = [dict objectForKey:@"director"];
        actor = [dict objectForKey:@"actor"];
    }
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:FONT_SIZE] forKey:NSFontAttributeName];
    if (indexPath.section == 0) {
        return 460;
    } else if (indexPath.section == 1) {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:[NSString stringWithFormat:@"%@\n%@",chinese_name,english_name]
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        CGFloat height = MAX(size.height, 44.0f);
        return height + (CELL_CONTENT_MARGIN * 2);
    } else if (indexPath.section == 2) {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:classification
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        CGFloat height = MAX(size.height, 44.0f);
        return height + (CELL_CONTENT_MARGIN * 2);
    } else if (indexPath.section == 3) {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:release_date
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        CGFloat height = MAX(size.height, 44.0f);
        return height + (CELL_CONTENT_MARGIN * 2);
    } else if (indexPath.section == 4) {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:type
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        CGFloat height = MAX(size.height, 44.0f);
        return height + (CELL_CONTENT_MARGIN * 2);
    } else if (indexPath.section == 5) {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:length
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        CGFloat height = MAX(size.height, 44.0f);
        return height + (CELL_CONTENT_MARGIN * 2);
    } else if (indexPath.section == 6) {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:director
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        CGFloat height = MAX(size.height, 44.0f);
        return height + (CELL_CONTENT_MARGIN * 2);
    } else if (indexPath.section == 7) {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:actor
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        CGFloat height = MAX(size.height, 44.0f);
        return height + (CELL_CONTENT_MARGIN * 2);
    } else {
        return 44;
    }
}

//接收BL查询Hotel信息成功通知
- (void)queryMarkFinished6:(NSNotification*)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFinishedNotification6"object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BLQueryMarkFailedNotification6" object:nil];
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
    NSDictionary* dict = [_list objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MovieTrailer" object:[dict objectForKey:@"MovieTrailer"]];
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

@end
