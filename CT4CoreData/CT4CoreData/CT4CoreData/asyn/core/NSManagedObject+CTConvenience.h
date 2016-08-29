//
//  NSManagedObject+CTConvenience.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (CTConvenience)
/**
 *  find a local object
 *
 *  @return the anyone object
 */
+(id)CTA_anyone;
/**
 *  sync find all objects
 *
 *  @return all local objects
 */
+(NSArray *)CTA_all;
/**
 *  async find all objects
 *
 *  @param handler finished handler block
 */
+(void)CTA_allWithHandler:(void(^)(NSError *error, NSArray *objects))handler;
/**
 *  sync find objects where property is equal to a specification value
 *
 *  @param property priperty name
 *  @param value    expect value
 *
 *  @return all objects fit in this condition
 */
+(NSArray *)CTA_whereProperty:(NSString *)property
                     equalTo:(id)value;
/**
 *  sync find objects where property is equal to a specification value
 *
 *  @param property property name
 *  @param value    expect value
 *  @param handler  finished handler block
 */
+(void)CTA_whereProperty:(NSString *)property
                equalTo:(id)value
                handler:(void(^)(NSError *error, NSArray *objects))handler;
/**
 *  sync find objects where property is equal to a specification value
 *
 *  @param property priperty name
 *  @param value    expect value
 *
 *  @return an object fit in this condition
 */
+(id)CTA_firstWhereProperty:(NSString *)property
                   equalTo:(id)value;
/**
 *  sync find objects where property is equal to a specification value and sorted using a keypath
 *
 *  @param property  property name
 *  @param value     expect value
 *  @param keyPath   keypath
 *  @param ascending ascending
 *
 *  @return objects fit in this condition
 */
+(NSArray *)CTA_whereProperty:(NSString *)property
                     equalTo:(id)value
               sortedKeyPath:(NSString *)keyPath
                   ascending:(BOOL)ascending;
/**
 *  async find objects where property is equal to a specification value and sorted using a keypath
 *
 *  @param property property name
 *  @param value    expect value
 *  @param keyPath  keypath
 *  @param ascendng ascending
 *  @param handler  finished fetch block
 */
+(void)CTA_whereProperty:(NSString *)property
                equalTo:(id)value
          sortedKeyPath:(NSString *)keyPath
              ascending:(BOOL)ascending
                handler:(void (^)(NSError *, NSArray *))handler;
/**
 *  find all objects fit this predicate
 *
 *  @param predicate a specification NSPredicate
 *
 *  @return all objects fit this predicate
 */
+(NSArray *)CTA_allWithPredicate:(NSPredicate *)predicate;
/**
 *  find an object fit this predicate
 *
 *  @param predicate a specification NSPredicate
 *
 *  @return an objects fit this predicate
 */
+(id)CTA_anyoneWithPredicate:(NSPredicate *)predicate;

/**
 *  sync find objects where property is equal to a specification value and sorted using a keypath
 *
 *  @param property  property name
 *  @param value     exect value
 *  @param keyPath   keypath
 *  @param ascending ascending
 *  @param batchSize  batchSize to fetch
 *  @param fetchLimit fetch limit
 *
 *  @return objects fit in this condition
 */
+(NSArray *)CTA_whereProperty:(NSString *)property
                     equalTo:(id)value
               sortedKeyPath:(NSString *)keyPath
                   ascending:(BOOL)ascending
              fetchBatchSize:(NSUInteger)batchSize
                  fetchLimit:(NSUInteger)fetchLimit
                 fetchOffset:(NSUInteger)fetchOffset;
/**
 *  async find objects where property is equal to a specification value and sorted using a keypath
 *
 *  @param property  property name
 *  @param value     exect value
 *  @param keyPath   keypath
 *  @param ascending ascending
 *  @param batchSize  batchSize to fetch
 *  @param fetchLimit fetch limit
 *  @param handler    finished fetch handler block
 */
+(void)CTA_whereProperty:(NSString *)property
                equalTo:(id)value
          sortedKeyPath:(NSString *)keyPath
              ascending:(BOOL)ascending
         fetchBatchSize:(NSUInteger)batchSize
             fetchLimit:(NSUInteger)fetchLimit
            fetchOffset:(NSUInteger)fetchOffset
                handler:(void(^)(NSError *error, NSArray *objects))handler;

/**
 *  sync find objects with vargars paramaters
 *
 *  @param condition like [NSString stringWithFormat:]
 *
 *  @return objects fit this condition
 */
+(NSArray *)CTA_where:(id)condition,...;

/**
 *  sync find objects with vargars paramaters
 *
 *  @param keyPath     sorted keyPath
 *  @param ascending   ascending
 *  @param condition   vargars paramaters conditons
 *
 *  @return objects fit this condition
 */
+(NSArray *)CTA_sortedKeyPath:(NSString *)keyPath
                   ascending:(BOOL)ascending
                   batchSize:(NSUInteger)batchSize
                       where:(id)condition,...;

/**
 *  sync find objects with vargars paramaters
 *
 *  @param keyPath     sorted keyPath
 *  @param ascending   ascending
 *  @param batchSize   perform fetch batch size
 *  @param fetchLimit  max count of objects one time to fetch
 *  @param fetchOffset fetch offset
 *  @param condition   vargars paramaters conditons
 *
 *  @return objects fit this condition
 */
+(NSArray *)CTA_sortedKeyPath:(NSString *)keyPath
                   ascending:(BOOL)ascending
              fetchBatchSize:(NSUInteger)batchSize
                  fetchLimit:(NSUInteger)fetchLimit
                 fetchOffset:(NSUInteger)fetchOffset
                       where:(id)condition,...;

/**
 *  fetch count of all objects
 *
 *  @return the entity's count
 */
+(NSUInteger)CTA_count;
/**
 *  fetch count of all objects in this condition
 *
 *  @param condition filter condition
 *
 *  @return count of objects
 */
+(NSUInteger)CTA_countWhere:(id)condition,...;

// delete methods

+(BOOL)CTA_truncateAllInContext:(NSManagedObjectContext *)context;

//save methods
+ (BOOL)CTA_saveAndWait:(void(^)(NSManagedObjectContext *currentContext))saveAndWait;
+ (void)CTA_save:(void(^)(NSManagedObjectContext *currentContext))save completion:(void(^)(NSError *error))completion;

// update methods

+(void)CTA_updateProperty:(NSString *)propertyName toValue:(id)value;
+(void)CTA_updateProperty:(NSString *)propertyName toValue:(id)value where:(NSString *)condition;
+(void)CTA_updateKeyPath:(NSString *)keyPath toValue:(id)value;
+(void)CTA_updateKeyPath:(NSString *)keyPath toValue:(id)value where:(NSString *)condition;
@end
