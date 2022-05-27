//
//  MovieDataViewController.h
//  movie
//
//  Created by Ian1 on 2014/7/7.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "Markjson.h"
#import "EGOImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MovieDataViewController : UIViewController
{
    UIView* loadingview;
    UIView* nodataview;
    UIView* warning;
@private
    UIImageView *egoImageView;
    int secondary;
}

@property (nonatomic, strong) UILabel *footerLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (retain, nonatomic) NSString* movie_id;

@property (retain, nonatomic) NSString* menu;

@property(nonatomic,strong) NSMutableDictionary* queryKey;

@property(nonatomic,strong) NSMutableArray *list;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (copy, nonatomic) NSString * text;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end
