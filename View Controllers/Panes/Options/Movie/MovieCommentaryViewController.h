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
#import <SDWebImage/UIImageView+WebCache.h>
#import "MovieCommentaryTableViewCell.h"

@interface MovieCommentaryViewController : UIViewController
{
    UIView* loadingview;
    UIView* nodataview;
    UIView* warning;
    int secondary;
    int ending;
    int currentPage; //当前页数
}

@property (retain, nonatomic) NSString* movie_id;

@property (retain, nonatomic) NSString* menu;

@property(nonatomic,strong) NSMutableArray* list;

@property(nonatomic,strong) NSMutableArray* list1;

@property(nonatomic,strong) NSMutableArray* data;

@property (nonatomic, strong) UILabel *movie_theater_release;

@property(nonatomic,strong) NSMutableDictionary* queryKey;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property(nonatomic,strong) NSMutableArray* movie_json;

@property (nonatomic, assign) NSInteger movieId;

@property (copy, nonatomic) NSString* movie_theater_id;

@property (retain, nonatomic) NSString* movie_theater_name;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
