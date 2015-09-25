//
//  AppDelegate.m
//  BankAccount
//
//  Created by Rajesh on 9/22/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Entity.h"
#import "UpdateBalanceViewController.h"


@interface AppDelegate ()
{
    NSDateFormatter *dateFormatter;
}
@end

@implementation AppDelegate
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"IST"]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
+ (instancetype)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)saveEntryWithUpdateBalaceArray:(NSArray *)arrRows andIsExpense:(BOOL)isExpense
{
    Entity *entityToBeSaved = [NSEntityDescription insertNewObjectForEntityForName:@"BankAccount" inManagedObjectContext:[self managedObjectContext]];
    [entityToBeSaved configureEntity:arrRows andIsExpense:isExpense];
    NSError *error;
    if (![[self managedObjectContext] save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

- (NSMutableArray *)arrAllEntities
{
    if (!_arrAllEntities)
    {
        _arrAllEntities = [NSMutableArray new];
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"BankAccount"];
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        if (error)
        {
            NSLog(@"Error occured %@",error);
        }
        else {
            for (Entity *entity in results)
            {
                [_arrAllEntities addObject:entity];
            }
        }
    }
    return _arrAllEntities;
}

- (NSArray *)getEntriesBetweenDates:(NSDate *)dateFrom andToDate:(NSDate *)dateTo
{
    if (!dateTo)
    {
        dateTo = [dateFrom dateByAddingTimeInterval:86400]; //One day
    }
        NSManagedObjectContext *context = [self managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"BankAccount"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"(date > %@) AND (date <= %@)",dateFrom,dateTo]];
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        if (error)
        {
            NSLog(@"Error occured %@",error);
        }
    return results;
}



- (float)getBalanceBetweenDates:(NSDate *)dateFrom andToDate:(NSDate *)dateTo
{
    NSArray *arrEntries = [self getEntriesBetweenDates:dateFrom andToDate:dateTo];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:dateFrom  toDate:dateTo  options:0];
    NSInteger months = [comps month];
    float fBalance = .0f;
    for (Entity *aEntity in arrEntries)
    {
        float fEntityAmount = .0f;
        if ([[aEntity isExpense] boolValue])
        {
            fEntityAmount = - [[aEntity amount] floatValue];
        }
        else
        {
            fEntityAmount = [[aEntity amount] floatValue];
        }
        
        if ([[aEntity isRecurring] boolValue] && months)
        {
            fEntityAmount = fEntityAmount*months;
        }
        fBalance += fEntityAmount;
    }
    return fBalance;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BankAccountModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BankAccountModel.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

DatePickerController *datePickerController;
+ (void)showDatePickerWithDelegate:(id<DatePickerDelegate>)delegate andDateSelected:(NSDate *)date
{
    datePickerController = [[DatePickerController alloc] init];
    [datePickerController setDelegate:delegate];
    [datePickerController setDateSelected:date];
    CGRect rect = datePickerController.view.frame;
    rect.origin.y = 256;
    [datePickerController.view setFrame:rect];
    [[self topMostController].view addSubview:datePickerController.view];
    
    [UIView animateWithDuration:.3 animations:^{
        CGRect rect = datePickerController.view.frame;
        rect.origin.y = 0;
        [datePickerController.view setFrame:rect];
    } completion:^(BOOL finished) {
        [datePickerController completionAction];
    }];
    
}
+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    return topController;
}
- (NSString *)stringFormDate:(NSDate *)date
{
    return [dateFormatter stringFromDate:date];
}
- (NSDate *)dateFromString:(NSString *)stringDate
{
    return [dateFormatter dateFromString:stringDate];
}

@end
