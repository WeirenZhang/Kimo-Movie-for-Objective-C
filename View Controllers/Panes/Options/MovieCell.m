//
//  MovieCell.m
//  movie
//
//  Created by Ian1 on 2014/6/26.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.egoImageView = [[UIImageView alloc] init];
        self.egoImageView.frame = CGRectMake(0, 0, 84, 120);
        [self addSubview:self.egoImageView];
        
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
