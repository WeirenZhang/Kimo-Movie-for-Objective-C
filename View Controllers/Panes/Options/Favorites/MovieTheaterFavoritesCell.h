//
//  MovieTheaterFavoritesCell.h
//  movie
//
//  Created by Ian1 on 2014/7/11.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTheaterFavoritesCell : UITableViewCell

@property (nonatomic, strong) UILabel *movie_theater_name;
@property (nonatomic, strong) UILabel *movie_theater_address;
@property (nonatomic, strong) UIButton *delete_theater;

@end
