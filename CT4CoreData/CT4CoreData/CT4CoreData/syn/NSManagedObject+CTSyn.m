//
//  NSManagedObject+CTSyn.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "NSManagedObject+CTSyn.h"
#import "ObjectiveSugar.h"

@implementation NSManagedObjectContext (CTSyn)

+ (NSManagedObjectContext *)defaultContext {
    return [[CoreDataManager sharedManager] managedObjectContext];
}

@end

@implementation NSObject(null)

- (BOOL)exists {
    return self && self != [NSNull null];
}

@end

@implementation NSManagedObject (ActiveRecord)

#pragma mark - Finders

+ (NSArray *)cts_all {
    return [self cts_allInContext:[NSManagedObjectContext defaultContext]];
}

+ (NSArray *)cts_allWithOrder:(id)order {
    return [self cts_allInContext:[NSManagedObjectContext defaultContext] order:order];
}

+ (NSArray *)cts_allInContext:(NSManagedObjectContext *)context {
    return [self cts_allInContext:context order:nil];
}

+ (NSArray *)cts_allInContext:(NSManagedObjectContext *)context order:(id)order {
    return [self fetchWithCondition:nil inContext:context withOrder:order fetchLimit:nil];
}

+ (instancetype)cts_findOrCreate:(NSDictionary *)properties {
    return [self cts_findOrCreate:properties inContext:[NSManagedObjectContext defaultContext]];
}

+ (instancetype)cts_findOrCreate:(NSDictionary *)properties inContext:(NSManagedObjectContext *)context {
    NSDictionary *transformed = [[self class] transformProperties:properties withContext:context];

    NSManagedObject *existing = [self cts_where:transformed inContext:context].first;
    return existing ?: [self cts_create:transformed inContext:context];
}

+ (instancetype)cts_find:(id)condition, ... {
    va_list va_arguments;
    va_start(va_arguments, condition);
    NSPredicate *predicate = [self predicateFromObject:condition arguments:va_arguments];
    va_end(va_arguments);

    return [self cts_find:predicate inContext:[NSManagedObjectContext defaultContext]];
}

+ (instancetype)cts_find:(id)condition inContext:(NSManagedObjectContext *)context {
    return [self cts_where:condition inContext:context limit:@1].first;
}

+ (NSArray *)cts_where:(id)condition, ... {
    va_list va_arguments;
    va_start(va_arguments, condition);
    NSPredicate *predicate = [self predicateFromObject:condition arguments:va_arguments];
    va_end(va_arguments);

    return [self cts_where:predicate inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSArray *)cts_where:(id)condition order:(id)order {
    return [self cts_where:condition inContext:[NSManagedObjectContext defaultContext] order:order];
}

+ (NSArray *)cts_where:(id)condition limit:(NSNumber *)limit {
    return [self cts_where:condition inContext:[NSManagedObjectContext defaultContext] limit:limit];
}

+ (NSArray *)cts_where:(id)condition order:(id)order limit:(NSNumber *)limit {
    return [self cts_where:condition inContext:[NSManagedObjectContext defaultContext] order:order limit:limit];
}

+ (NSArray *)cts_where:(id)condition inContext:(NSManagedObjectContext *)context {
    return [self cts_where:condition inContext:context order:nil limit:nil];
}

+ (NSArray *)cts_where:(id)condition inContext:(NSManagedObjectContext *)context order:(id)order {
    return [self cts_where:condition inContext:context order:order limit:nil];
}

+ (NSArray *)cts_where:(id)condition inContext:(NSManagedObjectContext *)context limit:(NSNumber *)limit {
    return [self cts_where:condition inContext:context order:nil limit:limit];
}

+ (NSArray *)cts_where:(id)condition inContext:(NSManagedObjectContext *)context order:(id)order limit:(NSNumber *)limit {
    return [self fetchWithCondition:condition inContext:context withOrder:order fetchLimit:limit];
}

#pragma mark - Aggregation

+ (NSUInteger)cts_count {
    return [self cts_countInContext:[NSManagedObjectContext defaultContext]];
}

+ (NSUInteger)cts_countWhere:(id)condition, ... {
    va_list va_arguments;
    va_start(va_arguments, condition);
    NSPredicate *predicate = [self predicateFromObject:condition arguments:va_arguments];
    va_end(va_arguments);

    return [self cts_countWhere:predicate inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSUInteger)cts_countInContext:(NSManagedObjectContext *)context {
    return [self countForFetchWithPredicate:nil inContext:context];
}

+ (NSUInteger)cts_countWhere:(id)condition inContext:(NSManagedObjectContext *)context {
    NSPredicate *predicate = [self predicateFromObject:condition];

    return [self countForFetchWithPredicate:predicate inContext:context];
}

#pragma mark - Creation / Deletion

+ (id)cts_create {
    return [self cts_createInContext:[NSManagedObjectContext defaultContext]];
}

+ (id)cts_create:(NSDictionary *)attributes {
    return [self cts_create:attributes inContext:[NSManagedObjectContext defaultContext]];
}

+ (id)cts_create:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context {
    unless([attributes exists]) return nil;
 
    NSManagedObject *newEntity = [self cts_createInContext:context];
    [newEntity cts_update:attributes];

    return newEntity;
}

+ (id)cts_createInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:[self cts_entityName]
                                         inManagedObjectContext:context];
}

- (void)cts_update:(NSDictionary *)attributes {
    unless([attributes exists]) return;

    NSDictionary *transformed = [[self class] transformProperties:attributes withContext:self.managedObjectContext];

    for (NSString *key in transformed) [self willChangeValueForKey:key];
    [transformed each:^(NSString *key, id value) {
        [self setSafeValue:value forKey:key];
    }];
    for (NSString *key in transformed) [self didChangeValueForKey:key];
}
- (void)cts_update:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context {
    unless([attributes exists]) return;
    
    NSDictionary *transformed = [[self class] transformProperties:attributes withObject:self context:context];
    
    for (NSString *key in transformed) [self willChangeValueForKey:key];
    [transformed each:^(NSString *key, id value) {
        [self setSafeValue:value forKey:key];
    }];
    for (NSString *key in transformed) [self didChangeValueForKey:key];
}

- (BOOL)cts_save {
    return [self saveTheContext];
}

- (void)cts_delete {
    [self.managedObjectContext deleteObject:self];
}

+ (void)cts_deleteAll {
    [self cts_deleteAllInContext:[NSManagedObjectContext defaultContext]];
}

+ (void)cts_deleteAllInContext:(NSManagedObjectContext *)context {
    [[self cts_allInContext:context] each:^(id object) {
        [object cts_delete];
    }];
}

#pragma mark - Naming

+ (NSString *)cts_entityName {
    return NSStringFromClass(self);
}

#pragma mark - Private

+ (NSDictionary *)transformProperties:(NSDictionary *)properties withContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self cts_entityName] inManagedObjectContext:context];

    NSDictionary *attributes = [entity attributesByName];
    NSDictionary *relationships = [entity relationshipsByName];

    NSMutableDictionary *transformed = [NSMutableDictionary dictionaryWithCapacity:[properties count]];

    for (NSString *key in properties) {
        NSString *localKey = [self keyForRemoteKey:key inContext:context];
        if (attributes[localKey] || relationships[localKey]) {
            transformed[localKey] = [[self class] transformValue:properties[key] forRemoteKey:key inContext:context];
        } else {
#if DEBUG
            NSLog(@"Discarding key ('%@') from properties on class ('%@'): no attribute or relationship found",
                  key, [self class]);
#endif
        }
    }

    return transformed;
}
+ (NSDictionary *)transformProperties:(NSDictionary *)properties withObject:(NSManagedObject *)object context:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self cts_entityName] inManagedObjectContext:context];
    
    NSDictionary *attributes = [entity attributesByName];
    NSDictionary *relationships = [entity relationshipsByName];
    
    NSMutableDictionary *transformed = [NSMutableDictionary dictionaryWithCapacity:[properties count]];
    
    for (NSString *key in properties) {
        NSString *localKey = [self keyForRemoteKey:key inContext:context];
        if (attributes[localKey] || relationships[localKey]) {
            id value = [[self class] transformValue:properties[key] forRemoteKey:key inContext:context];
            if (object) {
                id localValue = [object primitiveValueForKey:localKey];
                if ([localValue isEqual:value] || (localValue == nil && value == [NSNull null]))
                    continue;
            }
            transformed[localKey] = value;
        } else {
#if DEBUG
            NSLog(@"Discarding key ('%@') from properties on class ('%@'): no attribute or relationship found",
                  key, [self class]);
#endif
        }
    }
    
    return transformed;
}

+ (NSPredicate *)predicateFromDictionary:(NSDictionary *)dict {
    NSArray *subpredicates = [dict map:^(NSString *key, id value) {
        return [NSPredicate predicateWithFormat:@"%K = %@", key, value];
    }];

    return [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
}

+ (NSPredicate *)predicateFromObject:(id)condition {
    return [self predicateFromObject:condition arguments:NULL];
}

+ (NSPredicate *)predicateFromObject:(id)condition arguments:(va_list)arguments {
    if ([condition isKindOfClass:[NSPredicate class]])
        return condition;

    if ([condition isKindOfClass:[NSString class]])
        return [NSPredicate predicateWithFormat:condition arguments:arguments];

    if ([condition isKindOfClass:[NSDictionary class]])
        return [self predicateFromDictionary:condition];

    return nil;
}

+ (NSSortDescriptor *)sortDescriptorFromDictionary:(NSDictionary *)dict {
    BOOL isAscending = ![[dict.allValues.first uppercaseString] isEqualToString:@"DESC"];
    return [NSSortDescriptor sortDescriptorWithKey:dict.allKeys.first
                                         ascending:isAscending];
}

+ (NSSortDescriptor *)sortDescriptorFromString:(NSString *)order {
    NSArray *components = [order split];

    NSString *key = [components firstObject];
    NSString *value = [components count] > 1 ? components[1] : @"ASC";

    return [self sortDescriptorFromDictionary:@{key: value}];

}

+ (NSSortDescriptor *)sortDescriptorFromObject:(id)order {
    if ([order isKindOfClass:[NSSortDescriptor class]])
        return order;

    if ([order isKindOfClass:[NSString class]])
        return [self sortDescriptorFromString:order];

    if ([order isKindOfClass:[NSDictionary class]])
        return [self sortDescriptorFromDictionary:order];

    return nil;
}

+ (NSArray *)sortDescriptorsFromObject:(id)order {
    if ([order isKindOfClass:[NSString class]])
        order = [order componentsSeparatedByString:@","];

    if ([order isKindOfClass:[NSArray class]])
        return [order map:^id (id object) {
            return [self sortDescriptorFromObject:object];
        }];

    return @[[self sortDescriptorFromObject:order]];
}

+ (NSFetchRequest *)createFetchRequestInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self cts_entityName]
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    return request;
}

+ (NSArray *)fetchWithCondition:(id)condition
                      inContext:(NSManagedObjectContext *)context
                      withOrder:(id)order
                     fetchLimit:(NSNumber *)fetchLimit {

    NSFetchRequest *request = [self createFetchRequestInContext:context];

    if (condition)
        [request setPredicate:[self predicateFromObject:condition]];

    if (order)
        [request setSortDescriptors:[self sortDescriptorsFromObject:order]];

    if (fetchLimit)
        [request setFetchLimit:[fetchLimit integerValue]];
    NSError *error =nil;
    NSLog(@"executeFetchRequest~~~");
    id result =[context executeFetchRequest:request error:&error];
    NSLog(@"error:%@----->code:%@---->result:%@",error.userInfo,error.description,result);
    
    return result ;
}

+ (NSUInteger)countForFetchWithPredicate:(NSPredicate *)predicate
                               inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:predicate];

    return [context countForFetchRequest:request error:nil];
}

- (BOOL)saveTheContext {
    if (self.managedObjectContext == nil ||
        ![self.managedObjectContext hasChanges]) return YES;

    NSError *error = nil;
    BOOL save = [self.managedObjectContext save:&error];

    if (!save || error) {
        NSLog(@"Unresolved error in saving context for entity:\n%@!\nError: %@", self, error);
        return NO;
    }

    return YES;
}

- (void)setSafeValue:(id)value forKey:(NSString *)key {
    if (value == nil || value == [NSNull null]) {
        [self setNilValueForKey:key];
        return;
    }

    NSAttributeDescription *attribute = [[self entity] attributesByName][key];
    NSAttributeType attributeType = [attribute attributeType];

    if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]]))
        value = [value stringValue];

    else if ([value isKindOfClass:[NSString class]]) {

        if ([self isIntegerAttributeType:attributeType])
            value = [NSNumber numberWithInteger:[value integerValue]];

        else if (attributeType == NSBooleanAttributeType)
            value = [NSNumber numberWithBool:[value boolValue]];

        else if (attributeType == NSFloatAttributeType)
            value = [NSNumber numberWithDouble:[value doubleValue]];

        else if (attributeType == NSDateAttributeType)
            value = [self.defaultFormatter dateFromString:value];
    }

    [self setPrimitiveValue:value forKey:key];
}

- (BOOL)isIntegerAttributeType:(NSAttributeType)attributeType {
    return (attributeType == NSInteger16AttributeType) ||
           (attributeType == NSInteger32AttributeType) ||
           (attributeType == NSInteger64AttributeType);
}

#pragma mark - Date Formatting

- (NSDateFormatter *)defaultFormatter {
    static NSDateFormatter *sharedFormatter;
    static dispatch_once_t singletonToken;
    dispatch_once(&singletonToken, ^{
        sharedFormatter = [[NSDateFormatter alloc] init];
        [sharedFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    });

    return sharedFormatter;
}

@end
