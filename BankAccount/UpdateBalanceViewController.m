//
//  UpdateBalanceViewController.m
//  BankAccount
//
//  Created by Rajesh on 9/22/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import "UpdateBalanceViewController.h"
#import "Entity+CoreDataProperties.h"
#import "AppDelegate.h"

@implementation BATextField

@end

@interface UpdateBalanceViewController ()<DatePickerDelegate>
{
    NSMutableArray *arrUpdateBalaceDataSource;
    BOOL isExpenseMode;
    __weak IBOutlet UITableView *tableView;
}
@end

@implementation UpdateBalanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Update balance"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveTapped)]];
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender
{
    isExpenseMode = sender.selectedSegmentIndex == 1;
}

- (void)saveTapped
{
    for (UpdateBalanceRow *aRow in arrUpdateBalaceDataSource)
    {
        if (!aRow.strValue)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter all values" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
    }
    if ([[AppDelegate appDelegate] saveEntryWithUpdateBalaceArray:arrUpdateBalaceDataSource andIsExpense:isExpenseMode])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Saved successfully" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Error while saving" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)loadDataSource
{
    arrUpdateBalaceDataSource = [NSMutableArray array];
    UpdateBalanceRow *row = [UpdateBalanceRow new];
    [row setStrName:@"Date"];
    [row setType:kDate];
    [arrUpdateBalaceDataSource addObject:row];
    
    row = [UpdateBalanceRow new];
    [row setStrName:@"Category"];
    [row setType:kCategory];
    [arrUpdateBalaceDataSource addObject:row];
    
    row = [UpdateBalanceRow new];
    [row setStrName:@"Amount in $"];
    [row setType:kAmount];
    [arrUpdateBalaceDataSource addObject:row];
    
    row = [UpdateBalanceRow new];
    [row setStrName:@"Recurring"];
    [row setType:kIsRecurring];
    [arrUpdateBalaceDataSource addObject:row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrUpdateBalaceDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableViewL cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableViewL dequeueReusableCellWithIdentifier:@"UpdateInfoTblCell" forIndexPath:indexPath];
    UpdateBalanceRow *row = [arrUpdateBalaceDataSource objectAtIndex:indexPath.row];
    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:1];
    [lblName setText:row.strName];
    BATextField *txtValue = (BATextField *)[cell.contentView viewWithTag:2];
    [txtValue setText:row.strValue];
    [txtValue setIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(BATextField *)textField
{
    switch (textField.indexPath.row)
    {
        case kDate:
            [self.view endEditing:YES];
            [AppDelegate showDatePickerWithDelegate:self andDateSelected:[NSDate date]];
            return NO;
            break;
        case kAmount:
            [textField setKeyboardType:UIKeyboardTypeDecimalPad];
            break;
        case kIsRecurring:
        {
            [self.view endEditing:YES];
            UpdateBalanceRow *row = [arrUpdateBalaceDataSource objectAtIndex:textField.indexPath.row];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Recurring" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [textField setText:@"Yes"];
                [row setStrValue:textField.text];
                [row setValue:@YES];
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ad-Hoc" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [textField setText:@"No"];
                [row setStrValue:textField.text];
                [row setValue:@NO];
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }]];
            alertController.popoverPresentationController.sourceView = textField;
            [self presentViewController:alertController animated:YES completion:nil];
            return NO;
        }
            break;
        default:
            break;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(BATextField *)textField
{
    UpdateBalanceRow *row = [arrUpdateBalaceDataSource objectAtIndex:textField.indexPath.row];
    [row setStrValue:textField.text];
    [row setValue:textField.text];
}

- (void)dateSelected:(NSDate *)date
{
    UpdateBalanceRow *row = [arrUpdateBalaceDataSource objectAtIndex:0];
    [row setStrValue:[[AppDelegate appDelegate] stringFormDate:date]];
    [row setValue:date];
    [tableView reloadData];
}
@end
