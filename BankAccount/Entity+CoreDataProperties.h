//
//  Entity+CoreDataProperties.h
//  BankAccount
//
//  Created by Rajesh on 9/22/15.
//  Copyright © 2015 Org. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSDecimalNumber *amount;
@property (nullable, nonatomic, retain) NSNumber *isRecurring;
@property (nullable, nonatomic, retain) NSNumber *isExpense;

@end

NS_ASSUME_NONNULL_END
