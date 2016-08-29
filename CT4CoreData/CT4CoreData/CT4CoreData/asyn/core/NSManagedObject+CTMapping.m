//
//  NSManagedObject+CTMapping.m
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "NSManagedObject+CTMapping.h"
#import "NSManagedObject+CTConvenience.h"
#import "NSManagedObject+CTCreate.h"
#import "NSManagedObject+CTManagedObjectContext.h"
#import "NSManagedObject+CTDBRequest.h"
#import "NSManagedObject+CTCreate.h"
@implementation NSManagedObject (CTMapping)
- (void)mergeAttributeForKey:(NSString *)attributeName withValue:(id)value {
    NSAttributeDescription *attributeDes = [self attributeDescriptionForAttribute:attributeName];
    
    if (value != [NSNull null]) {
        switch (attributeDes.attributeType) {
            case NSDecimalAttributeType:
            case NSInteger16AttributeType:
            case NSInteger32AttributeType:
            case NSInteger64AttributeType:
            case NSDoubleAttributeType:
            case NSFloatAttributeType:
                [self setValue:numberFromString([value description]) forKey:attributeName];
                break;
            case NSBooleanAttributeType:
                [self setValue:[NSNumber numberWithBool:[value boolValue]] forKey:attributeName];
                break;
            case NSDateAttributeType:{
                if([value isKindOfClass:[NSNumber class]]){
                    [self setValue:dateFromNsNumber(value) forKey:attributeName];
                }else{
                    [self setValue:dateFromString(value) forKey:attributeName];
                }
            }
            case NSObjectIDAttributeType:
            case NSBinaryDataAttributeType:
            case NSStringAttributeType:{
                if([value isKindOfClass:[NSString class]]){
                    [self setValue:[value description] forKey:attributeName];
                    break;
                }
            }
                
            case NSTransformableAttributeType:
            case NSUndefinedAttributeType:
                break;
            default:
                break;
        }
    }
}

- (void)mergeRelationshipForKey:(NSString *)relationshipName withValue:(id)value mergePolicy:(CTRelationshipMergePolicy)policy {
    if ([value isEqual:[NSNull null]]) {
        return;
    }
    NSRelationshipDescription *relationshipDes = [self relationshipDescriptionForRelationship:relationshipName];
    NSString *desClassName = relationshipDes.destinationEntity.managedObjectClassName;
    if (relationshipDes.isToMany) {
        NSArray *destinationObjs = [NSClassFromString(desClassName) CTA_newOrUpdateWithJSONs:value inContext:self.managedObjectContext];
        if (destinationObjs != nil && destinationObjs.count > 0) {
            if (policy == CTRelationshipMergePolicyAdd) {
                if(relationshipDes.isOrdered) {
                    NSMutableOrderedSet *localOrderedSet = [self mutableOrderedSetValueForKey:relationshipName];
                    [localOrderedSet addObjectsFromArray:destinationObjs];
                    [self setValue:localOrderedSet forKey:relationshipName];
                }
                else {
                    NSMutableSet *localSet = [self mutableSetValueForKey:relationshipName];
                    [localSet addObjectsFromArray:destinationObjs];
                    [self setValue:localSet forKey:relationshipName];
                }
            }else{
                if (relationshipDes.isOrdered) {
                    NSMutableOrderedSet *localOrderedSet = [self mutableOrderedSetValueForKey:relationshipName];
                    [localOrderedSet removeAllObjects];
                    [localOrderedSet addObjectsFromArray:destinationObjs];
                    [self setValue:localOrderedSet forKey:relationshipName];
                }else{
                    [self setValue:[NSSet setWithArray:destinationObjs] forKey:relationshipName];
                }
            }
        }
    }else{
        id destinationObjs = [NSClassFromString(desClassName) CTA_newOrUpdateWithJSON:value inContext:self.managedObjectContext];
        [self setValue:destinationObjs forKey:relationshipName];
    }
    
}

#pragma mark - private methods

- (NSArray *)allAttributeNames {
    return self.entity.attributesByName.allKeys;
}

- (NSArray *)allRelationshipNames {
    return self.entity.relationshipsByName.allKeys;
}

- (NSAttributeDescription *)attributeDescriptionForAttribute:(NSString *)attributeName {
    return [self.entity.attributesByName objectForKey:attributeName];
}

- (NSRelationshipDescription *)relationshipDescriptionForRelationship:(NSString *)relationshipName {
    return [self.entity.relationshipsByName objectForKey:relationshipName];
}

#pragma mark - transform methods

NSDate * dateFromString(NSString *value) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    
    NSDate *parsedDate = [formatter dateFromString:value];
    
    return parsedDate;
}
NSDate * dateFromNsNumber(NSNumber *value) {
    
#warning ----modify by 翰
    if (log10([value floatValue])>10) {
        return [NSDate dateWithTimeIntervalSince1970:[value floatValue]*0.001];
    }
    return [NSDate dateWithTimeIntervalSince1970:[value floatValue]];
}


NSNumber * numberFromString(NSString *value) {
    return [NSNumber numberWithDouble:[value doubleValue]];
}

@end
