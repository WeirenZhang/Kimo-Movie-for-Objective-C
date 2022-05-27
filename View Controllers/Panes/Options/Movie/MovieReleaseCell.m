//
//  MovieReleaseCell.m
//  movie
//
//  Created by Ian1 on 2014/7/9.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import "MovieReleaseCell.h"

@implementation MovieReleaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.movie_theater_name = [[UILabel alloc] init];
        self.movie_theater_name.frame = CGRectMake(0, 0, 320, 30);
        self.movie_theater_name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.movie_theater_name.font = [UIFont boldSystemFontOfSize:18.0f];
        self.movie_theater_name.backgroundColor = [UIColor clearColor];
        self.movie_theater_name.textColor = [UIColor whiteColor];
        self.movie_theater_name.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.movie_theater_name];
        
        UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
        layout1.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout1.minimumInteritemSpacing = 10.0;
        layout1.minimumLineSpacing = 10.0;
        layout1.itemSize = CGSizeMake(43, 18);
        layout1.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectiondeviceView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout1];
        [self.collectiondeviceView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier3];
        self.collectiondeviceView.backgroundColor = [UIColor clearColor];
        self.collectiondeviceView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:self.collectiondeviceView];

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.minimumInteritemSpacing = 10.0;
        layout.minimumLineSpacing = 10.0;
        layout.itemSize = CGSizeMake(90, 20);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:self.collectionView];
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

-(void)layoutSubviews
{
    [super layoutSubviews];
    //self.collectionView.frame = self.contentView.bounds;
    self.collectiondeviceView.frame = CGRectMake(0, 30, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    self.collectionView.frame = CGRectMake(0, 60, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}

-(void)setCollectionViewDataSourceDelegate3:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.collectiondeviceView.dataSource = dataSourceDelegate;
    self.collectiondeviceView.delegate = dataSourceDelegate;
    self.collectiondeviceView.tag = index + 1000000;
    [self.collectiondeviceView reloadData];
}

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.tag = index;
    [self.collectionView reloadData];
}

@end
