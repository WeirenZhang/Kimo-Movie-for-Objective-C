//
//  Movie_theater_releaseCell.h
//  movie
//
//  Created by Ian1 on 2014/7/4.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "EGOImageView.h"

static NSString *CollectionViewCellIdentifier1 = @"CollectionViewCellIdentifier1";
static NSString *CollectionViewCellIdentifier2 = @"CollectionViewCellIdentifier2";

@interface Movie_theater_releaseCell : UITableViewCell
{

}

@property (nonatomic, strong) UICollectionView *collectiondeviceView;

@property (nonatomic, strong) UICollectionView *collectionView;

-(void)setCollectionViewDataSourceDelegate1:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;
-(void)setCollectionViewDataSourceDelegate2:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;

@property (nonatomic, strong) UILabel *movie_theater_name;

@property (nonatomic, strong) UILabel *movie_theater_english_name;

@property (retain, nonatomic) UIImageView * movie_classification;

@property(nonatomic, retain) UIImageView *egoImageView;

@end
