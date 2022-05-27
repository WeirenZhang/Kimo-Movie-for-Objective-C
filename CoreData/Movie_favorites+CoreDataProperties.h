//
//  Movie_favorites+CoreDataProperties.h
//  movie
//
//  Created by lan1 on 2017/8/3.
//  Copyright © 2017年 eznewlife. All rights reserved.
//

#import "Movie_favorites+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Movie_favorites (CoreDataProperties)

+ (NSFetchRequest<Movie_favorites *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *movie_chinese_name;
@property (nullable, nonatomic, copy) NSString *movie_english_name;
@property (nullable, nonatomic, copy) NSNumber *movie_id;
@property (nullable, nonatomic, copy) NSString *movie_image_url;
@property (nullable, nonatomic, copy) NSString *movie_menu;
@property (nullable, nonatomic, copy) NSString *movie_release_date;

@end

NS_ASSUME_NONNULL_END
