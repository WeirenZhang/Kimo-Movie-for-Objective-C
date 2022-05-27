//
//  MovieCommentaryTableViewCell.m
//  movie
//
//  Created by lan1 on 2016/3/1.
//  Copyright © 2016年 eznewlife. All rights reserved.
//

#import "MovieCommentaryTableViewCell.h"

@implementation MovieCommentaryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        egoImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"small_horizontal"]];
        egoImageView.frame = CGRectMake(10, 10, 78, 13);
        [self.contentView addSubview:egoImageView];
        
        self.title = [[UILabel alloc] init];
        self.title.frame = (CGRect) {
            .origin.x = 10.0f,
            .origin.y = 0.0f,
            .size.width = self.frame.size.width - 20.0f,
            .size.height = 18.0f
        };
        
        self.title.font = [UIFont boldSystemFontOfSize:18.0f];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.numberOfLines = 0;
        self.title.textColor = [UIColor yellowColor];
        [self addSubview:self.title];
        
        self.content = [[UILabel alloc] init];
        self.content.frame = (CGRect) {
            .origin.x = 10.0f,
            .origin.y = 0.0f,
            .size.width = self.frame.size.width - 20.0f,
            .size.height = 16.0f
        };
        
        self.content.font = [UIFont boldSystemFontOfSize:16.0f];
        self.content.backgroundColor = [UIColor clearColor];
        self.content.numberOfLines = 0;
        self.content.textColor = [UIColor whiteColor];
        [self addSubview:self.content];

        self.time = [[UILabel alloc] init];
        self.time.textAlignment = NSTextAlignmentRight;
        self.time.frame = (CGRect) {
            .origin.x = 10.0f,
            .origin.y = 0.0f,
            .size.width = self.frame.size.width - 20.0f,
            .size.height = 12.0f
        };
        
        self.time.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.time.font = [UIFont boldSystemFontOfSize:12.0f];
        self.time.backgroundColor = [UIColor clearColor];
        self.time.textColor = [UIColor lightGrayColor];
        [self addSubview:self.time];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImageWithURL:(NSString *)imageURL
{
    [egoImageView setImageURL:[NSURL URLWithString:imageURL]];
}

@end
