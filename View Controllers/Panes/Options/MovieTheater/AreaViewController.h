//
//  AreaViewController.h
//  movie
//
//  Created by Ian1 on 2014/7/1.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "Markjson.h"
#import "AppDelegate.h"
#import "Movie_theaterViewController.h"
@class GADBannerView;
@import GoogleMobileAds;
@class AppDelegate;

@interface AreaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    GADBannerView *bannerView_;
    UIView* warning;
    AppDelegate* appDelegate;
    int network;
    bool check;
    int count;
}

@property(nonatomic,strong) NSMutableDictionary* queryKey;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic,strong) NSMutableArray* list;

@property(nonatomic,strong) NSMutableArray* list1, *categories;

@property(nonatomic,strong) NSArray* allUsers;

@property (retain, nonatomic) NSString* logo;

@end
