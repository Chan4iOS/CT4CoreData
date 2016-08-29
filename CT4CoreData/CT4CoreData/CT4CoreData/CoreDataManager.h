//
//  CoreDataManager.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic) NSManagedObjectContext *privateObjectContext;
@property (readonly, nonatomic) NSManagedObjectContext *backgroundContext;
@property (readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSPersistentStore *persistentStore;

@property (copy, nonatomic) NSString *databaseName;
@property (copy, nonatomic) NSString *modelName;

+ (id)instance DEPRECATED_ATTRIBUTE;
+ (instancetype)sharedManager;

- (BOOL)saveContext;
- (void)useInMemoryStore;

#pragma mark - Helpers

- (NSURL *)applicationDocumentsDirectory;
- (NSURL *)applicationSupportDirectory;

@end
