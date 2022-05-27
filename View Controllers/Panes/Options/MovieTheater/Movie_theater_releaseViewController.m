//
//  Movie_theater_releaseViewController.m
//  movie
//
//  Created by Ian1 on 2014/7/9.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "Movie_theater_releaseViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface Movie_theater_releaseViewController ()

@end

@implementation Movie_theater_releaseViewController

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
        self.title = self.movie_theater_name;
    }
    appDelegate = (AppDelegate*)
    [[UIApplication sharedApplication]delegate];
    
    ILBarButtonItem *right_item;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f) {
        right_item =
        [ILBarButtonItem barItemWithImage:[Counter OriginImage:[UIImage imageNamed:@"ic_action_favorite.png"] scaleToSize:CGSizeMake(24, 24)]
                            selectedImage:[Counter OriginImage:[UIImage imageNamed:@"ic_action_favorite.png"] scaleToSize:CGSizeMake(24, 24)]
                                   target:self
                                   action:@selector(Favorites)];
        self.navigationItem.rightBarButtonItem = right_item;
    } else {
        right_item =
        [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"ic_action_favorite.png"]
                            selectedImage:[UIImage imageNamed:@"ic_action_favorite.png"]
                                   target:self
                                   action:@selector(Favorites)];
        self.navigationItem.rightBarButtonItem = right_item;
    }
    
    self.navigationItem.rightBarButtonItem = right_item;
    
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
- (void)Favorites {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * movie_theater_id = [f numberFromString:[NSString stringWithFormat:@"%@",self.movie_theater_id]];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"New_Movie_theater_favorites" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetch setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movie_theater_id == %@", movie_theater_id];
    [fetch setPredicate:predicate];
    
    NSArray *allUsers = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
    if ([allUsers count] == 0) {
        // Configure for text only and offset down
        New_Movie_theater_favorites *movie_theater_favorites;
        movie_theater_favorites = [NSEntityDescription insertNewObjectForEntityForName:@"New_Movie_theater_favorites" inManagedObjectContext:appDelegate. managedObjectContext];
        
        movie_theater_favorites.movie_theater_id = movie_theater_id;
        movie_theater_favorites.movie_theater_name = _movie_theater_name;
        movie_theater_favorites.movie_theater_tel = _movie_theater_tel;
        movie_theater_favorites.movie_theater_address = _movie_theater_address;
        
        // 真正將資料寫入 "UserData"
        [appDelegate.managedObjectContext save:nil];
        NSLog(@"處理中");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud hide:YES afterDelay:1];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"加入最愛中...";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
    } else {
        // Configure for text only and offset down
        NSLog(@"已經加了");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud hide:YES afterDelay:1];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"已加入最愛";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    MovieViewController *movieViewController = [[MovieViewController alloc] initWithNibName:@"MovieViewController" bundle:nil];
    movieViewController.movie_id = [dict objectForKey:@"movie_id"];
    movieViewController.chinese_name = [dict objectForKey:@"movie_chinese_name"];
    //movieViewController.english_name = [dict objectForKey:@"english_name"];
    movieViewController.image = [dict objectForKey:@"movie_image"];
    movieViewController.release_date = @"";
    movieViewController.url = [dict objectForKey:@"trailer_url"];
    movieViewController.menu = [dict objectForKey:@"menu"];
    [self.navigationController pushViewController:movieViewController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Movie_theater_releaseCell * cell;
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    NSString *indicator = @"Cell";
    NSLog(@"%@", indicator);
    
    if (cell == nil) {
        cell = [[Movie_theater_releaseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier: indicator];
    }

    [cell.egoImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"movie_image"]]
                      placeholderImage:[UIImage imageNamed:@"small_vertical"]];
    
    cell.movie_theater_name.text = [dict objectForKey:@"movie_chinese_name"];
    cell.movie_theater_english_name.text = [dict objectForKey:@"movie_english_name"];
    
    if (![[dict objectForKey:@"movie_classification"] isEqualToString:@""]) {
        [cell.movie_classification sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"movie_classification"]]
                                     placeholderImage:[UIImage imageNamed:@"small_vertical"]];
    }

    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(Movie_theater_releaseCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionViewDataSourceDelegate1:self index:indexPath.row];
    [cell setCollectionViewDataSourceDelegate2:self index:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    NSArray * array=[dict objectForKey:@"movie_release_date"];
    int rows = (int)ceil((double)[array count] / 2.0);
    CGFloat height = kTableCellPadding * 2 + rows * kCollectionViewCellHeight + (rows) *kCollectionViewPadding;
    if (height + 100 <= 120) {
        return 150;
    } else {
        return height + 140;
    }
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag >= 1000000) {
        NSDictionary* dict = [_list objectAtIndex:collectionView.tag - 1000000];
        NSArray * array=[dict objectForKey:@"movie_device"];
        return [array count];
    } else {
        NSDictionary* dict = [_list objectAtIndex:collectionView.tag];
        NSArray * array=[dict objectForKey:@"movie_release_date"];
        return [array count];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (collectionView.tag >= 1000000) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier1 forIndexPath:indexPath];
        //cell.backgroundColor = [UIColor redColor];
        //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 43, 25)];
        UILabel *imageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 43, 25)];
        
        NSDictionary* dict = [_list objectAtIndex:collectionView.tag - 1000000];
        NSArray * array = [dict objectForKey:@"movie_device"];
        //NSString* string = [NSString stringWithFormat:@"%@.%@",array[indexPath.row],@"png"];
        /*
        [imageView sd_setImageWithURL:[NSURL URLWithString:array[indexPath.row]]
                     placeholderImage:[UIImage imageNamed:@"small_vertical"]];
        */
        imageView.text = array[indexPath.row];
        imageView.textColor = [UIColor whiteColor];
        imageView.backgroundColor = [UIColor blueColor];
        imageView.textAlignment = UITextAlignmentCenter;
        [imageView setFont:[UIFont systemFontOfSize:14]];
        cell.backgroundView = imageView;
    } else {
        NSDictionary* dict = [_list objectAtIndex:collectionView.tag];
        NSArray * array = [dict objectForKey:@"movie_release_date"];
        NSString * movie_release_date = array[indexPath.row];
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier2 forIndexPath:indexPath];
        
        //NSArray *collectionViewArray = self.colorArray[collectionView.tag];
        self.movie_theater_release = [[UILabel alloc] init];
        self.movie_theater_release.frame = (CGRect) {
            .origin.x = 0.0f,
            .origin.y = 0.0f,
            .size.width = 90.0f,
            .size.height = 20.0f
        };
        
        self.movie_theater_release.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.movie_theater_release.font = [UIFont boldSystemFontOfSize:16.0f];
        self.movie_theater_release.backgroundColor = [UIColor clearColor];
        self.movie_theater_release.textColor = [UIColor whiteColor];
        self.movie_theater_release.textAlignment = NSTextAlignmentCenter;
        self.movie_theater_release.text = movie_release_date;
        [cell addSubview:self.movie_theater_release];
    }
    return cell;
}

@end
