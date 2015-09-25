//
//  Entity.h
//  BankAccount
//
//  Created by Rajesh on 9/22/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


typedef enum {
    kDate = 0,
    kCategory,
    kAmount,
    kIsRecurring,
}BAFieldType;

NS_ASSUME_NONNULL_BEGIN

@interface UpdateBalanceRow : NSObject

@property(nonatomic,strong)NSString *strName;
@property(nonatomic,strong)NSString *strValue;
@property(nonatomic,strong)id value;
@property(nonatomic,assign) BAFieldType type;

@end


@interface Entity : NSManagedObject

- (void)configureEntity:(NSArray *)arrRows andIsExpense:(BOOL)isExpense;

@end

NS_ASSUME_NONNULL_END

#import "Entity+CoreDataProperties.h"
