//
//  Movie_theater_releaseCell.m
//  movie
//
//  Created by Ian1 on 2014/7/4.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "Movie_theater_releaseCell.h"

@implementation Movie_theater_releaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    self.egoImageView = [[UIImageView alloc] init];
    self.egoImageView.frame = CGRectMake(0, 0, 84, 120);
    [self addSubview:self.egoImageView];
    
    self.movie_theater_name = [[UILabel alloc] init];
    self.movie_theater_name.frame = CGRectMake(90, 0, 230, 30);
    self.movie_theater_name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.movie_theater_name.font = [UIFont boldSystemFontOfSize:16.0f];
    self.movie_theater_name.backgroundColor = [UIColor clearColor];
    self.movie_theater_name.textColor = [UIColor whiteColor];
    self.movie_theater_name.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.movie_theater_name];
    
    self.movie_theater_english_name = [[UILabel alloc] init];
    self.movie_theater_english_name.frame = CGRectMake(90, 25, 230, 30);
    self.movie_theater_english_name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.movie_theater_english_name.font = [UIFont boldSystemFontOfSize:12.0f];
    self.movie_theater_english_name.backgroundColor = [UIColor clearColor];
    self.movie_theater_english_name.textColor = [UIColor whiteColor];
    self.movie_theater_english_name.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.movie_theater_english_name];
    
    _movie_classification = [[UIImageView alloc] init];
    _movie_classification.frame = CGRectMake(90, 60, 50, 50);
    [self.contentView addSubview:_movie_classification];
    
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    layout1.minimumInteritemSpacing = 10.0;
    layout1.minimumLineSpacing = 10.0;
    layout1.itemSize = CGSizeMake(60, 20);
    layout1.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectiondeviceView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout1];
    [self.collectiondeviceView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier1];
    self.collectiondeviceView.backgroundColor = [UIColor clearColor];
    self.collectiondeviceView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectiondeviceView];
    
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    layout2.minimumInteritemSpacing = 10.0;
    layout2.minimumLineSpacing = 10.0;
    layout2.itemSize = CGSizeMake(90, 20);
    layout2.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout2];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier2];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //self.collectionView.frame = self.contentView.bounds;
    self.collectiondeviceView.frame = CGRectMake(90, 110, 230, self.contentView.bounds.size.height);
    self.collectionView.frame = CGRectMake(90, 138, 230, self.contentView.bounds.size.height);
}

-(void)setCollectionViewDataSourceDelegate1:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.collectiondeviceView.dataSource = dataSourceDelegate;
    self.collectiondeviceView.delegate = dataSourceDelegate;
    self.collectiondeviceView.tag = index + 1000000;
    [self.collectiondeviceView reloadData];
}

-(void)setCollectionViewDataSourceDelegate2:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.tag = index;
    [self.collectionView reloadData];
}

@end
