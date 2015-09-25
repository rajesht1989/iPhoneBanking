//
//  DatePickerController.m
//  iDatePickerComponent
//
//  Created by Rajesh on 9/21/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import "DatePickerController.h"
#import "AppDelegate.h"

@interface DatePickerController ()
{
    UIDatePicker *datePicker;
    UILabel *lblDisplay;
    UIView *vwBg;
}
@end

@implementation DatePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped)]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Select date"];
    [self configureDatePicker];
    if (_isModal)
    {
        lblDisplay = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, self.view.bounds.size.width - 40, 30)];
        [lblDisplay setAutoresizingMask: UIViewAutoresizingFlexibleWidth];
        [lblDisplay setFont:[UIFont boldSystemFontOfSize:17]];
        [lblDisplay setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:lblDisplay];
        [lblDisplay setText:[[AppDelegate appDelegate] stringFormDate:datePicker.date]];
    }
    else
    {
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        UIView *vwbutton  = [[UIView alloc] initWithFrame:CGRectMake(0, datePicker.frame.origin.y - 40, datePicker.frame.size.width, 40)];
        [vwbutton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [self.view addSubview:vwbutton];
        [vwbutton setBackgroundColor:[UIColor whiteColor]];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [btnCancel setFrame:CGRectMake(10, 10, 50, 20)];
        [btnCancel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [btnCancel addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
        [vwbutton addSubview:btnCancel];
        
        lblDisplay = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, vwbutton.bounds.size.width - 160, 20)];
        [lblDisplay setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
        [lblDisplay setFont:[UIFont boldSystemFontOfSize:17]];
        [lblDisplay setTextAlignment:NSTextAlignmentCenter];
        [vwbutton addSubview:lblDisplay];
        [lblDisplay setText:[[AppDelegate appDelegate] stringFormDate:datePicker.date]];
        
        UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnDone setTitle:@"Done" forState:UIControlStateNormal];
        [btnDone setFrame:CGRectMake(self.view.bounds.size.width - 60, 10, 50, 20)];
        [btnDone setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [btnDone addTarget:self action:@selector(doneTapped) forControlEvents:UIControlEventTouchUpInside];
        [vwbutton addSubview:btnDone];
    }
}

- (void)completionAction
{
     vwBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, datePicker.frame.size.width, datePicker.frame.origin.y - 40)];
    [vwBg setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:vwBg];
    [self.view sendSubviewToBack:vwBg];
    [vwBg setBackgroundColor:[UIColor colorWithWhite:.2 alpha:0]];
    [UIView animateWithDuration:.1 animations:^{
        [self.view setBackgroundColor:[UIColor colorWithWhite:.2 alpha:.2]];
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelTapped)];
    [vwBg addGestureRecognizer:tapGesture];
}

- (void)configureDatePicker
{
    datePicker = [[UIDatePicker alloc] init];
    CGRect rect = datePicker.frame;
    rect.origin.x = 0;
    rect.origin.y = self.view.bounds.size.height - rect.size.height;
    rect.size.width = self.view.bounds.size.width;
    datePicker.frame = rect;
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    if (_dateSelected) [datePicker setDate:_dateSelected animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)cancelTapped
{
    if (_isModal)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.view setBackgroundColor:[UIColor clearColor]];
        [vwBg removeFromSuperview];
        [UIView animateWithDuration:.3 animations:^{
            CGRect rect = self.view.frame;
            rect.origin.y = 256;
            [self.view setFrame:rect];
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
        }];
    }
}

- (void)doneTapped
{
    [_delegate dateSelected:[datePicker date]];
    [self cancelTapped];
}

- (void)datePickerValueChanged:(UIDatePicker *)datepickr
{
    [lblDisplay setText:[[AppDelegate appDelegate] stringFormDate:datepickr.date]];
}

@end
