//
//  MovieFavoritesViewController.h
//  movie
//
//  Created by Ian1 on 2014/7/11.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MovieFavoritesCell.h"

@class AppDelegate;

@interface MovieFavoritesViewController : UIViewController
{
    AppDelegate* appDelegate;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic,strong) NSArray* allUsers;

@property(nonatomic,strong) NSMutableArray *list;

@end
