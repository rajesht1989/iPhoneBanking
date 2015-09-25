//
//  Entity+CoreDataProperties.m
//  BankAccount
//
//  Created by Rajesh on 9/22/15.
//  Copyright © 2015 Org. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entity+CoreDataProperties.h"

@implementation Entity (CoreDataProperties)

@dynamic date;
@dynamic category;
@dynamic amount;
@dynamic isRecurring;
@dynamic isExpense;

@end
