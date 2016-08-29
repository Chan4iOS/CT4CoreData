//
//  NSManagedObjectContext+CTAddition.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (CTAddition)
/**
 *  @brief 根据id获取实例 (线程中，传递entity是不安全的，所以只能传一个id，再在另一个线程上通过id来获取到实例)
 *  @param objectIDs ~>NSArray ~> NSManagedObjectID
 *  @return 实例
 */
- (NSArray *)objectsWithObjectIDs:(NSArray *)objectIDs;

- (NSArray *)objectsWithURIRepresentations:(NSArray *)URIRepresentations;
@end
