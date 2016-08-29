//
//  NSManagedObjectID+CTAddition.m
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "NSManagedObjectID+CTAddition.h"
#import "NSManagedObject+CTSyn.h"
@implementation NSManagedObjectID (CTAddition)
- (NSString *)stringRepresentation
{
    return [[self URIRepresentation] absoluteString];
}

+(instancetype)objectIDWithURIRepresentation:(NSString *)URIRepresentation
{
    NSPersistentStoreCoordinator *persistanceCoordinator = [[CoreDataManager sharedManager] persistentStoreCoordinator];
    NSManagedObjectID *objectID = [persistanceCoordinator managedObjectIDForURIRepresentation:[NSURL URLWithString:URIRepresentation]];
    return objectID;
}
@end
