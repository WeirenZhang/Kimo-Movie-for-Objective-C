//
//  MovieTicketViewController.m
//  movie
//
//  Created by Ian1 on 2014/7/10.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieTicketViewController.h"

@interface MovieTicketViewController ()

@end

@implementation MovieTicketViewController

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
        self.title = @"網路訂票";
    }
    
    self.list = [[NSMutableArray alloc] init];
    [self.list addObject:@"EZ訂"];
    [self.list addObject:@"DingOK"];
    [self.list addObject:@"636影城通"];
    [self.list addObject:@"博客來售票"];
    [self.list addObject:@"威秀影城"];
    [self.list addObject:@"美麗華影城"];
    [self.list addObject:@"星橋國際影城"];
    [self.list addObject:@"二廳院售票"];
    [self.list addObject:@"in89豪華數位影城"];
    [self.list addObject:@"美奇萊影城"];
    
    self.list1 = [[NSMutableArray alloc] init];
    [self.list1 addObject:@"http://www.ezding.com.tw/mmb.do"];
    [self.list1 addObject:@"http://m.dingok.com/"];
    [self.list1 addObject:@"http://emome.636.com.tw/smartphone/pages/home.php"];
    [self.list1 addObject:@"http://tickets.books.com.tw/index/"];
    [self.list1 addObject:@"http://www.vscinemas.com.tw/Mobile/SelectSession.aspx"];
    [self.list1 addObject:@"https://web.miramarcinemas.com.tw/visInternetTicketing/visChooseSession.aspx?visLang=2"];
    [self.list1 addObject:@"http://www.sbc-cinemas.com.tw/"];
    [self.list1 addObject:@"http://www.artsticket.com.tw/ckscc_mob/Application/MOB1020.aspx"];
    [self.list1 addObject:@"http://www.in89.com.tw/"];
    [self.list1 addObject:@"http://maichilai.ehosting.com.tw/login.aspx"];
    
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: SimpleTableIdentifier];
        
    }
    
    cell.textLabel.text = [_list objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:[_list1 objectAtIndex:indexPath.row]];
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
}

@end
