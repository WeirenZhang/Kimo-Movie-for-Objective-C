//
//  MovieTicketViewController.h
//  movie
//
//  Created by Ian1 on 2014/7/10.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOWebViewController.h"
@class GADBannerView;
@import GoogleMobileAds;

@interface MovieTicketViewController : UIViewController
{
    GADBannerView *bannerView_;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic,strong) NSMutableArray* list;

@property(nonatomic,strong) NSMutableArray* list1;

@end
