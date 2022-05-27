//
//  Movie_theaterViewController.h
//  movie
//
//  Created by Ian1 on 2014/7/2.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie_theaterCell.h"
#import "Reachability.h"
#import "Markjson.h"
#import "Movie_theater_releaseViewController.h"
@class GADBannerView;
@import GoogleMobileAds;
@class AppDelegate;

@interface Movie_theaterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    GADBannerView *bannerView_;
    AppDelegate* appDelegate;
    int network;
}

@property(nonatomic,strong) NSMutableDictionary* queryKey;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic,strong) NSMutableArray *list;

@property(nonatomic,strong) NSMutableArray* list1;

@property (retain, nonatomic) NSString* logo;

@property (copy, nonatomic) NSString* movie_theater_id;

@property (retain, nonatomic) NSString* movie_theater_name;

@property (nullable, nonatomic, copy) NSString *movie_theater_tel;

@property (nullable, nonatomic, copy) NSString *movie_theater_address;

@end
