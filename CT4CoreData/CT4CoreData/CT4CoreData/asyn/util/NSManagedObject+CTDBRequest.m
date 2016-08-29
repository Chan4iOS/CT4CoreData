//
//  NSManagedObject+CTDBRequest.m
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "NSManagedObject+CTDBRequest.h"

@implementation NSManagedObject (CTDBRequest)
+(NSString *)CTA_entityName
{
    return NSStringFromClass(self);
}

+(NSFetchRequest *)CTA_allRequest
{
    return [self CTA_requestWithFetchLimit:0
                                batchSize:0];
}

+(NSFetchRequest *)CTA_anyoneRequest
{
    return [self CTA_requestWithFetchLimit:1
                                batchSize:1];
}

+(NSFetchRequest *)CTA_requestWithFetchLimit:(NSUInteger)limit batchSize:(NSUInteger)batchSize
{
    return [self CTA_requestWithFetchLimit:limit batchSize:batchSize fetchOffset:0];
}

+(NSFetchRequest *)CTA_requestWithFetchLimit:(NSUInteger)limit batchSize:(NSUInteger)batchSize fetchOffset:(NSUInteger)fetchOffset
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self CTA_entityName]];
    fetchRequest.fetchLimit = limit;
    fetchRequest.fetchBatchSize = batchSize;
    fetchRequest.fetchOffset = fetchOffset;
    return fetchRequest;
}
@end
