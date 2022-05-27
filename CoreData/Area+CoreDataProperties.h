//
//  Area+CoreDataProperties.h
//  movie
//
//  Created by lan1 on 2017/8/3.
//  Copyright © 2017年 eznewlife. All rights reserved.
//

#import "Area+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Area (CoreDataProperties)

+ (NSFetchRequest<Area *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *area_id;
@property (nullable, nonatomic, copy) NSString *area_name;
@property (nullable, nonatomic, copy) NSNumber *area_sort_id;

@end

NS_ASSUME_NONNULL_END
