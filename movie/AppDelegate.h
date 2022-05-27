//
//  AppDelegate.h
//  movie
//
//  Created by Ian1 on 2014/6/24.
//  Copyright (c) 2014年 eznewlife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Area+CoreDataProperties.h"
#import "Movie_theater+CoreDataProperties.h"
#import "New_Movie_theater_favorites+CoreDataProperties.h"
#import "Movie_favorites+CoreDataProperties.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@class MSDynamicsDrawerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

@property(nonatomic,strong) NSArray* allUsers;

@end
