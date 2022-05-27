//
//  MovieReleaseViewController.h
//  movie
//
//  Created by Ian1 on 2014/7/9.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieReleaseCell.h"
#import "Reachability.h"
#import "Markjson.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Movie_theater_releaseViewController.h"

@interface MovieReleaseViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UIView* loadingview;
    UIView* nodataview;
    UIView* warning;
    int secondary;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSMutableArray* list;

@property(nonatomic,strong) NSMutableArray* list1;

@property(nonatomic,strong) NSMutableArray* data;

@property (nonatomic, strong) UILabel *movie_theater_release;

@property (retain, nonatomic) NSString* movie_id, * date;

@property (retain, nonatomic) NSString* menu;

@property(nonatomic,strong) NSMutableDictionary* queryKey;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property(nonatomic,strong) NSMutableArray* movie_json;

@property (nonatomic, assign) NSInteger movieId;

@property (copy, nonatomic) NSString* movie_theater_id;

@property (retain, nonatomic) NSString* movie_theater_name;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UITextView * textView;

@end
