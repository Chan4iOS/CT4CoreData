//
//  NSManagedObject+CTMapping.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CTManageObjectMappingProtocol.h"
@interface NSManagedObject (CTMapping)
-(void)mergeAttributeForKey:(NSString *)attributeName withValue:(id)value;
-(void)mergeRelationshipForKey:(NSString *)relationshipName withValue:(id)value mergePolicy:(CTRelationshipMergePolicy)policy;

-(NSArray *)allAttributeNames;
-(NSArray *)allRelationshipNames;
-(NSAttributeDescription *)attributeDescriptionForAttribute:(NSString *)attributeName;
-(NSRelationshipDescription *)relationshipDescriptionForRelationship:(NSString *)relationshipName;
@end
