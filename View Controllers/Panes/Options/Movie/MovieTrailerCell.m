//
//  MovieTrailerCell.m
//  movie
//
//  Created by Ian1 on 2014/7/8.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieTrailerCell.h"

@implementation MovieTrailerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.egoImageView = [[UIImageView alloc] init];
        self.egoImageView.frame = CGRectMake(0, 0, 100, 70);
        [self addSubview:self.egoImageView];

        self.movietrailer_name = [[UILabel alloc] init];
        self.movietrailer_name.frame = (CGRect) {
            .origin.x = 110.0f,
            .origin.y = 26.0f,
            .size.width = 1000.0f,
            .size.height = 15.0f
        };
        
        self.movietrailer_name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.movietrailer_name.font = [UIFont boldSystemFontOfSize:16.0f];
        self.movietrailer_name.backgroundColor = [UIColor clearColor];
        self.movietrailer_name.textColor = [UIColor whiteColor];
        [self addSubview:self.movietrailer_name];
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
