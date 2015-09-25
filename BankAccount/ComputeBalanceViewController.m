//
//  ComputeBalanceViewController.m
//  BankAccount
//
//  Created by Rajesh on 9/22/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import "ComputeBalanceViewController.h"
#import "UpdateBalanceViewController.h"
#import "AppDelegate.h"

@interface ComputeBalanceViewController ()<DatePickerDelegate>
{
    __weak IBOutlet UITextField *txtFromDate;
    __weak IBOutlet UITextField *txtToDate;
    __weak IBOutlet UILabel *lblDisplay;
    DateFieldType dateFldType;
}
@end

@implementation ComputeBalanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Compute Balance"];
    [lblDisplay setNumberOfLines:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldBeginEditing:(BATextField *)textField
{
    dateFldType = [textField tag] == 1 ? kFromDate: kToDate;
    [AppDelegate showDatePickerWithDelegate:self andDateSelected:[NSDate date]];
    return NO;
}

- (void)dateSelected:(NSDate *)date
{
    switch (dateFldType)
    {
        case kFromDate:
            [txtFromDate setText:[[AppDelegate appDelegate] stringFormDate:date]];
            break;
        case kToDate:
            [txtToDate setText:[[AppDelegate appDelegate] stringFormDate:date]];
            break;
        default:
            break;
    }
    if (!txtFromDate.text.length  ||  !txtToDate.text.length) return;

    if (![self validateDatesBetweenDates:[[AppDelegate appDelegate] dateFromString:txtFromDate.text] andToDate:[[AppDelegate appDelegate] dateFromString:txtToDate.text]])
    {
        [lblDisplay setText:@"Invalid period choosen"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"To date must be greater than From date" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (BOOL)validateDatesBetweenDates:(NSDate *)dateFrom andToDate:(NSDate *)dateTo
{
    NSTimeInterval interval = [dateTo timeIntervalSinceDate:dateFrom];
        if (interval > 0)
        {
            float fBalance = [[AppDelegate appDelegate] getBalanceBetweenDates:dateFrom andToDate:dateTo];
            if (fBalance == 0)
            {
                [lblDisplay setText:@"Balance not available for selected period"];
            }
            else
            [lblDisplay setText:[NSString stringWithFormat:@"Your balance for selected period would be around %2.f $",fBalance]];
            return YES;
        }
    return NO;
}

@end
