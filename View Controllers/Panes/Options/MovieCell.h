//
//  MovieCell.h
//  movie
//
//  Created by Ian1 on 2014/6/26.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface MovieCell : UITableViewCell
{

}

@property (nonatomic, strong) UILabel *chinese_name;
@property (nonatomic, strong) UILabel *english_name;
@property (nonatomic, strong) UILabel *release_date;
@property(nonatomic, retain) UIImageView *egoImageView;

@end
