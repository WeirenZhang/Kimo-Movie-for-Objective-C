//
//  MovieTrailerViewController.h
//  movie
//
//  Created by Ian1 on 2014/7/7.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "Markjson.h"
#import "MovieTrailerCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MovieTrailerViewController : UIViewController
{
    UIView* loadingview;
    UIView* nodataview;
    UIView* warning;
    int secondary;
}
@property (retain, nonatomic) NSString* movie_id;

@property (retain, nonatomic) NSString* menu;

@property (retain, nonatomic) NSString* url;

@property(nonatomic,strong) NSMutableArray *list;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic,strong) NSMutableDictionary* queryKey;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
