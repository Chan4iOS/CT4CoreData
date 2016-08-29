//
//  NSManagedObject+CTSynMappings.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (CTSynMappings)

/**
 A dictionary mapping remote (server) attribute names to local (Core Data) attribute names. Optionally overridden in NSManagedObject subclasses.

 @return A dictionary.
 */
+ (NSDictionary *)cts_mappings;

/**
 Returns a Core Data attribute name for a remote attribute name. Returns values defined in @c +mappings or, by default, converts snake case to camel case (e.g., @c @@"first_name" becomes @c @@"firstName").

 @see +[NSManagedObject mappings]

 @param key     A remote (server) attribute name.
 @param context A local managed object context.

 @return A local (Core Data) attribute name.
 */
+ (NSString *)keyForRemoteKey:(NSString *)remoteKey inContext:(NSManagedObjectContext *)context;

/**
 Transforms a given object for a remote attribute name.

 @param value     Object to be transformed (e.g., a dictionary may become a managed object)
 @param remoteKey A remote (server) attribute name.
 @param context   A local managed object context.

 @return A tranformed object.
 */
+ (id)transformValue:(id)value forRemoteKey:(NSString *)remoteKey inContext:(NSManagedObjectContext *)context;

/**
 The keypath uniquely identifying your entity. Usually an ID, e.g., @c @@"remoteID".

 @return An attribute name.
 */
+ (NSString *)cts_primaryKey;

@end
