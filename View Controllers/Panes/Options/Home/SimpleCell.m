//
//  SimpleCell.m
//  Mark
//
//  Created by User on 13/11/6.
//  Copyright (c) 2013年 classroomM. All rights reserved.
//

#import "SimpleCell.h"

@implementation SimpleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.icon_name = [[UILabel alloc] init];
        self.icon_name.frame = (CGRect) {
            .origin.x = 0.0f,
            .origin.y = 90.0f,
            .size.width = 90.0f,
            .size.height = 60.0f
        };
        
        self.icon_name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.icon_name.font = [UIFont boldSystemFontOfSize:16.0f];
        self.icon_name.backgroundColor = [UIColor clearColor];
        self.icon_name.textColor = [UIColor whiteColor];
        self.icon_name.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.icon_name];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
