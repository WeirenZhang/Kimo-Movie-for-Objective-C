//
//  MovieViewController.m
//  movie
//
//  Created by Ian1 on 2014/7/7.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface MovieViewController () <ViewPagerDataSource, ViewPagerDelegate>

@end

@implementation MovieViewController

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
    self.dataSource = self;
    self.delegate = self;
    self.title = self.chinese_name;
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openUrl:) name:@"openUrl" object:nil];
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
    
    if (![_release_date isEqual: @""]) {
        self.navigationItem.rightBarButtonItem = right_item;
    }
}

- (void)Favorites {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * movie_id = [f numberFromString:[NSString stringWithFormat:@"%@",self.movie_id]];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie_favorites" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetch setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movie_id == %@", movie_id];
    [fetch setPredicate:predicate];
    
    NSArray *allUsers = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
    if ([allUsers count] == 0) {
        // Configure for text only and offset down
        Movie_favorites *movie_favorites;
        movie_favorites = [NSEntityDescription insertNewObjectForEntityForName:@"Movie_favorites" inManagedObjectContext:appDelegate. managedObjectContext];
        
        movie_favorites.movie_id = movie_id;
        movie_favorites.movie_chinese_name = self.chinese_name;
        movie_favorites.movie_english_name = self.english_name;
        movie_favorites.movie_image_url = self.image;
        movie_favorites.movie_release_date = self.release_date;
        movie_favorites.movie_menu = self.menu;
        
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

- (void)openUrl:(NSNotification*)not
{
    NSURL *url = not.object;
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 4;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    
    switch (index) {
        case 0:
            self.viewPager_name = @"電影資料";
            break;
        case 1:
            self.viewPager_name = @"劇情簡介";
            break;
        case 2:
            self.viewPager_name = @"播放時間";
            break;
        case 3:
            self.viewPager_name = @"預告片";
            break;
        case 4:
            //self.viewPager_name = @"網友短評";
            break;
        default:
            break;
    }
    
    label.text = self.viewPager_name;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == 0) {
        MovieDataViewController *cvc = [[MovieDataViewController alloc] initWithNibName:@"MovieDataViewController" bundle:nil];
        cvc.movie_id = self.movie_id;
        cvc.menu = self.menu;
        return cvc;
    } else if (index == 1) {
        MovieIntroductionViewController *cvc = [[MovieIntroductionViewController alloc] initWithNibName:@"MovieIntroductionViewController" bundle:nil];
        cvc.movie_id = self.movie_id;
        cvc.menu = self.menu;
        return cvc;
    } else if (index == 2) {
        MovieReleaseViewController *cvc = [[MovieReleaseViewController alloc] initWithNibName:@"MovieReleaseViewController" bundle:nil];
        cvc.movie_id = self.movie_id;
        cvc.menu = self.menu;
        return cvc;
    } else if (index == 3) {
        MovieTrailerViewController *cvc = [[MovieTrailerViewController alloc] initWithNibName:@"MovieTrailerViewController" bundle:nil];
        cvc.movie_id = self.movie_id;
        cvc.menu = self.menu;
        cvc.url = self.url;
        return cvc;
    }
    /*
    else if (index == 4) {
        MovieCommentaryViewController *cvc = [[MovieCommentaryViewController alloc] initWithNibName:@"MovieCommentaryViewController" bundle:nil];
        cvc.movie_id = self.movie_id;
        cvc.menu = self.menu;
        return cvc;
    }
    */
    return nil;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        case ViewPagerOptionFixFormerTabsPositions:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    return color;
}

@end
