//
//  Area+CoreDataProperties.m
//  movie
//
//  Created by lan1 on 2017/8/3.
//  Copyright © 2017年 eznewlife. All rights reserved.
//

#import "Area+CoreDataProperties.h"

@implementation Area (CoreDataProperties)

+ (NSFetchRequest<Area *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Area"];
}

@dynamic area_id;
@dynamic area_name;
@dynamic area_sort_id;

@end
