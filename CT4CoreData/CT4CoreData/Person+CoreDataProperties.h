//
//  Person+CoreDataProperties.h
//  CT4CoreData
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Phone *> *phones;

@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addPhonesObject:(Phone *)value;
- (void)removePhonesObject:(Phone *)value;
- (void)addPhones:(NSSet<Phone *> *)values;
- (void)removePhones:(NSSet<Phone *> *)values;

@end

NS_ASSUME_NONNULL_END
