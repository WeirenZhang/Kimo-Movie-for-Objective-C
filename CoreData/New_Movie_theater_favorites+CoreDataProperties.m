//
//  New_Movie_theater_favorites+CoreDataProperties.m
//  movie
//
//  Created by lan1 on 2017/8/3.
//  Copyright © 2017年 eznewlife. All rights reserved.
//

#import "New_Movie_theater_favorites+CoreDataProperties.h"

@implementation New_Movie_theater_favorites (CoreDataProperties)

+ (NSFetchRequest<New_Movie_theater_favorites *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"New_Movie_theater_favorites"];
}

@dynamic movie_theater_id;
@dynamic movie_theater_name;
@dynamic movie_theater_tel;
@dynamic movie_theater_address;

@end
