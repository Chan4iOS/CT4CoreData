//
//  Person.m
//  CT4CoreData
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "Person.h"
#import "Phone.h"
#import "CT4CoreData.h"

@implementation Person

// Insert code here to add functionality to your managed object subclass
/**
 *  @brief 同步库的 mapping
    被代替的键放在前面 （后面是属性名）
 */
+(NSDictionary *)cts_mappings{
    return @{@"Name":@"name"};
}
/**
 *  @brief 同步库的主键
 */
+ (NSString *)cts_primaryKey{
    return @"name";
}
/**
 *  @brief 异步库的mapping
 *  被代替的键放在后面  （前面是属性名）
 */
+(NSDictionary *)CTA_JSONKeyPathsByPropertyKey{
    return @{@"name":@"Name"};
    
}
/**
 *  @brief 异步库的主键，支持多主键
 */
+(NSSet*)CTA_uniquedPropertyKeys{
    return [[NSSet alloc]initWithArray:@[@"name"]];
}

@end
