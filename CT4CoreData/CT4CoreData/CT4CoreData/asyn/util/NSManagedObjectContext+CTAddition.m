//
//  NSManagedObjectContext+CTAddition.m
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "NSManagedObjectContext+CTAddition.h"
#import "CoreDataManager.h"
@implementation NSManagedObjectContext (CTAddition)
- (NSArray *)objectsWithObjectIDs:(NSArray *)objectIDs
{
    if (!objectIDs || objectIDs.count == 0) {
        return nil;
    }
    __block NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:objectIDs.count];
    
    [self performBlockAndWait:^{
        for (NSManagedObjectID *objectID in objectIDs) {
            if ([objectID isKindOfClass:[NSNull class]]) {
                continue;
            }
            
            [objects addObject:[self objectWithID:objectID]];
        }
    }];
    
    return objects;
}

-(NSArray *)objectsWithURIRepresentations:(NSArray *)URIRepresentations
{
    if (!URIRepresentations || URIRepresentations.count == 0) {
        return nil;
    }
    
    __block NSPersistentStoreCoordinator *coordinator = [[CoreDataManager sharedManager] persistentStoreCoordinator];
    __block NSMutableArray *objects = [NSMutableArray arrayWithCapacity:URIRepresentations.count];
    [self performBlockAndWait:^{
        for (NSURL *URL in URIRepresentations) {
            NSManagedObjectID *objectID = [coordinator managedObjectIDForURIRepresentation:URL];
            if (objectID == nil) {
                continue;
            }
            [objects addObject:[self objectWithID:objectID]];
        }
    }];
    return objects;
}
@end
