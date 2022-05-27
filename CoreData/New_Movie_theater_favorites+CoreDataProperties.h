//
//  New_Movie_theater_favorites+CoreDataProperties.h
//  movie
//
//  Created by lan1 on 2017/8/3.
//  Copyright © 2017年 eznewlife. All rights reserved.
//

#import "New_Movie_theater_favorites+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface New_Movie_theater_favorites (CoreDataProperties)

+ (NSFetchRequest<New_Movie_theater_favorites *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *movie_theater_id;
@property (nullable, nonatomic, copy) NSString *movie_theater_name;
@property (nullable, nonatomic, copy) NSString *movie_theater_tel;
@property (nullable, nonatomic, copy) NSString *movie_theater_address;

@end

NS_ASSUME_NONNULL_END
