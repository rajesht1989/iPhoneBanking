//
//  AnalyzeBalanceViewController.m
//  BankAccount
//
//  Created by Rajesh on 9/23/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import "AnalyzeBalanceViewController.h"
#import "XYPieChart.h"
#import "AppDelegate.h"
#import "UpdateBalanceViewController.h"

@interface AnalyzeBalanceViewController ()<XYPieChartDataSource,DatePickerDelegate>
{
    __weak IBOutlet UITextField *txtFromDate;
    __weak IBOutlet XYPieChart *chartView;
    NSMutableArray *arrExpenses;
}
@end

@implementation AnalyzeBalanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Analyze Balance"];
    [chartView setDataSource:self];
    [chartView setDataSource:self];
    [chartView setStartPieAngle:M_PI_2];
    [chartView setAnimationSpeed:1.0];
    [chartView setShowPercentage:NO];
    [chartView setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [chartView setUserInteractionEnabled:NO];
    [chartView setLabelShadowColor:[UIColor grayColor]];
    [chartView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldBeginEditing:(BATextField *)textField
{
    [AppDelegate showDatePickerWithDelegate:self andDateSelected:[NSDate date]];
    return NO;
}

- (void)dateSelected:(NSDate *)date
{
    [txtFromDate setText:[[AppDelegate appDelegate] stringFormDate:date]];
    if (!txtFromDate.text.length) return;
    
    NSArray *arrAllEntries = [[AppDelegate appDelegate] getEntriesBetweenDates:[[AppDelegate appDelegate] dateFromString:txtFromDate.text] andToDate:nil];
    arrExpenses = [NSMutableArray array];
    
    for (Entity *entity in arrAllEntries)
    {
        if ([entity isExpense])
        {
            [arrExpenses addObject:entity];
        }
    }
    
    if ([arrExpenses count])
    {
        [chartView setHidden:NO];
        [chartView reloadData];
    }
    else
    {
        [chartView setHidden:YES];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"No entries available for the selected date" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return arrExpenses.count;
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[(Entity *)(arrExpenses[index]) amount] floatValue];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    return [NSString stringWithFormat:@"%@ - %.2f$",[(Entity *)(arrExpenses[index]) category],[[(Entity *)(arrExpenses[index]) amount] floatValue]];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
