//
//  Entity.m
//  BankAccount
//
//  Created by Rajesh on 9/22/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import "Entity.h"

@implementation UpdateBalanceRow

@end

@implementation Entity

- (void)configureEntity:(NSArray *)arrRows andIsExpense:(BOOL)isExpense;
{
    self.isExpense = @(isExpense);
    for (UpdateBalanceRow *aRow in  arrRows)
    {
        switch ([arrRows indexOfObject:aRow])
        {
            case kDate:
                [self setDate:aRow.value];
                break;
            case kCategory:
                [self setCategory:aRow.value];
                break;
            case kAmount:
                [self setAmount:[NSDecimalNumber decimalNumberWithString:aRow.value]];
                break;
            case kIsRecurring:
                [self setIsRecurring:aRow.value];
                break;
            default:
                break;
        }
    }
}
@end
