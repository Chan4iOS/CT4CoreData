//
//  CTManageObjectMappingProtocol.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CTRelationshipMergePolicy) {
    CTRelationshipMergePolicyAdd,//default
    CTRelationshipMergePolicyRepalce
};

@protocol CTManageObjectMappingProtocol <NSObject>
/**
 *  @brief 转换的时候对应起来
 */
+(NSDictionary *)CTA_JSONKeyPathsByPropertyKey;

@optional

/**
 *  @brief 唯一的键位  用来插入数据的时候查重
 */
+(NSSet *)CTA_uniquedPropertyKeys;

@end