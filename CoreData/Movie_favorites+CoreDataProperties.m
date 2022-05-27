//
//  Movie_favorites+CoreDataProperties.m
//  movie
//
//  Created by lan1 on 2017/8/3.
//  Copyright © 2017年 eznewlife. All rights reserved.
//

#import "Movie_favorites+CoreDataProperties.h"

@implementation Movie_favorites (CoreDataProperties)

+ (NSFetchRequest<Movie_favorites *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Movie_favorites"];
}

@dynamic movie_chinese_name;
@dynamic movie_english_name;
@dynamic movie_id;
@dynamic movie_image_url;
@dynamic movie_menu;
@dynamic movie_release_date;

@end
