//
//  NSManagedObject+CTManagedObjectContext.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (CTManagedObjectContext)
/**
 *  get the persitanceController default private context
 *
 *  @return the private context
 */
+ (NSManagedObjectContext *)defaultPrivateContext;

/**
 *  get the persistanceContoller default main context
 *
 *  @return the main context
 */
+ (NSManagedObjectContext *)defaultMainContext;
/**
 *  get current thread context
 *
 *  @return current context
 */
+ (NSManagedObjectContext *)currentContext;
@end
