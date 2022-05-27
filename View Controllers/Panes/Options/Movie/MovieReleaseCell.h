//
//  MovieReleaseCell.h
//  movie
//
//  Created by Ian1 on 2014/7/9.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

static NSString *CollectionViewCellIdentifier3 = @"CollectionViewCellIdentifier3";
static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface MovieReleaseCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectiondeviceView;

@property (nonatomic, strong) UICollectionView *collectionView;

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;
-(void)setCollectionViewDataSourceDelegate3:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;

@property (nonatomic, strong) UILabel *movie_theater_name;

@end

