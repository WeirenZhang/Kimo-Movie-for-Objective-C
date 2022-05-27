//
//  Movie_theater_releaseViewController.h
//  movie
//
//  Created by Ian1 on 2014/7/9.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie_theater_releaseCell.h"
#import "Constants.h"
#import "ILBarButtonItem.h"
@class GADBannerView;
@import GoogleMobileAds;
#import <SDWebImage/UIImageView+WebCache.h>
#import "MovieViewController.h"
@class AppDelegate;

@interface Movie_theater_releaseViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
    GADBannerView *bannerView_;
    AppDelegate* appDelegate;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSMutableArray* list;

@property(nonatomic,strong) NSMutableArray* list1;

@property (nonatomic, strong) UILabel *movie_theater_release;

@property (copy, nonatomic) NSString* movie_theater_id;

@property (retain, nonatomic) NSString* movie_theater_name;

@property (nullable, nonatomic, copy) NSString *movie_theater_tel;

@property (nullable, nonatomic, copy) NSString *movie_theater_address;


@property(nonatomic,strong) NSArray* allUsers;

@end
