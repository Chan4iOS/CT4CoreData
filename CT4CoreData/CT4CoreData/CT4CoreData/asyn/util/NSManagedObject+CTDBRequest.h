//
//  NSManagedObject+CTDBRequest.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (CTDBRequest)
/**
 *  @brief 获取entity的名称
 *  @return entity的名称
 */
+(NSString *)CTA_entityName;
/**
 *  @brief 获取全部
 *  @return 请求
 */
+(NSFetchRequest *)CTA_allRequest;
/**
 *  @brief 随意获取一个实例
 *  @return 请求
 */
+(NSFetchRequest *)CTA_anyoneRequest;
/**
 *  @brief 按条件搜索
 *  @param limit 限制数目
 *  @param batchSize 取数据的数目
 *  @return 请求
 */
+(NSFetchRequest *)CTA_requestWithFetchLimit:(NSUInteger)limit
                                  batchSize:(NSUInteger)batchSize;
/**
 *  @brief 按条件搜索
 *  @param limit 限制数目
 *  @batchSize 取数据的数目
 *  @fetchOffset 取数据的起始点
 *  @return 请求
 */
+(NSFetchRequest *)CTA_requestWithFetchLimit:(NSUInteger)limit
                                  batchSize:(NSUInteger)batchSize
                                fetchOffset:(NSUInteger)fetchOffset;
@end
