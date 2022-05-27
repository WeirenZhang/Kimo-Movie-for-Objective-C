//
//  HomeViewController.h
//  movie
//
//  Created by Ian1 on 2014/6/26.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleCell.h"
@class GADBannerView;

@interface HomeViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    GADBannerView *bannerView_;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic,strong) NSMutableArray* list;

@property(nonatomic,strong) NSMutableArray* list1;

@end
