//
//  WillViewController.h
//  movie
//
//  Created by Ian1 on 2014/6/26.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieCell.h"
#import "Markjson.h"
#import "Reachability.h"
#import "PullTableView.h"
#import "MovieViewController.h"
@class GADBannerView;
@import GoogleMobileAds;

@interface WillViewController : UIViewController <UITableViewDataSource, PullTableViewDelegate>
{
    UIView* warning;
    int currentPage; //当前页数
    GADBannerView *bannerView_;
}

@property (weak, nonatomic) IBOutlet PullTableView *tableview;

@property(nonatomic,strong) NSMutableDictionary* queryKey;

@property(nonatomic,strong) NSMutableArray* list;

@end
