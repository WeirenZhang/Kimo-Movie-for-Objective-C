//
//  MovieCommentaryTableViewCell.h
//  movie
//
//  Created by lan1 on 2016/3/1.
//  Copyright © 2016年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

#define kAvatarSize 30.0
#define kMinimumHeight 40.0

@interface MovieCommentaryTableViewCell : UITableViewCell
{
@private
    EGOImageView *egoImageView;
}

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *time;

-(void)setImageWithURL:(NSString *)imageURL;

@end
