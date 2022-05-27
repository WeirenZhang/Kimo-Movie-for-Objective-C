//
//  Movie_theater+CoreDataProperties.m
//  movie
//
//  Created by lan1 on 2017/8/3.
//  Copyright © 2017年 eznewlife. All rights reserved.
//

#import "Movie_theater+CoreDataProperties.h"

@implementation Movie_theater (CoreDataProperties)

+ (NSFetchRequest<Movie_theater *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Movie_theater"];
}

@dynamic movie_theater_address;
@dynamic movie_theater_area_id;
@dynamic movie_theater_id;
@dynamic movie_theater_name;
@dynamic movie_theater_tel;

@end
