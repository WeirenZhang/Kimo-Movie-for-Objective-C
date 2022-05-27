//
//  HomeViewController.m
//  movie
//
//  Created by Ian1 on 2014/6/26.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "HomeViewController.h"

#import "NewViewController.h"
#import "WillViewController.h"
#import "NowViewController.h"
#import "AreaViewController.h"
#import "FavoritesViewController.h"
#import "MovieTicketViewController.h"
@import GoogleMobileAds;
@interface HomeViewController ()

@end

@implementation HomeViewController

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
    
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    if (self.title == nil) {
        self.title = @"ENL 電影時刻表";
    }
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    [self.collectionView registerClass:[SimpleCell class] forCellWithReuseIdentifier:@"Cell"];
    self.list = [[NSMutableArray alloc] init];
    [self.list addObject:@"enl_2.png"];
    [self.list addObject:@"enl_4.png"];
    [self.list addObject:@"enl_1.png"];
    [self.list addObject:@"enl_5.png"];
    [self.list addObject:@"enl_3.png"];
    [self.list addObject:@"enl_6.png"];
    
    self.list1 = [[NSMutableArray alloc] init];
    [self.list1 addObject:@"本周新片"];
    [self.list1 addObject:@"即將上映"];
    [self.list1 addObject:@"上映中"];
    [self.list1 addObject:@"電影院"];
    [self.list1 addObject:@"我的最愛"];
    [self.list1 addObject:@"網路訂票"];
    
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SimpleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    imageView.image = [UIImage imageNamed:[_list objectAtIndex:indexPath.row]];
    [cell addSubview:imageView];
    cell.icon_name.text = [_list1 objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewViewController *newViewController = [[NewViewController alloc] initWithNibName:@"NewViewController" bundle:nil];
    WillViewController *willViewController = [[WillViewController alloc] initWithNibName:@"WillViewController" bundle:nil];
    NowViewController *nowViewController = [[NowViewController alloc] initWithNibName:@"NowViewController" bundle:nil];
    AreaViewController *areaViewController = [[AreaViewController alloc] initWithNibName:@"AreaViewController" bundle:nil];
    FavoritesViewController *favoritesViewController = [[FavoritesViewController alloc] initWithNibName:@"FavoritesViewController" bundle:nil];
    MovieTicketViewController *movieTicketViewController = [[MovieTicketViewController alloc] initWithNibName:@"MovieTicketViewController" bundle:nil];
    
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:newViewController animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:willViewController animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:nowViewController animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:areaViewController animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:favoritesViewController animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:movieTicketViewController animated:YES];
            break;
        default:
            break;
    }
}

@end
