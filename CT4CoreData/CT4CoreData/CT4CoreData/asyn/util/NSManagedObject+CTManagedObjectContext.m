//
//  NSManagedObject+CTManagedObjectContext.m
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "NSManagedObject+CTManagedObjectContext.h"
#import "NSManagedObject+CTSyn.h"

NSString *const CT_CoreDataCurrentThreadContext = @"CT_CoreData_CurrentThread_Context";
@implementation NSManagedObject (CTManagedObjectContext)
+ (NSManagedObjectContext *)defaultPrivateContext {
    return [CoreDataManager sharedManager].privateObjectContext;
}

+ (NSManagedObjectContext *)defaultMainContext {
    return [CoreDataManager sharedManager].managedObjectContext;
}

+ (NSManagedObjectContext *)currentContext {
    if ([NSThread isMainThread]) {
        return [self defaultMainContext];
    }
    
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    NSManagedObjectContext *context = threadDict[CT_CoreDataCurrentThreadContext];
    if (context == nil) {
        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [context setParentContext:[self defaultPrivateContext]];
        [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        context.undoManager = nil;
        threadDict[CT_CoreDataCurrentThreadContext] = context;
    }
    return context;
}
@end
