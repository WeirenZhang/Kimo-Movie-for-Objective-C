//
//  Movie_theater+CoreDataProperties.h
//  movie
//
//  Created by lan1 on 2017/8/3.
//  Copyright © 2017年 eznewlife. All rights reserved.
//

#import "Movie_theater+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Movie_theater (CoreDataProperties)

+ (NSFetchRequest<Movie_theater *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *movie_theater_address;
@property (nullable, nonatomic, copy) NSNumber *movie_theater_area_id;
@property (nullable, nonatomic, copy) NSNumber *movie_theater_id;
@property (nullable, nonatomic, copy) NSString *movie_theater_name;
@property (nullable, nonatomic, copy) NSString *movie_theater_tel;

@end

NS_ASSUME_NONNULL_END
