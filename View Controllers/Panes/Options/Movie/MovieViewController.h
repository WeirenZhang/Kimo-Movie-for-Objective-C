//
//  MovieViewController.h
//  movie
//
//  Created by Ian1 on 2014/7/7.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"
#import "TOWebViewController.h"
#import "ILBarButtonItem.h"
#import "MovieDataViewController.h"
#import "MovieIntroductionViewController.h"
#import "MovieReleaseViewController.h"
#import "MovieTrailerViewController.h"
#import "MovieCommentaryViewController.h"
#import "Counter.h"
@class AppDelegate;

@interface MovieViewController : ViewPagerController
{
    AppDelegate* appDelegate;
}

@property NSString *viewPager_name;

@property (retain, nonatomic) NSString* movie_id;
@property (retain, nonatomic) NSString* chinese_name;
@property (retain, nonatomic) NSString* english_name;
@property (retain, nonatomic) NSString* image;
@property (retain, nonatomic) NSString* release_date;
@property (retain, nonatomic) NSString* url;

@property (retain, nonatomic) NSString* menu;

@end
