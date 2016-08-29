//
//  NSManagedObject+CTSyn.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObject+CTSynMappings.h"
#import "CoreDataManager.h"

@interface NSManagedObjectContext (CTSyn)

+ (NSManagedObjectContext *)defaultContext;

@end

@interface NSManagedObject (ActiveRecord)


#pragma mark - Default Context

- (BOOL)cts_save;
- (void)cts_delete;
+ (void)cts_deleteAll;

+ (id)cts_create;
+ (id)cts_create:(NSDictionary *)attributes;
- (void)cts_update:(NSDictionary *)attributes;
- (void)cts_update:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context;

+ (NSArray *)cts_all;
+ (NSArray *)cts_allWithOrder:(id)order;
+ (NSArray *)cts_where:(id)condition, ...;
+ (NSArray *)cts_where:(id)condition order:(id)order;
+ (NSArray *)cts_where:(id)condition limit:(NSNumber *)limit;
+ (NSArray *)cts_where:(id)condition order:(id)order limit:(NSNumber *)limit;
+ (instancetype)cts_findOrCreate:(NSDictionary *)attributes;
+ (instancetype)cts_find:(id)condition, ...;
+ (NSUInteger)cts_count;
+ (NSUInteger)cts_countWhere:(id)condition, ...;

#pragma mark - Custom Context

+ (id)cts_createInContext:(NSManagedObjectContext *)context;
+ (id)cts_create:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context;

+ (void)cts_deleteAllInContext:(NSManagedObjectContext *)context;

+ (NSArray *)cts_allInContext:(NSManagedObjectContext *)context;
+ (NSArray *)cts_allInContext:(NSManagedObjectContext *)context order:(id)order;
+ (NSArray *)cts_where:(id)condition inContext:(NSManagedObjectContext *)context;
+ (NSArray *)cts_where:(id)condition inContext:(NSManagedObjectContext *)context order:(id)order;
+ (NSArray *)cts_where:(id)condition inContext:(NSManagedObjectContext *)context limit:(NSNumber *)limit;
+ (NSArray *)cts_where:(id)condition inContext:(NSManagedObjectContext *)context order:(id)order limit:(NSNumber *)limit;
+ (instancetype)cts_findOrCreate:(NSDictionary *)properties inContext:(NSManagedObjectContext *)context;
+ (instancetype)cts_find:(id)condition inContext:(NSManagedObjectContext *)context;
+ (NSUInteger)cts_countInContext:(NSManagedObjectContext *)context;
+ (NSUInteger)cts_countWhere:(id)condition inContext:(NSManagedObjectContext *)context;

#pragma mark - Naming

+ (NSString *)cts_entityName;


#pragma mark -export
+(NSPredicate *)predicateFromObject:(id)condition;
+ (NSPredicate *)predicateFromObject:(id)condition arguments:(va_list)arguments;
@end
