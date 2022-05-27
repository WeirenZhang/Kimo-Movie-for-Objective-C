//
//  MovieTheaterFavoritesCell.m
//  movie
//
//  Created by Ian1 on 2014/7/11.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieTheaterFavoritesCell.h"

@implementation MovieTheaterFavoritesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.movie_theater_name = [[UILabel alloc] init];
        self.movie_theater_name.frame = (CGRect) {
            .origin.x = 10.0f,
            .origin.y = 12.0f,
            .size.width = 300.0f,
            .size.height = 15.0f
        };
        
        self.movie_theater_name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.movie_theater_name.font = [UIFont boldSystemFontOfSize:18.0f];
        self.movie_theater_name.backgroundColor = [UIColor clearColor];
        self.movie_theater_name.textColor = [UIColor whiteColor];
        [self addSubview:self.movie_theater_name];
        
        self.movie_theater_address = [[UILabel alloc] init];
        self.movie_theater_address.frame = (CGRect) {
            .origin.x = 10.0f,
            .origin.y = 42.0f,
            .size.width = 300.0f,
            .size.height = 15.0f
        };
        
        self.movie_theater_address.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.movie_theater_address.font = [UIFont boldSystemFontOfSize:14.0f];
        self.movie_theater_address.backgroundColor = [UIColor clearColor];
        self.movie_theater_address.textColor = [UIColor lightGrayColor];
        [self addSubview:self.movie_theater_address];
        
        self.delete_theater = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.delete_theater.frame = CGRectMake(275, 10, 50, 50);
        self.delete_theater.backgroundColor = [UIColor clearColor];
        self.delete_theater.showsTouchWhenHighlighted = YES;
        UIImage *btnImage = [UIImage imageNamed:@"ic_action_discard.png"];
        [self.delete_theater setBackgroundImage:btnImage forState:UIControlStateNormal];
        [self addSubview:self.delete_theater];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
