//
//  NSManagedObject+CTCreate.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObject+CTMapping.h"
@interface NSManagedObject (CTCreate)
/**
 *  creat an entity in default private queue context
 *
 *  @return entity
 */
+ (id)CTA_new;

/**
 *  creat an new entity in your context
 *
 *  @param context your context
 *
 *  @return entity
 */
+ (id)CTA_newInContext:(NSManagedObjectContext *)context;

/**
 *  to ceate new or update existed object with JSON, this class should impliment ARManageObjectMappingProtocol protocol
 *
 *  @param JSON key value object(KVC object)
 *
 *  @return mapping object
 */
+ (id)CTA_newOrUpdateWithJSON:(id)JSON inContext:(NSManagedObjectContext *)context;
/**
 *  to ceate new or update existed objects with JSONs, this class should impliment ARManageObjectMappingProtocol protocol
 *
 *  @param JSON key value objects(KVC objects)
 *
 *  @return mapping objects
 */
+ (NSArray *)CTA_newOrUpdateWithJSONs:(NSArray *)JSONs inContext:(NSManagedObjectContext *)context;

/**
 *  to ceate new or update existed object with JSON, this class should impliment ARManageObjectMappingProtocol protocol
 *
 *  @param JSON   JSON key value object(KVC object)
 *  @param policy ARRelationshipMergePolicy custom
 *
 *  @return mapping object
 */
+ (id)CTA_newOrUpdateWithJSON:(id)JSON relationshipMergePolicy:(CTRelationshipMergePolicy)policy inContext:(NSManagedObjectContext *)context;

/**
 *  to ceate new or update existed objects with JSONs, this class should impliment ARManageObjectMappingProtocol protocol
 *
 *  @param JSONs  JSON key value objects(KVC objects)
 *  @param policy ARRelationshipMergePolicy custom
 *
 *  @return mapping objects
 */
+ (NSArray *)CTA_newOrUpdateWithJSONs:(NSArray *)JSONs relationshipsMergePolicy:(CTRelationshipMergePolicy)policy inContext:(NSManagedObjectContext *)context;
@end
