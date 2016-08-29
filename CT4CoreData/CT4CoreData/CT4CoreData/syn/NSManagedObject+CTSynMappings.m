//
//  NSManagedObject+CTSynMappings.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "NSManagedObject+CTSynMappings.h"
#import "NSManagedObject+CTSyn.h"
#import "ObjectiveSugar.h"

@implementation NSManagedObject (CTSynMappings)

+ (NSString *)keyForRemoteKey:(NSString *)remoteKey inContext:(NSManagedObjectContext *)context {
    if ([self cachedMappings][remoteKey])
        return [self cachedMappings][remoteKey][@"key"];

    NSString *camelCasedProperty = [[remoteKey camelCase] stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                                                  withString:[[remoteKey substringWithRange:NSMakeRange(0, 1)] lowercaseString]];

    NSEntityDescription *entity = [NSEntityDescription entityForName:[self cts_entityName]
                                              inManagedObjectContext:context];

    if ([entity propertiesByName][camelCasedProperty]) {
        [self cacheKey:camelCasedProperty forRemoteKey:camelCasedProperty];
        return camelCasedProperty;
    }

    [self cacheKey:remoteKey forRemoteKey:remoteKey];
    return remoteKey;
}

+ (id)transformValue:(id)value forRemoteKey:(NSString *)remoteKey inContext:(NSManagedObjectContext *)context {
    Class class = [self cachedMappings][remoteKey][@"class"];
    if (class)
        return [self objectOrSetOfObjectsFromValue:value ofClass:class inContext:context];

    return value;
}

#pragma mark - Private

+ (id)objectOrSetOfObjectsFromValue:(id)value ofClass:class inContext:(NSManagedObjectContext *)context {
    if ([value isKindOfClass:class])
        return value;

    if ([value isKindOfClass:[NSDictionary class]])
        return [class cts_findOrCreate:value inContext:context];

    if ([value isKindOfClass:[NSArray class]])
        return [NSSet setWithArray:[value map:^id(id object) {
            return [self objectOrSetOfObjectsFromValue:object ofClass:class inContext:context];
        }]];

    return [class cts_findOrCreate:@{ [class primaryKey]: value } inContext:context];
}

+ (NSMutableDictionary *)cachedMappings {
    NSMutableDictionary *cachedMappings = [self sharedMappings][[self class]];
    if (!cachedMappings) {
        cachedMappings = [self sharedMappings][(id<NSCopying>)[self class]] = [NSMutableDictionary new];

        [[self mappings] each:^(id key, id value) {
            if ([value isKindOfClass:[NSString class]])
                [self cacheKey:value forRemoteKey:key];

            else {
                cachedMappings[key] = value;
                [self cacheKey:key forRemoteKey:key];
            }
        }];
    }
    return cachedMappings;
}

+ (NSMutableDictionary *)sharedMappings {
    static NSMutableDictionary *sharedMappings;
    static dispatch_once_t singletonToken;
    dispatch_once(&singletonToken, ^{
        sharedMappings = [NSMutableDictionary new];
    });
    return sharedMappings;
}

+ (void)cacheKey:(NSString *)key forRemoteKey:(NSString *)remoteKey {
    NSMutableDictionary *mapping = [[self cachedMappings][remoteKey] mutableCopy] ?: [NSMutableDictionary new];
    if (mapping[@"key"] == nil) mapping[@"key"] = key;
    [self cachedMappings][remoteKey] = mapping;
}

#pragma mark - Abstract

+ (NSDictionary *)mappings {
    return nil;
}

+ (id)primaryKey {
    @throw [NSException exceptionWithName:NSStringWithFormat(@"Primary key undefined in %@", self.class)
                                   reason:NSStringWithFormat(@"You need to override %@ +primaryKey if you want to support automatic creation with only object ID",
                                                             self.class)
                                 userInfo:nil];
}

@end
