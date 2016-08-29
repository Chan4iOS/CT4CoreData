//
//  NSManagedObject+CTCreate.m
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "NSManagedObject+CTCreate.h"
#import "NSManagedObject+CTManagedObjectContext.h"
#import "NSManagedObject+CTDBRequest.h"
#import "NSManagedObject+CTMapping.h"
@implementation NSManagedObject (CTCreate)
#pragma mark - common create

+ (id)CTA_new {
    NSManagedObjectContext *manageContext = [self defaultPrivateContext];
    return [NSEntityDescription insertNewObjectForEntityForName:[self CTA_entityName] inManagedObjectContext:manageContext];
}

+ (id)CTA_newInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:[self CTA_entityName] inManagedObjectContext:context];
}

#pragma mark - ARManageObjectMappingProtocol create

+ (id)CTA_newOrUpdateWithJSON:(NSDictionary *)JSON inContext:(NSManagedObjectContext *)context {
    return [self CTA_newOrUpdateWithJSON:JSON relationshipMergePolicy:CTRelationshipMergePolicyAdd inContext:context];
}

+ (id)CTA_newOrUpdateWithJSON:(NSDictionary *)JSON relationshipMergePolicy:(CTRelationshipMergePolicy)policy inContext:(NSManagedObjectContext *)context {
    if (JSON != nil) {
        return [[self CTA_newOrUpdateWithJSONs:@[JSON] relationshipsMergePolicy:policy inContext:context] lastObject];
    }
    return nil;
}

+ (NSArray *)CTA_newOrUpdateWithJSONs:(NSArray *)JSONs inContext:(NSManagedObjectContext *)context {
    return [self CTA_newOrUpdateWithJSONs:JSONs relationshipsMergePolicy:CTRelationshipMergePolicyAdd inContext:context];
}

+ (NSArray *)CTA_newOrUpdateWithJSONs:(NSArray *)JSONs relationshipsMergePolicy:(CTRelationshipMergePolicy)policy inContext:(NSManagedObjectContext *)context {
    NSAssert([JSONs isKindOfClass:[NSArray class]], @"JSONs should be a NSArray");
    NSAssert1([self respondsToSelector:@selector(CTA_JSONKeyPathsByPropertyKey)],  @"%@ class should impliment +(NSDictionary *)JSONKeyPathsByPropertyKey; method", NSStringFromClass(self));
    NSMutableArray *objs = [NSMutableArray array];
    
    NSDictionary *mapping = [self performSelector:@selector(CTA_JSONKeyPathsByPropertyKey)];
    NSSet *primaryKeys = nil;
    if ([self respondsToSelector:@selector(CTA_uniquedPropertyKeys)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        primaryKeys = [self performSelector:@selector(CTA_uniquedPropertyKeys)];
#pragma clang diagnostic pop
    }
    
    for (NSDictionary *JSON in JSONs) {
        [objs addObject:[self objectWithJSON:JSON
                                 primaryKeys:primaryKeys
                                     mapping:mapping
                     relationshipMergePolicy:policy
                                   inContext:context]];
        
    }
    return objs;
}

+ (id)     objectWithJSON:(NSDictionary *)JSON
              primaryKeys:(NSSet *)primaryKeys
                  mapping:(NSDictionary *)mapping
  relationshipMergePolicy:(CTRelationshipMergePolicy)policy
                inContext:(NSManagedObjectContext *)context {
    __block NSManagedObject *entity = nil;
    @autoreleasepool {
        // find or create the entity object
        if (primaryKeys == nil || primaryKeys.count == 0) {
            entity = [self CTA_newInContext:context];
        }else{
            
            //create a compumd predicate
            NSString *entityName = [self CTA_entityName];
            NSMutableArray *subPredicates = [NSMutableArray array];
            for (NSString *primaryKey in primaryKeys) {
                NSString *mappingKey = [mapping valueForKey:primaryKey];
                
                NSAttributeDescription *attributeDes = [[[NSEntityDescription entityForName:entityName inManagedObjectContext:context] attributesByName] objectForKey:primaryKey];
                id remoteValue = [JSON valueForKeyPath:mappingKey];
                if (attributeDes.attributeType == NSStringAttributeType) {
                    remoteValue = [remoteValue description];
                }else{
                    remoteValue = [NSNumber numberWithLongLong:[remoteValue longLongValue]];
                }
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",primaryKey,remoteValue];
                [subPredicates addObject:predicate];
            }
            
            NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
            
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self CTA_entityName]];
            fetchRequest.fetchLimit = 1;
            fetchRequest.resultType = NSManagedObjectIDResultType;
            [fetchRequest setPredicate:compoundPredicate];
            
            NSManagedObjectID *objectID = [[context executeFetchRequest:fetchRequest error:nil] firstObject];
            if (objectID) {
                entity = [context existingObjectWithID:objectID error:nil];
            }else{
                entity = [self CTA_newInContext:context];
            }
        }
        
        NSArray *attributes = [entity allAttributeNames];
        NSArray *relationships = [entity allRelationshipNames];
        
        [mapping enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            
            id remoteValue = [JSON valueForKeyPath:obj];
            if (remoteValue != nil) {
                
                NSString *methodName = [NSString stringWithFormat:@"%@Transformer:",key];
                SEL selector = NSSelectorFromString(methodName);
                if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    id value = [self performSelector:selector withObject:remoteValue];
#pragma clang diagnostic pop
                    if (value != nil) {
                        [entity setValue:value forKey:key];
                    }
                    
                }else{
                    if ([attributes containsObject:key]) {
                        [entity mergeAttributeForKey:key withValue:remoteValue];
                        
                        
                    }else if ([relationships containsObject:key]){
                        [entity mergeRelationshipForKey:key withValue:remoteValue mergePolicy:policy];
                    }
                    
                }
                
            }
            
        }];
    }
    return entity;
}
@end
