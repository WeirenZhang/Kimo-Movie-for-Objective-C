//
//  MovieFavoritesCell.h
//  movie
//
//  Created by Ian1 on 2014/7/11.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface MovieFavoritesCell : UITableViewCell
{
@private
    EGOImageView *egoImageView;
}

@property (nonatomic, strong) UILabel *chinese_name;
@property (nonatomic, strong) UILabel *english_name;
@property (nonatomic, strong) UILabel *release_date;
@property (nonatomic, strong) UIButton *delete_movie;

-(void)setImageWithURL:(NSString *)imageURL;

@end
