//
//  FavoritesViewController.h
//  movie
//
//  Created by Ian1 on 2014/7/11.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "ViewPagerController.h"
#import "MovieTheaterFavoritesViewController.h"
#import "MovieFavoritesViewController.h"
#import "Movie_theater_releaseViewController.h"
#import "MovieViewController.h"

@interface FavoritesViewController : ViewPagerController
{
    int network;
}

@property NSString *viewPager_name;

@property(nonatomic,strong) NSMutableDictionary* queryKey;

@property(nonatomic,strong) NSMutableArray* list1;

@property (copy, nonatomic) NSString* movie_theater_id;

@property (retain, nonatomic) NSString* movie_theater_name;

@end
