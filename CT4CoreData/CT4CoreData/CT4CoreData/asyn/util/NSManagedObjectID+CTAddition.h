//
//  NSManagedObjectID+CTAddition.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectID (CTAddition)
- (NSString *)stringRepresentation;

+ (instancetype)objectIDWithURIRepresentation:(NSString *)URIRepresentation;

@end
