//
//  AppDelegate.h
//  BankAccount
//
//  Created by Rajesh on 9/22/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerController.h"
#import "Entity.h"

typedef enum {
    kFromDate = 1,
    kToDate
}DateFieldType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)appDelegate;

+ (void)showDatePickerWithDelegate:(id<DatePickerDelegate>)delegate andDateSelected:(NSDate *)date;

@property(nonatomic,strong)NSMutableArray *arrAllEntities;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (BOOL)saveEntryWithUpdateBalaceArray:(NSArray *)arrRows andIsExpense:(BOOL)isExpense;
- (NSString *)stringFormDate:(NSDate *)date;
- (NSDate *)dateFromString:(NSString *)stringDate;
- (float)getBalanceBetweenDates:(NSDate *)dateFrom andToDate:(NSDate *)dateTo;
- (NSArray *)getEntriesBetweenDates:(NSDate *)dateFrom andToDate:(NSDate *)dateTo;
@end

