//
//  Phone+CoreDataProperties.h
//  CT4CoreData
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Phone.h"

NS_ASSUME_NONNULL_BEGIN

@interface Phone (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *phoneVersion;
@property (nullable, nonatomic, retain) Person *owner;

@end

NS_ASSUME_NONNULL_END
