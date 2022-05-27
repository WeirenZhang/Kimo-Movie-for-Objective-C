//
//  MovieFavoritesCell.m
//  movie
//
//  Created by Ian1 on 2014/7/11.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieFavoritesCell.h"

@implementation MovieFavoritesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        egoImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"small_vertical"]];
        egoImageView.frame = CGRectMake(0, 0, 84, 120);
        [self.contentView addSubview:egoImageView];
        
        self.chinese_name = [[UILabel alloc] init];
        self.chinese_name.frame = (CGRect) {
            .origin.x = 90.0f,
            .origin.y = 10.0f,
            .size.width = 230.0f,
            .size.height = 15.0f
        };
        
        self.chinese_name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.chinese_name.font = [UIFont boldSystemFontOfSize:16.0f];
        self.chinese_name.backgroundColor = [UIColor clearColor];
        self.chinese_name.textColor = [UIColor whiteColor];
        [self addSubview:self.chinese_name];
        
        self.english_name = [[UILabel alloc] init];
        self.english_name.frame = (CGRect) {
            .origin.x = 90.0f,
            .origin.y = 35.0f,
            .size.width = 230.0f,
            .size.height = 15.0f
        };
        
        self.english_name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.english_name.font = [UIFont boldSystemFontOfSize:14.0f];
        self.english_name.backgroundColor = [UIColor clearColor];
        self.english_name.textColor = [UIColor whiteColor];
        [self addSubview:self.english_name];
        
        self.release_date = [[UILabel alloc] init];
        self.release_date.frame = (CGRect) {
            .origin.x = 90.0f,
            .origin.y = 95.0f,
            .size.width = 230.0f,
            .size.height = 15.0f
        };
        
        self.release_date.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.release_date.font = [UIFont boldSystemFontOfSize:14.0f];
        self.release_date.backgroundColor = [UIColor clearColor];
        self.release_date.textColor = [UIColor whiteColor];
        [self addSubview:self.release_date];
        
        self.delete_movie = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.delete_movie.frame = CGRectMake(275, 35, 50, 50);
        self.delete_movie.backgroundColor = [UIColor clearColor];
        self.delete_movie.showsTouchWhenHighlighted = YES;
        UIImage *btnImage = [UIImage imageNamed:@"ic_action_discard.png"];
        [self.delete_movie setBackgroundImage:btnImage forState:UIControlStateNormal];
        [self addSubview:self.delete_movie];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)setImageWithURL:(NSString *)imageURL
{
    [egoImageView setImageURL:[NSURL URLWithString:imageURL]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
